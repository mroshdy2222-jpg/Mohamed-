import 'package:flutter_test/flutter_test.dart';
import 'package:talla/domain/color_harmony.dart';
import 'package:talla/domain/fashion_color.dart';
import 'package:talla/domain/models.dart';
import 'package:talla/domain/outfit_engine.dart';
import 'package:talla/domain/wear_log.dart';

Item item(
  String id,
  Category c,
  FashionColor color, {
  Set<Style> styles = const {Style.casual},
  Season season = Season.all,
  ItemStatus status = ItemStatus.available,
  Pattern pattern = Pattern.solid,
}) => Item(id: id, category: c, color: color, styles: styles, season: season, status: status, pattern: pattern);

final now = DateTime(2026, 10, 30, 8);

OutfitRequest req({
  Style style = Style.casual,
  int temp = 24,
  bool hijab = false,
  String? lock,
  Set<String> exclude = const {},
}) => OutfitRequest(
  style: style,
  temperatureC: temp,
  profile: Profile(wearsHijab: hijab),
  lockedItemId: lock,
  exclude: exclude,
  now: now,
);

void main() {
  group('colour harmony', () {
    test('one accent on neutrals scores highest', () {
      final r = scoreColors([Palette.navy, Palette.white, Palette.mustard]);
      expect(r.harmony, Harmony.accent);
      expect(r.score, 1.0);
    });

    test('all neutrals is safe', () {
      expect(scoreColors([Palette.black, Palette.beige]).harmony, Harmony.neutrals);
    });

    test('opposite hues are complementary, mid-distance hues clash', () {
      expect(scoreColors([Palette.blue, Palette.orange]).harmony, Harmony.complementary);
      expect(scoreColors([Palette.orange, Palette.purple]).harmony, Harmony.clash);
    });

    test('two patterns in one outfit are penalised', () {
      final solid = scoreColors([Palette.white, Palette.navy]);
      final busy = scoreColors([Palette.white, Palette.navy], patterns: [Pattern.striped, Pattern.checked]);
      expect(busy.score, lessThan(solid.score));
    });

    test('hue distance wraps around the wheel', () {
      expect(hueDistance(350, 10), 20);
    });
  });

  group('outfit engine', () {
    final wardrobe = [
      item('tee', Category.top, Palette.white),
      item('shirt', Category.top, Palette.sky, styles: {Style.smartCasual}),
      item('jeans', Category.bottom, Palette.denim),
      item('chino', Category.bottom, Palette.beige, styles: {Style.smartCasual}),
      item('sneakers', Category.shoes, Palette.white),
      item('loafers', Category.shoes, Palette.brown, styles: {Style.smartCasual}),
      item('runners', Category.shoes, Palette.grey, styles: {Style.sport}),
      item('coat', Category.outerwear, Palette.camel, season: Season.winter, styles: {Style.casual, Style.smartCasual}),
      item('scarf', Category.headscarf, Palette.beige, styles: const {}),
    ];
    final engine = OutfitEngine();

    test('every piece fits the requested dress code', () {
      final outfits = engine.suggest(wardrobe, [], req(style: Style.smartCasual));
      expect(outfits, isNotEmpty);
      for (final o in outfits) {
        expect(o.items.map((i) => i.id), isNot(contains('runners')));
        expect(o.items.every((i) => i.fits(Style.smartCasual)), isTrue);
      }
    });

    test('pieces in the laundry are never suggested', () {
      final w = [for (final i in wardrobe) i.id == 'tee' ? i.copyWith(status: ItemStatus.laundry) : i];
      final outfits = engine.suggest(w, [], req());
      expect(outfits.expand((o) => o.items).map((i) => i.id), isNot(contains('tee')));
    });

    test('no winter coat when it is hot, coat added when it is cold', () {
      final hot = engine.suggest(wardrobe, [], req(temp: 32));
      expect(hot.expand((o) => o.items).map((i) => i.id), isNot(contains('coat')));
      final cold = engine.suggest(wardrobe, [], req(temp: 12));
      expect(cold.every((o) => o.items.any((i) => i.id == 'coat')), isTrue);
    });

    test('headscarf is part of the outfit for users who wear hijab', () {
      final outfits = engine.suggest(wardrobe, [], req(hijab: true));
      expect(outfits.every((o) => o.items.any((i) => i.category == Category.headscarf)), isTrue);
      final without = engine.suggest(wardrobe, [], req());
      expect(without.expand((o) => o.items).any((i) => i.category == Category.headscarf), isFalse);
    });

    test('a locked piece is in every suggestion, even outside the dress code', () {
      final outfits = engine.suggest(wardrobe, [], req(style: Style.smartCasual, lock: 'jeans'));
      expect(outfits, isNotEmpty);
      expect(outfits.every((o) => o.items.any((i) => i.id == 'jeans')), isTrue);
    });

    test('"another option" skips outfits already shown', () {
      final first = engine.suggest(wardrobe, [], req()).first;
      final next = engine.suggest(wardrobe, [], req(exclude: {first.signature}));
      expect(next.map((o) => o.signature), isNot(contains(first.signature)));
    });

    test('an outfit worn in the last 7 days is not suggested again', () {
      final first = engine.suggest(wardrobe, [], req()).first;
      final log = [
        WearEntry(
          date: now.subtract(const Duration(days: 3)),
          itemIds: first.items.map((i) => i.id).toList(),
          occasion: Occasion.outing,
        ),
      ];
      final again = engine.suggest(wardrobe, log, req());
      expect(again.map((o) => o.signature), isNot(contains(first.signature)));
    });
  });

  group('worn before with the same people', () {
    final dress = item('dress', Category.onePiece, Palette.burgundy, styles: {Style.dressy});
    final heels = item('heels', Category.shoes, Palette.black, styles: {Style.dressy});
    final log = [
      WearEntry(
        date: now.subtract(const Duration(days: 60)),
        itemIds: ['dress', 'heels'],
        occasion: Occasion.wedding,
        withWhom: 'عيلة ماما',
      ),
    ];

    test('warns when the same dress meets the same people within 6 months', () {
      expect(
        wornBeforeWith(log, [dress, item('flats', Category.shoes, Palette.beige)], ' عيلة ماما ', now: now),
        isNotNull,
      );
    });

    test('different people, or older than 6 months, is fine', () {
      expect(wornBeforeWith(log, [dress, heels], 'زمايل الشغل', now: now), isNull);
      expect(wornBeforeWith(log, [dress, heels], 'عيلة ماما', now: now.add(const Duration(days: 200))), isNull);
    });

    test('sharing only shoes is not memorable', () {
      expect(
        wornBeforeWith(log, [heels, item('abaya', Category.onePiece, Palette.black)], 'عيلة ماما', now: now),
        isNull,
      );
    });
  });

  group('finishing touches', () {
    final base = [
      item('tee', Category.top, Palette.white),
      item('jeans', Category.bottom, Palette.denim),
      item('loafers', Category.shoes, Palette.brown, styles: {Style.casual, Style.formal}),
      item('suit', Category.onePiece, Palette.navy, styles: {Style.formal}),
    ];
    final touches = [
      item('belt-black', Category.belt, Palette.black, styles: {Style.casual, Style.formal}),
      item('belt-brown', Category.belt, Palette.brown, styles: {Style.casual, Style.formal}),
      item('watch', Category.watch, Palette.silver, styles: const {}),
      item('shades', Category.sunglasses, Palette.black, styles: const {}),
      item('fresh', Category.perfume, Palette.sky, styles: {Style.casual}),
      item('oud', Category.perfume, Palette.brown, styles: {Style.formal}),
    ];
    final engine = OutfitEngine();
    List<String> ids(Outfit o) => o.items.map((i) => i.id).toList();

    test('the belt matches the shoes, and one of each touch at most', () {
      final o = engine.suggest([...base, ...touches], [], req(temp: 30)).first;
      expect(ids(o), containsAll(['belt-brown', 'watch', 'shades', 'fresh']));
      expect(ids(o), isNot(contains('belt-black')));
      expect(o.items.where((i) => i.category == Category.perfume), hasLength(1));
    });

    test('no sunglasses on a mild day or with formal wear; the perfume follows the style', () {
      final mild = engine.suggest([...base, ...touches], [], req(temp: 20)).first;
      expect(ids(mild), isNot(contains('shades')));
      final formal = engine.suggest([...base, ...touches], [], req(style: Style.formal, temp: 30)).first;
      expect(ids(formal), containsAll(['suit', 'oud']));
      expect(ids(formal), isNot(contains('shades')));
      expect(ids(formal), isNot(contains('belt-brown')), reason: 'no belt without trousers');
    });

    test('a different watch does not make a different outfit', () {
      final first = engine.suggest([...base, ...touches], [], req()).first;
      expect(first.signature, isNot(contains('watch')));
      final next = engine.suggest([...base, ...touches], [], req(exclude: {first.signature}));
      expect(next.map((o) => o.signature), isNot(contains(first.signature)));
    });

    test('a locked touch is always worn', () {
      final o = engine.suggest([...base, ...touches], [], req(temp: 20, lock: 'shades')).first;
      expect(ids(o), contains('shades'));
    });
  });
}
