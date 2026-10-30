# Talla

Talla (طالا) is an AI wardrobe stylist for the Arab market: it suggests a daily outfit from the clothes you own, coordinates colours, and lets friends vote "this or that?".

- Product spec: [Talla – وصف المنتج](https://claude.ai/artifact/7wW8DTn726wvoLHfeHCcXs)
- Brand and design system: [Talla Brand](https://claude.ai/artifact/JJ83AGQiYCQaPPnqyP5sEy)

## Repository

| Path | What |
| --- | --- |
| `app/` | The Flutter app (Android, iOS, web) |

## The app today

The first slice of the MVP, running fully offline:

- Onboarding: women or men, hijab or not, then the "do you have these?" basics grid. The first outfit appears without a single photo.
- Today: occasion, the eight dress codes (lounge, sport, casual, drip, smart casual, formal, dressy, traditional), the outfit, a one-line reason, lock a piece, "dress me again", "wear it".
- Wear log with the "you wore this with the same people" warning.
- Wardrobe with category filters and in-the-laundry / lent status.
- Arabic (right to left) and English, from translation files only.

The outfit engine (`app/lib/domain/`) is rule-based: dress code, weather, availability, colour harmony and recent wear. AI will rewrite the reason and re-rank the top few; it is not needed for an outfit to appear.

Not built yet: photo capture and auto-tagging, the AI router (it will run on the server so no API keys ship in the app), Supabase sync, the weather API (a fixed 24° Cairo for now), the WhatsApp voting page, and affiliate offers.

## Develop

Requires Flutter 3.47 or later.

```sh
cd app
flutter pub get
flutter test                 # engine rules and the onboarding flow
flutter run                  # on a device or emulator
flutter run -d chrome        # in the browser
```

Fonts (Alexandria, IBM Plex Sans Arabic) are bundled under `app/assets/fonts/` with their OFL licences.
