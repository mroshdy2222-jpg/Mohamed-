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

  /// The clothes, in any order. Finishing touches are left out, so the same
  /// outfit with another watch is still the same outfit.
  String get signature =>
      (items.where((i) => !finishingTouches.contains(i.category)).map((i) => i.id).toList()..sort()).join('+');
}

class OutfitRequest {
  final Style style;
  final int temperatureC;
  final Profile profile;

  /// The piece the user wants to wear no matter what ("I want this jacket").
  final String? lockedItemId;

  /// Signatures already shown this session, so "another option" moves on.
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
    final lockedTouch = locked != null && finishingTouches.contains(locked.category);

    final needOuter = req.temperatureC < coldBelowC && outer.isNotEmpty;
    final lockedOuter = locked?.category == Category.outerwear;
    final outerChoices = needOuter || lockedOuter ? outer : <Item?>[null, ...outer.take(2)];
    final scarfChoices = scarves.isEmpty ? <Item?>[null] : scarves;
    final shemaghChoices = req.style == Style.traditional && shemaghs.isNotEmpty ? shemaghs : <Item?>[null];
    final shoeChoices = shoes.isEmpty ? <Item?>[null] : shoes;

    final recent = _recentlyWorn(log, req.now);
    final touchIds = {
      for (final i in wardrobe)
        if (finishingTouches.contains(i.category)) i.id,
    };
    final recentOutfits = log
        .where((e) => req.now.difference(e.date).inDays < 7)
        .map((e) => (e.itemIds.where((id) => !touchIds.contains(id)).toList()..sort()).join('+'))
        .toSet();

    final results = <Outfit>[];
    for (final base in bases) {
      for (final s in shoeChoices) {
        for (final o in outerChoices) {
          for (final sc in scarfChoices) {
            for (final sh in shemaghChoices) {
              final items = [...base, ?s, ?o, ?sc, ?sh];
              if (locked != null && !lockedTouch && !items.any((i) => i.id == locked.id)) continue;
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
    return [for (final o in results.take(limit)) _finish(o, wardrobe, req, usable, locked)];
  }

  /// Adds at most one of each finishing touch, only where the style calls for
  /// it and only if it keeps the colours as good as they were. The belt goes
  /// with the shoes, the classic rule.
  Outfit _finish(Outfit outfit, List<Item> wardrobe, OutfitRequest req, bool Function(Item) usable, Item? locked) {
    final core = outfit.items;
    final colors = core.map((i) => i.color).toList();
    final base = outfit.harmony.score;
    final shoes = core.where((i) => i.category == Category.shoes).firstOrNull;
    final hasBottom = core.any((i) => i.category == Category.bottom);
    final style = req.style;

    bool wanted(Category c) => switch (c) {
      Category.bag => style != Style.lounge && style != Style.sport,
      Category.belt => hasBottom && const {Style.casual, Style.drip, Style.smartCasual, Style.formal}.contains(style),
      Category.watch => style != Style.lounge,
      Category.jewelry => const {Style.smartCasual, Style.formal, Style.dressy, Style.traditional}.contains(style),
      Category.sunglasses =>
        req.temperatureC >= 24 && const {Style.sport, Style.casual, Style.drip, Style.smartCasual}.contains(style),
      Category.perfume => true,
      _ => false,
    };

    final added = <Item>[];
    for (final c in finishingTouches) {
      if (locked != null && locked.category == c) {
        added.add(locked);
        continue;
      }
      if (!wanted(c)) continue;
      final options = wardrobe.where((i) => i.category == c && usable(i)).toList();
      if (options.isEmpty) continue;
      double fit(Item i) {
        if (c == Category.perfume) return base;
        var v = scoreColors([...colors, ...added.map((a) => a.color), i.color]).score;
        if (c == Category.belt && shoes != null && i.color == shoes.color) v += 0.2;
        return v;
      }

      options.sort((a, b) => fit(b).compareTo(fit(a)));
      if (fit(options.first) < base - 0.05) continue;
      added.add(options.first);
    }
    return added.isEmpty ? outfit : Outfit([...core, ...added], outfit.harmony, outfit.score);
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
