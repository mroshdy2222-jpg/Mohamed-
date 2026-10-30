import 'package:flutter/foundation.dart';

import 'data/store.dart';
import 'data/weather.dart';
import 'domain/models.dart';
import 'domain/outfit_engine.dart';
import 'domain/wear_log.dart';

/// Everything the screens share. Saved to the device after every change; the
/// Supabase layer will sync the same snapshot.
class AppState extends ChangeNotifier {
  AppState({OutfitEngine? engine, DateTime Function()? clock, AppStore? store, this.weatherService})
    : _engine = engine ?? OutfitEngine(),
      _clock = clock ?? DateTime.now,
      _store = store ?? MemoryStore();

  final OutfitEngine _engine;
  final DateTime Function() _clock;
  final AppStore _store;
  final WeatherService? weatherService;

  Profile profile = const Profile();
  final List<Item> items = [];
  final List<WearEntry> wearLog = [];

  Occasion occasion = Occasion.outing;
  Style style = Style.casual;

  /// A mild day until the weather service answers, and when offline.
  int temperatureC = 24;
  String? lockedItemId;

  final Set<String> _shown = {};
  Outfit? current;

  bool get onboarded => items.isNotEmpty;

  /// Loads what was saved on the device, then asks for today's weather.
  Future<void> restore() async {
    final saved = await _store.load();
    if (saved != null) {
      profile = saved.profile;
      items
        ..clear()
        ..addAll(saved.items);
      wearLog
        ..clear()
        ..addAll(saved.wearLog);
    }
    _refresh(reset: true, persist: false);
    await refreshWeather();
  }

  Future<void> refreshWeather() async {
    final high = await weatherService?.todayHighC(cityByKey(profile.city));
    if (high == null || high == temperatureC) return;
    temperatureC = high;
    _refresh(reset: true, persist: false);
  }

  void setProfile(Profile p) {
    final cityChanged = p.city != profile.city;
    profile = p;
    _refresh(reset: true);
    if (cityChanged) refreshWeather();
  }

  void addItems(Iterable<Item> newItems) {
    final known = items.map((i) => i.id).toSet();
    items.addAll(newItems.where((i) => !known.contains(i.id)));
    _refresh(reset: true);
  }

  void removeItem(String itemId) {
    items.removeWhere((i) => i.id == itemId);
    if (lockedItemId == itemId) lockedItemId = null;
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
    _refresh(persist: false);
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
    _save();
    notifyListeners();
  }

  void _save() => _store.save(Snapshot(profile: profile, items: List.of(items), wearLog: List.of(wearLog)));

  void _refresh({bool reset = false, bool persist = true}) {
    if (persist) _save();
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
      return _refresh(persist: false);
    }
    current = found.isEmpty ? null : found.first;
    notifyListeners();
  }
}
