import 'dart:math';

import 'color_harmony.dart';
import 'models.dart';

/// Above this the engine never suggests winter pieces or a jacket.
const hotFromC = 28;

/// Below this the engine adds outerwear when the wardrobe has some.
const coldBelowC = 18;

class Outfit {
  final List<Item> items;
  final HarmonyResult harmony;
  final double score;

  const Outfit(this.items, this.harmony, this.score);

  /// Same pieces in any order give the same signature.
  String get signature => (items.map((i) => i.id).toList()..sort()).join('+');
}

class OutfitRequest {
  final Style style;
  final int temperatureC;
  final Profile profile;

  /// The piece the user wants to wear no matter what ("I want this jacket").
  final String? lockedItemId;

  /// Signatures already shown this session, so "dress me again" moves on.
  final Set<String> exclude;
  final DateTime now;

  OutfitRequest({
    required this.style,
    required this.temperatureC,
    required this.profile,
    this.lockedItemId,
    this.exclude = const {},
    DateTime? now,
  }) : now = now ?? DateTime.now();
}

/// Builds outfits from the wardrobe with fixed rules (dress code, weather,
/// availability, colour harmony, recent wear). The AI layer only rewrites the
/// reason and re-ranks the top few, so the engine works offline and for free.
class OutfitEngine {
  final Random _random;

  OutfitEngine({int seed = 7}) : _random = Random(seed);

  List<Outfit> suggest(List<Item> wardrobe, List<WearEntry> log, OutfitRequest req, {int limit = 5}) {
    final locked = req.lockedItemId == null ? null : _byId(wardrobe, req.lockedItemId!);

    bool usable(Item i) {
      if (locked != null && i.id == locked.id) return true;
      if (i.status != ItemStatus.available) return false;
      if (!i.fits(req.style)) return false;
      if (req.temperatureC >= hotFromC && i.season == Season.winter) return false;
      if (req.temperatureC < coldBelowC - 3 && i.season == Season.summer) return false;
      return true;
    }

    List<Item> pool(Category c) {
      final items = wardrobe.where((i) => i.category == c && usable(i)).toList();
      if (locked != null && locked.category == c) return [locked];
      return items;
    }

    final tops = pool(Category.top);
    final bottoms = pool(Category.bottom);
    final onePieces = pool(Category.onePiece);
    final shoes = pool(Category.shoes);
    final outer = req.temperatureC >= hotFromC ? <Item>[] : pool(Category.outerwear);
    final scarves = req.profile.wearsHijab ? pool(Category.headscarf) : <Item>[];
    final shemaghs = pool(Category.shemagh);

    final bases = <List<Item>>[
      for (final t in tops)
        for (final b in bottoms) [t, b],
      for (final o in onePieces) [o],
    ];
    if (locked != null && !_placeable(locked)) return const [];

    final needOuter = req.temperatureC < coldBelowC && outer.isNotEmpty;
    final lockedOuter = locked?.category == Category.outerwear;
    final outerChoices = needOuter || lockedOuter ? outer : <Item?>[null, ...outer.take(2)];
    final scarfChoices = scarves.isEmpty ? <Item?>[null] : scarves;
    final shemaghChoices = req.style == Style.traditional && shemaghs.isNotEmpty ? shemaghs : <Item?>[null];
    final shoeChoices = shoes.isEmpty ? <Item?>[null] : shoes;

    final recent = _recentlyWorn(log, req.now);
    final recentOutfits = log
        .where((e) => req.now.difference(e.date).inDays < 7)
        .map((e) => (e.itemIds.toList()..sort()).join('+'))
        .toSet();

    final results = <Outfit>[];
    for (final base in bases) {
      for (final s in shoeChoices) {
        for (final o in outerChoices) {
          for (final sc in scarfChoices) {
            for (final sh in shemaghChoices) {
              final items = [...base, ?s, ?o, ?sc, ?sh];
              if (locked != null && !items.any((i) => i.id == locked.id)) continue;
              final outfit = _score(items, recent);
              if (req.exclude.contains(outfit.signature)) continue;
              if (recentOutfits.contains(outfit.signature)) continue;
              results.add(outfit);
            }
          }
        }
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(limit).toList();
  }

  Outfit _score(List<Item> items, Map<String, int> recent) {
    final harmony = scoreColors(items.map((i) => i.color).toList(), patterns: items.map((i) => i.pattern).toList());
    var score = harmony.score;
    for (final i in items) {
      final daysAgo = recent[i.id];
      if (daysAgo != null && daysAgo < 2) score -= 0.1;
    }
    // A little jitter so equal outfits don't always come out in the same order.
    score += _random.nextDouble() * 0.02;
    return Outfit(items, harmony, score);
  }

  static bool _placeable(Item i) => i.category != Category.bag && i.category != Category.accessory;

  static Item? _byId(List<Item> items, String id) {
    for (final i in items) {
      if (i.id == id) return i;
    }
    return null;
  }

  /// Item id → days since it was last worn.
  static Map<String, int> _recentlyWorn(List<WearEntry> log, DateTime now) {
    final map = <String, int>{};
    for (final e in log) {
      final days = now.difference(e.date).inDays;
      for (final id in e.itemIds) {
        final prev = map[id];
        if (prev == null || days < prev) map[id] = days;
      }
    }
    return map;
  }
}
