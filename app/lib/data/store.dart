import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models.dart';
import '../domain/serialization.dart';

/// What survives closing the app. Synced to Supabase later; on the device it
/// is the source of truth, so the wardrobe opens without internet.
class Snapshot {
  final Profile profile;
  final List<Item> items;
  final List<WearEntry> wearLog;
  final List<Poll> polls;

  const Snapshot({required this.profile, required this.items, required this.wearLog, this.polls = const []});

  Map<String, Object?> toJson() => {
    'v': 1,
    'profile': profileToJson(profile),
    'items': [for (final i in items) itemToJson(i)],
    'wearLog': [for (final e in wearLog) wearToJson(e)],
    'polls': [for (final p in polls) pollToJson(p)],
  };

  static Snapshot fromJson(Map<String, Object?> j) => Snapshot(
    profile: profileFromJson((j['profile'] as Map).cast<String, Object?>()),
    items: [for (final i in (j['items'] as List? ?? const [])) itemFromJson((i as Map).cast<String, Object?>())],
    wearLog: [for (final e in (j['wearLog'] as List? ?? const [])) wearFromJson((e as Map).cast<String, Object?>())],
    polls: [for (final p in (j['polls'] as List? ?? const [])) pollFromJson((p as Map).cast<String, Object?>())],
  );
}

abstract class AppStore {
  Future<Snapshot?> load();
  Future<void> save(Snapshot snapshot);
}

class PrefsStore implements AppStore {
  static const _key = 'talla.v1';

  @override
  Future<Snapshot?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return Snapshot.fromJson((jsonDecode(raw) as Map).cast<String, Object?>());
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  @override
  Future<void> save(Snapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(snapshot.toJson()));
  }
}

/// For tests, and for the app before anything is stored.
class MemoryStore implements AppStore {
  Snapshot? saved;

  MemoryStore([this.saved]);

  @override
  Future<Snapshot?> load() async => saved;

  @override
  Future<void> save(Snapshot snapshot) async => saved = snapshot;
}
