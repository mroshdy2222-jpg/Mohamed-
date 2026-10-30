import 'package:flutter/foundation.dart';

import 'data/basics.dart';
import 'data/store.dart';
import 'data/weather.dart';
import 'domain/color_harmony.dart';
import 'domain/missing_piece.dart';
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

  /// Newest first.
  final List<Poll> polls = [];

  /// The two outfits of a poll being prepared, before it is sent.
  List<Outfit>? pollDraft;
  final Set<String> _draftShown = {};

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
      polls
        ..clear()
        ..addAll(saved.polls);
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

  /// "Another option": the next best outfit not shown yet.
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

  String? _missingKey;
  List<MissingPiece> _missing = const [];

  /// The pieces that would add the most outfits in the current style,
  /// worked out on the phone. Recomputed only when its inputs change.
  List<MissingPiece> get missing {
    final key = [
      style.name,
      profile.gender.name,
      profile.wearsHijab,
      temperatureC,
      for (final i in items) '${i.id}:${i.status.name}',
    ].join('|');
    if (key != _missingKey) {
      _missingKey = key;
      _missing = missingPieces(
        wardrobe: items,
        candidates: basicsFor(profile.gender).map((b) => b.item).toList(),
        style: style,
        profile: profile,
        temperatureC: temperatureC,
      );
    }
    return _missing;
  }

  /// Starts "this or that?" with today's outfit against the next best one.
  /// False when the wardrobe cannot make two different outfits yet.
  bool startPollDraft() {
    _draftShown.clear();
    if (current == null) {
      pollDraft = null;
      notifyListeners();
      return false;
    }
    final other = _alternative(current!);
    pollDraft = other == null ? null : [current!, other];
    notifyListeners();
    return pollDraft != null;
  }

  void cancelPollDraft() {
    pollDraft = null;
    notifyListeners();
  }

  /// Replaces option 2 with another outfit; option 1 stays.
  void swapPollOption() {
    final draft = pollDraft;
    if (draft == null) return;
    _draftShown.add(draft[1].signature);
    var other = _alternative(draft[0]);
    if (other == null) {
      _draftShown.clear();
      other = _alternative(draft[0]);
    }
    if (other != null) pollDraft = [draft[0], other];
    notifyListeners();
  }

  Outfit? _alternative(Outfit first) {
    final found = _engine.suggest(
      items,
      wearLog,
      OutfitRequest(
        style: style,
        temperatureC: temperatureC,
        profile: profile,
        exclude: {first.signature, ..._draftShown},
        now: _clock(),
      ),
      limit: 1,
    );
    return found.isEmpty ? null : found.first;
  }

  /// Saves the draft as a poll once it has been shared.
  Poll? sendPoll() {
    final draft = pollDraft;
    if (draft == null) return null;
    final poll = Poll(
      id: 'p-${_clock().microsecondsSinceEpoch}',
      created: _clock(),
      occasion: occasion,
      style: style,
      options: [for (final o in draft) o.items.map((i) => i.id).toList()],
    );
    polls.insert(0, poll);
    pollDraft = null;
    _save();
    notifyListeners();
    return poll;
  }

  void setPollWinner(String pollId, int option) {
    final i = polls.indexWhere((p) => p.id == pollId);
    if (i < 0) return;
    polls[i] = polls[i].withWinner(option);
    _save();
    notifyListeners();
  }

  /// The pieces of a poll option that are still in the wardrobe.
  List<Item> itemsOf(List<String> ids) => [
    for (final id in ids)
      for (final i in items)
        if (i.id == id) i,
  ];

  /// Makes a poll option today's outfit, so "choose this" logs it.
  void useOutfit(Poll poll, int option) {
    final chosen = itemsOf(poll.options[option]);
    if (chosen.isEmpty) return;
    occasion = poll.occasion;
    style = poll.style;
    lockedItemId = null;
    final harmony = scoreColors(chosen.map((i) => i.color).toList(), patterns: chosen.map((i) => i.pattern).toList());
    current = Outfit(chosen, harmony, harmony.score);
    notifyListeners();
  }

  void _save() =>
      _store.save(Snapshot(profile: profile, items: List.of(items), wearLog: List.of(wearLog), polls: List.of(polls)));

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
