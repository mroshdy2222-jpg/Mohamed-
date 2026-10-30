// What the model must return for a clothing photo, and how its answer is
// checked. Only names the app knows survive; anything else becomes null so
// the user picks it by hand.

export const categories = ['top', 'bottom', 'onePiece', 'outerwear', 'shoes', 'bag', 'headscarf', 'shemagh', 'accessory'] as const;
export const styles = ['lounge', 'sport', 'casual', 'drip', 'smartCasual', 'formal', 'dressy', 'traditional'] as const;
export const patterns = ['solid', 'striped', 'checked', 'printed'] as const;
export const seasons = ['summer', 'winter', 'all'] as const;
export const colors = [
  'white', 'cream', 'black', 'grey', 'navy', 'denim', 'beige', 'camel', 'brown', 'olive', 'khaki',
  'red', 'burgundy', 'pink', 'blush', 'orange', 'mustard', 'yellow', 'green', 'emerald', 'teal',
  'sky', 'blue', 'lavender', 'purple',
] as const;

export interface Tags {
  category: (typeof categories)[number] | null;
  color: (typeof colors)[number] | null;
  pattern: (typeof patterns)[number] | null;
  season: (typeof seasons)[number] | null;
  styles: (typeof styles)[number][];
}

/** The model saw a person instead of a garment; nothing is tagged or kept. */
export class PersonInPhoto extends Error {
  constructor() {
    super('person_in_photo');
  }
}

export const prompt = `You tag one piece of clothing for a wardrobe app used in Egypt and the Gulf.
Reply with JSON only, no prose, in exactly this shape:
{"category": one of ${JSON.stringify(categories)},
 "color": the nearest of ${JSON.stringify(colors)},
 "pattern": one of ${JSON.stringify(patterns)},
 "season": one of ${JSON.stringify(seasons)},
 "styles": one to three of ${JSON.stringify(styles)}}
Notes: an abaya, thobe, galabeya, kaftan or dress is "onePiece". A hijab or shayla is "headscarf".
"traditional" is for abayas, thobes, galabeyas, kaftans and shemaghs. "drip" is loud streetwear and statement sneakers.
If the photo shows a person's face or body rather than a garment on its own, reply {"rejected": "person"} and nothing else.`;

function pick<T extends string>(allowed: readonly T[], value: unknown): T | null {
  return typeof value === 'string' && (allowed as readonly string[]).includes(value) ? (value as T) : null;
}

/** Parses the model's text. Throws on non-JSON so the router tries the next provider. */
export function parseTags(text: string): Tags {
  const start = text.indexOf('{');
  const end = text.lastIndexOf('}');
  if (start < 0 || end <= start) throw new Error('no_json');
  const raw = JSON.parse(text.slice(start, end + 1)) as Record<string, unknown>;
  if (raw.rejected === 'person') throw new PersonInPhoto();
  const styleList = Array.isArray(raw.styles) ? raw.styles : [];
  return {
    category: pick(categories, raw.category),
    color: pick(colors, raw.color),
    pattern: pick(patterns, raw.pattern),
    season: pick(seasons, raw.season),
    styles: [...new Set(styleList.map((s) => pick(styles, s)).filter((s): s is Tags['styles'][number] => s !== null))].slice(0, 3),
  };
}
