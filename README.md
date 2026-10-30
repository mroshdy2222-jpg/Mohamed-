# Talla

Talla (طالا) is an AI wardrobe stylist for the Arab market: it suggests a daily outfit from the clothes you own, coordinates colours, and lets friends vote "this or that?".

- Product spec: [Talla – وصف المنتج](https://claude.ai/artifact/7wW8DTn726wvoLHfeHCcXs)
- Brand and design system: [Talla Brand](https://claude.ai/artifact/JJ83AGQiYCQaPPnqyP5sEy)

## Repository

| Path | What |
| --- | --- |
| `app/` | The Flutter app (Android, iOS, web) |
| `server/` | Supabase: database with row-level security, and the photo-tagging function. See `server/README.md` to deploy. |

## The app today

The first slice of the MVP, running fully offline:

- Onboarding: women or men, hijab or not, then the "do you have these?" basics grid. The first outfit appears without a single photo.
- Today: occasion, the eight dress codes (lounge, sport, casual, drip, smart casual, formal, dressy, traditional), the outfit, a one-line reason, lock a piece, "another option", "choose this".
- Wear log with the "you wore this with the same people" warning.
- "This or that?": today's outfit against another one, shared as one image to WhatsApp (or any app); friends reply 1 or 2, the user records the winner and can choose it. The voting link will build on this once the server exists.
- Wardrobe with category filters and in-the-laundry / lent status.
- "What's missing?": the one piece that would add the most complete outfits in the current style, worked out on the phone so the server never sees the wardrobe. Affiliate offers will attach to it.
- Add a piece by hand: optional photo (camera or gallery), type, colour, styles, pattern, season.
- Everything is saved on the device and survives closing the app.
- Today's high temperature for the chosen city (8 cities in Egypt and the Gulf) from Open-Meteo, which is free and needs no key. Offline it keeps the last value.
- Arabic in three registers (Egyptian, Gulf, Standard) and English, from translation files only. The first launch picks one from the phone's region; the user can switch on the first screen or in Account.

The outfit engine (`app/lib/domain/`) is rule-based: dress code, weather, availability, colour harmony and recent wear. AI will rewrite the reason and re-rank the top few; it is not needed for an outfit to appear.

Auto-tagging: when the app is built with a Supabase project (`--dart-define`), a new photo pre-fills type, colour, pattern, season and styles through the server's `tag-item` function; without one, adding a piece stays manual.

Not built yet: sign-in and syncing the wardrobe to the server, the WhatsApp voting link (friends vote on a web page), the support-access screens, and affiliate offers.

## Develop

Requires Flutter 3.47 or later.

```sh
cd app
flutter pub get
flutter test                 # engine rules, flows, storage, polls, tagging
flutter run                  # on a device or emulator
flutter run -d chrome        # in the browser
```

Fonts (Alexandria, IBM Plex Sans Arabic) are bundled under `app/assets/fonts/` with their OFL licences.
