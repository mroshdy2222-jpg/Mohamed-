import 'fashion_color.dart';
import 'languages.dart';

enum Category { top, bottom, onePiece, outerwear, shoes, bag, headscarf, shemagh, accessory }

/// Dress codes, ordered from most relaxed to most formal. Traditional sits
/// outside the scale: it is its own world (galabeya, thobe, kaftan, abaya).
enum Style { lounge, sport, casual, drip, smartCasual, formal, dressy, traditional }

enum Season { summer, winter, all }

enum Pattern { solid, striped, checked, printed }

enum ItemStatus { available, laundry, lent }

enum Gender { female, male }

enum Occasion { university, work, outing, date, interview, wedding, engagement, eid, home, gym, party }

/// The dress code an occasion suggests. The user can override it with a chip.
const Map<Occasion, Style> defaultStyleFor = {
  Occasion.university: Style.casual,
  Occasion.work: Style.smartCasual,
  Occasion.outing: Style.casual,
  Occasion.date: Style.smartCasual,
  Occasion.interview: Style.formal,
  Occasion.wedding: Style.dressy,
  Occasion.engagement: Style.dressy,
  Occasion.eid: Style.traditional,
  Occasion.home: Style.lounge,
  Occasion.gym: Style.sport,
  Occasion.party: Style.drip,
};

class Item {
  final String id;
  final Category category;
  final FashionColor color;
  final Pattern pattern;
  final Season season;

  /// Dress codes this piece works in. Empty means it goes with any style,
  /// which is how most accessories and headscarves are tagged.
  final Set<Style> styles;
  final ItemStatus status;

  /// A local photo, once the user replaces the placeholder from the basics grid.
  final String? photoPath;

  const Item({
    required this.id,
    required this.category,
    required this.color,
    this.pattern = Pattern.solid,
    this.season = Season.all,
    this.styles = const {},
    this.status = ItemStatus.available,
    this.photoPath,
  });

  bool fits(Style style) => styles.isEmpty || styles.contains(style);

  Item copyWith({ItemStatus? status, String? photoPath}) => Item(
    id: id,
    category: category,
    color: color,
    pattern: pattern,
    season: season,
    styles: styles,
    status: status ?? this.status,
    photoPath: photoPath ?? this.photoPath,
  );
}

class Profile {
  final Gender gender;
  final bool wearsHijab;
  final String city;

  /// Null until the user picks one; the app then follows the phone's region.
  final AppLanguage? language;

  const Profile({this.gender = Gender.female, this.wearsHijab = false, this.city = 'Cairo', this.language});

  Profile copyWith({Gender? gender, bool? wearsHijab, String? city, AppLanguage? language}) => Profile(
    gender: gender ?? this.gender,
    wearsHijab: wearsHijab ?? this.wearsHijab,
    city: city ?? this.city,
    language: language ?? this.language,
  );
}

class WearEntry {
  final DateTime date;
  final List<String> itemIds;
  final Occasion occasion;

  /// Who the user was with, typed freely ("خطوبة أحمد", "the office").
  final String? withWhom;

  const WearEntry({required this.date, required this.itemIds, required this.occasion, this.withWhom});
}

/// "This or that?": two outfits sent to friends as one image. Friends reply
/// in the chat with 1 or 2, and the user marks the winner here.
class Poll {
  final String id;
  final DateTime created;
  final Occasion occasion;
  final Style style;

  /// Item ids of option 1 and option 2.
  final List<List<String>> options;

  /// 0 or 1 once the user records the result.
  final int? winner;

  const Poll({
    required this.id,
    required this.created,
    required this.occasion,
    required this.style,
    required this.options,
    this.winner,
  });

  Poll withWinner(int index) =>
      Poll(id: id, created: created, occasion: occasion, style: style, options: options, winner: index);
}
