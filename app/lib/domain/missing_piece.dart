import 'models.dart';
import 'outfit_engine.dart';

class MissingPiece {
  final Item item;

  /// Complete outfits the wardrobe gains with this piece, in the given style.
  final int gain;

  const MissingPiece(this.item, this.gain);
}

/// The piece that would add the most complete outfits in [style]. It runs on
/// the phone, so the server never needs to see the wardrobe: it only sends
/// the catalogue of candidates (today the basics; later, affiliate offers).
///
/// "Complete" means with shoes, and with a headscarf for users who wear one,
/// so a first pair of shoes counts as much as a whole new outfit.
List<MissingPiece> missingPieces({
  required List<Item> wardrobe,
  required List<Item> candidates,
  required Style style,
  required Profile profile,
  required int temperatureC,
  int limit = 3,
}) {
  final engine = OutfitEngine();
  int complete(List<Item> items) {
    final outfits = engine.suggest(
      items,
      const [],
      OutfitRequest(style: style, temperatureC: temperatureC, profile: profile),
      limit: 1 << 20,
    );
    return outfits.where((o) {
      final cats = o.items.map((i) => i.category).toSet();
      if (!cats.contains(Category.shoes)) return false;
      if (profile.wearsHijab && !cats.contains(Category.headscarf)) return false;
      return true;
    }).length;
  }

  bool owned(Item c) => wardrobe.any((i) => i.category == c.category && i.color == c.color);

  final base = complete(wardrobe);
  final results = <MissingPiece>[];
  for (final c in candidates) {
    if (!c.fits(style) || owned(c)) continue;
    final gain = complete([...wardrobe, c]) - base;
    if (gain > 0) results.add(MissingPiece(c, gain));
  }
  results.sort((a, b) => b.gain.compareTo(a.gain));
  return results.take(limit).toList();
}
