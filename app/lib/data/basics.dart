import '../domain/fashion_color.dart';
import '../domain/models.dart';

/// The "do you have this?" grid from onboarding. Each tap adds a placeholder
/// item the engine can use straight away; the user swaps in a real photo later.
class Basic {
  final Item item;

  /// Shown to this gender only; null shows it to everyone.
  final Gender? only;

  const Basic(this.item, {this.only});

  /// What it is more precisely than its category (loafers, not just shoes),
  /// taken from the id: `b-<kind>-<colour>`.
  String get kind => item.id.split('-')[1];
}

const _casSmart = {Style.casual, Style.smartCasual};
const _smartFormal = {Style.smartCasual, Style.formal};

const basics = <Basic>[
  Basic(
    Item(
      id: 'b-tee-white',
      category: Category.top,
      color: Palette.white,
      styles: {Style.casual, Style.drip, Style.lounge},
    ),
  ),
  Basic(Item(id: 'b-tee-black', category: Category.top, color: Palette.black, styles: {Style.casual, Style.drip})),
  Basic(Item(id: 'b-shirt-white', category: Category.top, color: Palette.white, styles: _smartFormal)),
  Basic(Item(id: 'b-shirt-sky', category: Category.top, color: Palette.sky, styles: _casSmart)),
  Basic(
    Item(id: 'b-blouse-blush', category: Category.top, color: Palette.blush, styles: _casSmart),
    only: Gender.female,
  ),
  Basic(
    Item(id: 'b-knit-beige', category: Category.top, color: Palette.beige, season: Season.winter, styles: _casSmart),
  ),
  Basic(
    Item(
      id: 'b-hoodie-grey',
      category: Category.top,
      color: Palette.grey,
      season: Season.winter,
      styles: {Style.casual, Style.drip, Style.lounge},
    ),
  ),
  Basic(Item(id: 'b-jeans-denim', category: Category.bottom, color: Palette.denim, styles: {Style.casual, Style.drip})),
  Basic(Item(id: 'b-chino-beige', category: Category.bottom, color: Palette.beige, styles: _casSmart)),
  Basic(Item(id: 'b-trousers-navy', category: Category.bottom, color: Palette.navy, styles: _smartFormal)),
  Basic(Item(id: 'b-trousers-black', category: Category.bottom, color: Palette.black, styles: _smartFormal)),
  Basic(
    Item(id: 'b-skirt-camel', category: Category.bottom, color: Palette.camel, styles: _casSmart),
    only: Gender.female,
  ),
  Basic(
    Item(id: 'b-joggers-black', category: Category.bottom, color: Palette.black, styles: {Style.sport, Style.lounge}),
  ),
  Basic(Item(id: 'b-sport-tee', category: Category.top, color: Palette.navy, styles: {Style.sport})),
  Basic(
    Item(id: 'b-dress-burgundy', category: Category.onePiece, color: Palette.burgundy, styles: {Style.dressy}),
    only: Gender.female,
  ),
  Basic(
    Item(
      id: 'b-abaya-black',
      category: Category.onePiece,
      color: Palette.black,
      styles: {Style.traditional, Style.dressy},
    ),
    only: Gender.female,
  ),
  Basic(
    Item(id: 'b-thobe-white', category: Category.onePiece, color: Palette.white, styles: {Style.traditional}),
    only: Gender.male,
  ),
  Basic(
    Item(
      id: 'b-galabeya-grey',
      category: Category.onePiece,
      color: Palette.grey,
      styles: {Style.traditional, Style.lounge},
    ),
    only: Gender.male,
  ),
  Basic(Item(id: 'b-blazer-navy', category: Category.outerwear, color: Palette.navy, styles: _smartFormal)),
  Basic(
    Item(
      id: 'b-jacket-denim',
      category: Category.outerwear,
      color: Palette.denim,
      season: Season.winter,
      styles: {Style.casual, Style.drip},
    ),
  ),
  Basic(
    Item(
      id: 'b-sneakers-white',
      category: Category.shoes,
      color: Palette.white,
      styles: {Style.casual, Style.drip, Style.smartCasual},
    ),
  ),
  Basic(Item(id: 'b-runners-grey', category: Category.shoes, color: Palette.grey, styles: {Style.sport})),
  Basic(Item(id: 'b-loafers-brown', category: Category.shoes, color: Palette.brown, styles: _smartFormal)),
  Basic(
    Item(
      id: 'b-heels-black',
      category: Category.shoes,
      color: Palette.black,
      styles: {Style.formal, Style.dressy, Style.traditional},
    ),
    only: Gender.female,
  ),
  Basic(
    Item(id: 'b-oxfords-black', category: Category.shoes, color: Palette.black, styles: {Style.formal, Style.dressy}),
    only: Gender.male,
  ),
  Basic(
    Item(
      id: 'b-sandals-brown',
      category: Category.shoes,
      color: Palette.brown,
      season: Season.summer,
      styles: {Style.casual, Style.lounge, Style.traditional},
    ),
  ),
  Basic(
    Item(id: 'b-scarf-beige', category: Category.headscarf, color: Palette.beige),
    only: Gender.female,
  ),
  Basic(
    Item(id: 'b-scarf-black', category: Category.headscarf, color: Palette.black),
    only: Gender.female,
  ),
  Basic(
    Item(id: 'b-scarf-blush', category: Category.headscarf, color: Palette.blush),
    only: Gender.female,
  ),
  Basic(
    Item(id: 'b-shemagh-red', category: Category.shemagh, color: Palette.red, styles: {Style.traditional}),
    only: Gender.male,
  ),
];

/// The onboarding grid: clothes, shoes and head coverings only. Accessories
/// would double its length; people add them later, one at a time.
List<Basic> basicsFor(Gender gender) => basics
    .where((b) => b.only == null || b.only == gender)
    .where((b) => !finishingTouches.contains(b.item.category))
    .toList();
