import '../domain/color_harmony.dart';
import '../domain/fashion_color.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';

/// Turns domain enums into the user's language. Every visible word comes from
/// the translation files, so a new language needs only a new .arb file.
extension Labels on AppLocalizations {
  String style(Style s) => switch (s) {
    Style.lounge => styleLounge,
    Style.sport => styleSport,
    Style.casual => styleCasual,
    Style.drip => styleDrip,
    Style.smartCasual => styleSmartCasual,
    Style.formal => styleFormal,
    Style.dressy => styleDressy,
    Style.traditional => styleTraditional,
  };

  String occasion(Occasion o) => switch (o) {
    Occasion.university => occUniversity,
    Occasion.work => occWork,
    Occasion.outing => occOuting,
    Occasion.date => occDate,
    Occasion.interview => occInterview,
    Occasion.wedding => occWedding,
    Occasion.engagement => occEngagement,
    Occasion.eid => occEid,
    Occasion.home => occHome,
    Occasion.gym => occGym,
    Occasion.party => occParty,
  };

  String category(Category c) => switch (c) {
    Category.top => catTop,
    Category.bottom => catBottom,
    Category.onePiece => catOnePiece,
    Category.outerwear => catOuterwear,
    Category.shoes => catShoes,
    Category.bag => catBag,
    Category.headscarf => catHeadscarf,
    Category.shemagh => catShemagh,
    Category.belt => catBelt,
    Category.watch => catWatch,
    Category.jewelry => catJewelry,
    Category.sunglasses => catSunglasses,
    Category.perfume => catPerfume,
    Category.accessory => catAccessory,
  };

  String reason(Harmony h) => switch (h) {
    Harmony.neutrals => reasonNeutrals,
    Harmony.accent => reasonAccent,
    Harmony.monochrome => reasonMonochrome,
    Harmony.analogous => reasonAnalogous,
    Harmony.complementary => reasonComplementary,
    Harmony.clash => reasonClash,
  };

  String color(FashionColor c) => switch (c.key) {
    'white' => colWhite,
    'cream' => colCream,
    'black' => colBlack,
    'grey' => colGrey,
    'navy' => colNavy,
    'denim' => colDenim,
    'beige' => colBeige,
    'camel' => colCamel,
    'brown' => colBrown,
    'olive' => colOlive,
    'khaki' => colKhaki,
    'gold' => colGold,
    'silver' => colSilver,
    'red' => colRed,
    'burgundy' => colBurgundy,
    'pink' => colPink,
    'blush' => colBlush,
    'orange' => colOrange,
    'mustard' => colMustard,
    'yellow' => colYellow,
    'green' => colGreen,
    'emerald' => colEmerald,
    'teal' => colTeal,
    'sky' => colSky,
    'blue' => colBlue,
    'lavender' => colLavender,
    _ => colPurple,
  };

  /// Cities are stored by their English key and shown in the user's language.
  String city(String key) => switch (key) {
    'Cairo' => cityCairo,
    'Alexandria' => cityAlexandria,
    'Riyadh' => cityRiyadh,
    'Jeddah' => cityJeddah,
    'Dubai' => cityDubai,
    'AbuDhabi' => cityAbuDhabi,
    'Kuwait' => cityKuwait,
    'Doha' => cityDoha,
    _ => key,
  };

  String season(Season s) => switch (s) {
    Season.summer => seasonSummer,
    Season.winter => seasonWinter,
    Season.all => seasonAll,
  };

  String pattern(Pattern p) => switch (p) {
    Pattern.solid => patternSolid,
    Pattern.striped => patternStriped,
    Pattern.checked => patternChecked,
    Pattern.printed => patternPrinted,
  };

  /// "Burgundy one-piece", in the right word order for the language.
  String itemName(Item i) => localeName.startsWith('ar')
      ? '${category(i.category)} ${color(i.color)}'
      : '${color(i.color)} ${category(i.category).toLowerCase()}';
}
