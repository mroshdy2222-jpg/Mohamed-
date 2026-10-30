import 'models.dart';

/// Pieces people remember you by: a dress, an abaya, a statement top or jacket.
/// Wearing the same jeans twice in front of the same people is fine; wearing
/// the same dress to two family weddings is what users want to be warned about.
const _memorable = {Category.onePiece, Category.top, Category.outerwear};

String _normalize(String s) => s.trim().toLowerCase();

/// Returns the earlier entry when the user already wore this outfit, or one of
/// its memorable pieces, with the same people in the last six months.
WearEntry? wornBeforeWith(List<WearEntry> log, List<Item> outfit, String withWhom, {DateTime? now}) {
  final who = _normalize(withWhom);
  if (who.isEmpty) return null;
  final at = now ?? DateTime.now();
  final ids = outfit.map((i) => i.id).toSet();
  final memorable = outfit.where((i) => _memorable.contains(i.category)).map((i) => i.id).toSet();

  final matches = log.where((e) {
    if (e.withWhom == null || _normalize(e.withWhom!) != who) return false;
    if (at.difference(e.date).inDays > 183) return false;
    final worn = e.itemIds.toSet();
    return worn.containsAll(ids) || worn.intersection(memorable).isNotEmpty;
  }).toList()..sort((a, b) => b.date.compareTo(a.date));
  return matches.isEmpty ? null : matches.first;
}
