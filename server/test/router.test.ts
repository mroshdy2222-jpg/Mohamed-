import assert from 'node:assert/strict';
import { test } from 'node:test';

import { gemini, openRouter, type Provider } from '../supabase/functions/_shared/providers.ts';
import { tagWithFallback } from '../supabase/functions/_shared/router.ts';
import { parseTags, PersonInPhoto } from '../supabase/functions/_shared/tagging.ts';

const image = { base64: 'aGVsbG8=', mime: 'image/jpeg' };
const good = '{"category":"onePiece","color":"burgundy","pattern":"solid","season":"winter","styles":["dressy","traditional"]}';

function fake(name: string, reply: () => Promise<string>, calls: string[] = []): Provider {
  return { name, free: true, complete: async () => (calls.push(name), reply()) };
}

test('valid tags come back as app names', () => {
  assert.deepEqual(parseTags(good), {
    category: 'onePiece',
    color: 'burgundy',
    pattern: 'solid',
    season: 'winter',
    styles: ['dressy', 'traditional'],
  });
});

test('unknown values become null, extra styles are dropped, text around the JSON is ignored', () => {
  const tags = parseTags('Sure! {"category":"tunic","color":"maroon","styles":["casual","casual","boho","drip","formal","sport"]} hope it helps');
  assert.equal(tags.category, null);
  assert.equal(tags.color, null);
  assert.deepEqual(tags.styles, ['casual', 'drip', 'formal']);
});

test('the router falls through failures and rate limits to the next provider', async () => {
  const calls: string[] = [];
  const result = await tagWithFallback(
    [
      fake('a', async () => { throw new Error('http_429'); }, calls),
      fake('b', async () => 'not json', calls),
      fake('c', async () => good, calls),
    ],
    image,
  );
  assert.equal(result.provider, 'c');
  assert.deepEqual(calls, ['a', 'b', 'c']);
});

test('a photo of a person stops the chain: no other provider sees it', async () => {
  const calls: string[] = [];
  await assert.rejects(
    tagWithFallback([fake('a', async () => '{"rejected":"person"}', calls), fake('b', async () => good, calls)], image),
    PersonInPhoto,
  );
  assert.deepEqual(calls, ['a']);
});

test('all providers failing is reported', async () => {
  await assert.rejects(tagWithFallback([fake('a', async () => { throw new Error('down'); })], image), /all_providers_failed/);
});

test('Gemini request shape: key in a header, image inline, JSON reply', async () => {
  let seen: { url: string; init: RequestInit } | undefined;
  const f = (async (url: string, init: RequestInit) => {
    seen = { url, init };
    return new Response(JSON.stringify({ candidates: [{ content: { parts: [{ text: good }] } }] }));
  }) as typeof fetch;
  const text = await gemini('KEY', 'gemini-2.5-flash', f).complete(image, 'p');
  assert.equal(text, good);
  assert.match(seen!.url, /models\/gemini-2\.5-flash:generateContent$/);
  assert.doesNotMatch(seen!.url, /KEY/);
  assert.equal((seen!.init.headers as Record<string, string>)['x-goog-api-key'], 'KEY');
  const body = JSON.parse(seen!.init.body as string);
  assert.equal(body.contents[0].parts[1].inline_data.data, image.base64);
});

test('OpenRouter request shape, and only ":free" models count as free', async () => {
  let body: any;
  const f = (async (_url: string, init: RequestInit) => {
    body = JSON.parse(init.body as string);
    return new Response(JSON.stringify({ choices: [{ message: { content: good } }] }));
  }) as typeof fetch;
  const p = openRouter('KEY', 'some/vision-model:free', f);
  assert.equal(await p.complete(image, 'p'), good);
  assert.equal(p.free, true);
  assert.equal(openRouter('KEY', 'some/paid-model', f).free, false);
  assert.equal(body.messages[0].content[1].image_url.url, 'data:image/jpeg;base64,aGVsbG8=');
});

test('an HTTP error from a provider is an error, so the router moves on', async () => {
  const f = (async () => new Response('limit', { status: 429 })) as typeof fetch;
  await assert.rejects(gemini('K', 'm', f).complete(image, 'p'), /http_429/);
});
