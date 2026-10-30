import 'package:flutter/foundation.dart';

import 'domain/models.dart';
import 'domain/outfit_engine.dart';
import 'domain/wear_log.dart';

/// Everything the screens share. Kept in memory for now; the Supabase layer
/// will load and save the same fields.
class AppState extends ChangeNotifier {
  AppState({OutfitEngine? engine, DateTime Function()? clock})
    : _engine = engine ?? OutfitEngine(),
      _clock = clock ?? DateTime.now;

  final OutfitEngine _engine;
  final DateTime Function() _clock;

  Profile profile = const Profile();
  final List<Item> items = [];
  final List<WearEntry> wearLog = [];

  Occasion occasion = Occasion.outing;
  Style style = Style.casual;

  /// Until the weather API is wired in, a mild Cairo day.
  int temperatureC = 24;
  String? lockedItemId;

  final Set<String> _shown = {};
  Outfit? current;

  bool get onboarded => items.isNotEmpty;

  void setProfile(Profile p) {
    profile = p;
    _refresh(reset: true);
  }

  void addItems(Iterable<Item> newItems) {
    final known = items.map((i) => i.id).toSet();
    items.addAll(newItems.where((i) => !known.contains(i.id)));
    _refresh(reset: true);
  }

  void setOccasion(Occasion o) {
    occasion = o;
    style = defaultStyleFor[o]!;
    lockedItemId = null;
    _refresh(reset: true);
  }

  void setStyle(Style s) {
    style = s;
    lockedItemId = null;
    _refresh(reset: true);
  }

  void toggleLock(String itemId) {
    lockedItemId = lockedItemId == itemId ? null : itemId;
    _refresh(reset: true);
  }

  /// "Dress me again": the next best outfit not shown yet.
  void dressMeAgain() {
    if (current != null) _shown.add(current!.signature);
    _refresh();
  }

  void setStatus(String itemId, ItemStatus status) {
    final i = items.indexWhere((e) => e.id == itemId);
    if (i < 0) return;
    items[i] = items[i].copyWith(status: status);
    _refresh(reset: true);
  }

  /// The earlier entry if the current outfit was already worn with these people.
  WearEntry? checkWornBefore(String withWhom) =>
      current == null ? null : wornBeforeWith(wearLog, current!.items, withWhom, now: _clock());

  void wearCurrent({String? withWhom}) {
    if (current == null) return;
    final who = withWhom?.trim();
    wearLog.add(
      WearEntry(
        date: _clock(),
        itemIds: current!.items.map((i) => i.id).toList(),
        occasion: occasion,
        withWhom: who == null || who.isEmpty ? null : who,
      ),
    );
    notifyListeners();
  }

  void _refresh({bool reset = false}) {
    if (reset) _shown.clear();
    final found = _engine.suggest(
      items,
      wearLog,
      OutfitRequest(
        style: style,
        temperatureC: temperatureC,
        profile: profile,
        lockedItemId: lockedItemId,
        exclude: _shown,
        now: _clock(),
      ),
      limit: 1,
    );
    if (found.isEmpty && _shown.isNotEmpty) {
      // Went through every option: start the cycle again.
      _shown.clear();
      return _refresh();
    }
    current = found.isEmpty ? null : found.first;
    notifyListeners();
  }
}
