// Vision providers behind one interface. Each returns the model's raw text;
// the router parses it and moves on to the next provider on any failure.

export interface Image {
  base64: string;
  mime: string;
}

export interface Provider {
  name: string;
  /** Free tiers may use what they receive for training; never send faces. */
  free: boolean;
  complete(image: Image, prompt: string): Promise<string>;
}

type Fetch = typeof fetch;

async function postJson(f: Fetch, url: string, headers: Record<string, string>, body: unknown): Promise<any> {
  const res = await f(url, { method: 'POST', headers: { 'content-type': 'application/json', ...headers }, body: JSON.stringify(body) });
  if (!res.ok) throw new Error(`http_${res.status}`);
  return res.json();
}

/** Google Gemini through AI Studio: has a free tier with daily limits. */
export function gemini(apiKey: string, model: string, f: Fetch = fetch): Provider {
  return {
    name: `gemini:${model}`,
    free: true,
    async complete(image, prompt) {
      const json = await postJson(
        f,
        `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`,
        { 'x-goog-api-key': apiKey },
        {
          contents: [{ parts: [{ text: prompt }, { inline_data: { mime_type: image.mime, data: image.base64 } }] }],
          generationConfig: { responseMimeType: 'application/json', temperature: 0 },
        },
      );
      const text = json?.candidates?.[0]?.content?.parts?.[0]?.text;
      if (typeof text !== 'string') throw new Error('empty');
      return text;
    },
  };
}

/** OpenRouter: one key for many models; models ending in ":free" cost nothing. */
export function openRouter(apiKey: string, model: string, f: Fetch = fetch): Provider {
  return {
    name: `openrouter:${model}`,
    free: model.endsWith(':free'),
    async complete(image, prompt) {
      const json = await postJson(
        f,
        'https://openrouter.ai/api/v1/chat/completions',
        { authorization: `Bearer ${apiKey}` },
        {
          model,
          temperature: 0,
          messages: [
            {
              role: 'user',
              content: [
                { type: 'text', text: prompt },
                { type: 'image_url', image_url: { url: `data:${image.mime};base64,${image.base64}` } },
              ],
            },
          ],
        },
      );
      const text = json?.choices?.[0]?.message?.content;
      if (typeof text !== 'string') throw new Error('empty');
      return text;
    },
  };
}
