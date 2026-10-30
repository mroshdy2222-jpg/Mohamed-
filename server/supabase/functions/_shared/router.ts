import type { Image, Provider } from './providers.ts';
import { parseTags, PersonInPhoto, prompt, type Tags } from './tagging.ts';

export interface Tagged {
  tags: Tags;
  provider: string;
}

/** Tries each provider in order until one returns valid tags. A photo of a
 * person stops the chain at once: no other provider gets to see it. */
export async function tagWithFallback(providers: Provider[], image: Image): Promise<Tagged> {
  const errors: string[] = [];
  for (const p of providers) {
    try {
      const tags = parseTags(await p.complete(image, prompt));
      return { tags, provider: p.name };
    } catch (e) {
      if (e instanceof PersonInPhoto) throw e;
      errors.push(`${p.name}: ${(e as Error).message}`);
    }
  }
  throw new Error(`all_providers_failed (${errors.join('; ')})`);
}
