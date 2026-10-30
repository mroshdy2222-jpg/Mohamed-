// POST { image: base64, mime } with the user's Supabase session.
// Returns { tags, provider } or { error }. The photo is not stored.
import { gemini, openRouter, type Provider } from '../_shared/providers.ts';
import { tagWithFallback } from '../_shared/router.ts';
import { PersonInPhoto } from '../_shared/tagging.ts';

const maxBytes = 1_500_000;

function providers(): Provider[] {
  const list: Provider[] = [];
  const g = Deno.env.get('GEMINI_API_KEY');
  if (g) list.push(gemini(g, Deno.env.get('GEMINI_MODEL') ?? 'gemini-2.5-flash'));
  const o = Deno.env.get('OPENROUTER_API_KEY');
  const oModel = Deno.env.get('OPENROUTER_MODEL');
  if (o && oModel) list.push(openRouter(o, oModel));
  return list;
}

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { 'content-type': 'application/json' } });

Deno.serve(async (req) => {
  if (req.method !== 'POST') return json({ error: 'method' }, 405);
  // Supabase checks the session token before the request reaches here.
  let body: { image?: string; mime?: string };
  try {
    body = await req.json();
  } catch {
    return json({ error: 'bad_json' }, 400);
  }
  if (!body.image || !body.mime?.startsWith('image/')) return json({ error: 'missing_image' }, 400);
  if (body.image.length * 0.75 > maxBytes) return json({ error: 'too_large' }, 413);

  const list = providers();
  if (list.length === 0) return json({ error: 'not_configured' }, 503);
  try {
    return json(await tagWithFallback(list, { base64: body.image, mime: body.mime }));
  } catch (e) {
    if (e instanceof PersonInPhoto) return json({ error: 'person_in_photo' }, 422);
    return json({ error: 'unavailable' }, 502);
  }
});
