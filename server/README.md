# Talla server (Supabase)

Ready to deploy as soon as a Supabase project exists. Nothing here holds a key.

| Path | What |
| --- | --- |
| `supabase/migrations/` | Tables for profiles, wardrobe items, wear log, polls, link votes, support grants and the access log. Row-level security on every table; a private `wardrobe` photo bucket with one folder per user. |
| `supabase/migrations/…_analytics.sql` | Demand signals (a missing category and colour, sent only by users who opted in, deleted when they opt out), the dashboard views in the `analytics` schema, and `support_open`, the only way support opens a wardrobe. |
| `supabase/functions/tag-item/` | Tags a clothing photo (type, colour, pattern, season, styles). Tries free providers in order and falls through on errors or rate limits. A photo of a person is refused and goes to no other provider. The photo is not stored. |
| `supabase/functions/_shared/` | The prompt, the answer checks, the providers (Gemini, OpenRouter) and the fallback router. Plain TypeScript, tested with Node. |

## Dashboard numbers

The views `analytics.missing_pieces`, `analytics.missing_colors`, `analytics.city_demand` and `analytics.weekly` match the dashboard's datasets. Only the service role can read them. A group with fewer than 50 users is left out, so no number points to a person.

## Support access

Support calls `select * from support_open(<grant id>, '<staff name>', '{<item ids>}')` with the service role. It refuses an expired or revoked grant, or items the user did not include, and writes the access log entry the user sees in the app.

Never stored on the server: selfies, face photos, skin-tone photos, the lingerie section.

## Test

```sh
npm test          # router, prompt checks and provider request shapes (Node 22+)
npm run test:db   # runs the migration on a throwaway local Postgres and checks who can read and write what
```

`test:db` needs the Postgres server binaries (`initdb`, `pg_ctl`) and runs as root to create a local test user.

## Deploy

1. Create a project at supabase.com and install the Supabase CLI.
2. Link and create the tables:
   ```sh
   cd server
   supabase link --project-ref <project-ref>
   supabase db push
   ```
3. Add the AI keys as secrets. They stay on the server; the app never sees them.
   ```sh
   supabase secrets set GEMINI_API_KEY=<key from Google AI Studio>
   # optional second provider:
   supabase secrets set OPENROUTER_API_KEY=<key> OPENROUTER_MODEL=<a vision model id ending in :free>
   # optional: GEMINI_MODEL (default gemini-2.5-flash)
   ```
4. Deploy the function:
   ```sh
   supabase functions deploy tag-item
   ```
5. Build the app against the project. The URL and the anon key are public by design:
   ```sh
   cd ../app
   flutter run --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co --dart-define=SUPABASE_ANON_KEY=<anon key>
   ```
   Once the app is on Google Play, add `--dart-define=TALLA_LINK=<store link>` and every shared poll ends with "جرّب طلّة" and the link.

Check each provider's free-tier limits and data terms before launch: they change often, and free tiers may use what they receive to train models. That is why only photos of a garment on its own are sent.

Until sign-in is added to the app, the function accepts the anon key. Require a signed-in session before opening it to the public.
