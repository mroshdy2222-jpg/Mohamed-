import 'fashion_color.dart';
import 'languages.dart';
import 'models.dart';

/// JSON for what the app keeps on the device. Enums are stored by name and
/// colours by key, so reordering an enum never corrupts saved data.
T _enum<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

Map<String, Object?> itemToJson(Item i) => {
  'id': i.id,
  'category': i.category.name,
  'color': i.color.key,
  'pattern': i.pattern.name,
  'season': i.season.name,
  'styles': [for (final s in i.styles) s.name],
  'status': i.status.name,
  'photo': i.photoPath,
};

Item itemFromJson(Map<String, Object?> j) => Item(
  id: j['id'] as String,
  category: _enum(Category.values, j['category'], Category.accessory),
  color: Palette.all.firstWhere((c) => c.key == j['color'], orElse: () => Palette.grey),
  pattern: _enum(Pattern.values, j['pattern'], Pattern.solid),
  season: _enum(Season.values, j['season'], Season.all),
  styles: {
    for (final s in (j['styles'] as List? ?? const []))
      if (Style.values.any((v) => v.name == s)) _enum(Style.values, s, Style.casual),
  },
  status: _enum(ItemStatus.values, j['status'], ItemStatus.available),
  photoPath: j['photo'] as String?,
);

Map<String, Object?> profileToJson(Profile p) => {
  'gender': p.gender.name,
  'hijab': p.wearsHijab,
  'city': p.city,
  'language': p.language?.name,
};

Profile profileFromJson(Map<String, Object?> j) => Profile(
  gender: _enum(Gender.values, j['gender'], Gender.female),
  wearsHijab: j['hijab'] as bool? ?? false,
  city: j['city'] as String? ?? 'Cairo',
  language: j['language'] == null ? null : _enum(AppLanguage.values, j['language'], AppLanguage.egyptian),
);

Map<String, Object?> wearToJson(WearEntry e) => {
  'date': e.date.toIso8601String(),
  'items': e.itemIds,
  'occasion': e.occasion.name,
  'with': e.withWhom,
};

WearEntry wearFromJson(Map<String, Object?> j) => WearEntry(
  date: DateTime.parse(j['date'] as String),
  itemIds: [for (final id in (j['items'] as List? ?? const [])) id as String],
  occasion: _enum(Occasion.values, j['occasion'], Occasion.outing),
  withWhom: j['with'] as String?,
);

Map<String, Object?> pollToJson(Poll p) => {
  'id': p.id,
  'created': p.created.toIso8601String(),
  'occasion': p.occasion.name,
  'style': p.style.name,
  'options': p.options,
  'winner': p.winner,
};

Poll pollFromJson(Map<String, Object?> j) => Poll(
  id: j['id'] as String,
  created: DateTime.parse(j['created'] as String),
  occasion: _enum(Occasion.values, j['occasion'], Occasion.outing),
  style: _enum(Style.values, j['style'], Style.casual),
  options: [
    for (final o in (j['options'] as List? ?? const [])) [for (final id in o as List) id as String],
  ],
  winner: j['winner'] as int?,
);
