import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../domain/fashion_color.dart';
import '../domain/models.dart';

/// What the server suggests for a photo. Any field can be null: the user
/// then picks it by hand, as before.
class SuggestedTags {
  final Category? category;
  final FashionColor? color;
  final Pattern? pattern;
  final Season? season;
  final Set<Style> styles;

  const SuggestedTags({this.category, this.color, this.pattern, this.season, this.styles = const {}});
}

enum TagFailure { personInPhoto, unavailable }

class TaggingException implements Exception {
  final TagFailure reason;

  const TaggingException(this.reason);
}

T? _byName<T extends Enum>(List<T> values, Object? name) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

/// Calls the tag-item function on the Talla server. The keys of the AI
/// providers live on the server; the app only holds the public project key.
class TaggingService {
  final Uri endpoint;
  final String publicKey;
  final http.Client _client;

  TaggingService({required String projectUrl, required this.publicKey, http.Client? client})
    : endpoint = Uri.parse('$projectUrl/functions/v1/tag-item'),
      _client = client ?? http.Client();

  /// From the build: flutter run --dart-define=SUPABASE_URL=… --dart-define=SUPABASE_ANON_KEY=…
  /// Null when the build has no server, and the add screen stays manual.
  static TaggingService? fromEnvironment() {
    const url = String.fromEnvironment('SUPABASE_URL');
    const key = String.fromEnvironment('SUPABASE_ANON_KEY');
    return url.isEmpty || key.isEmpty ? null : TaggingService(projectUrl: url, publicKey: key);
  }

  Future<SuggestedTags> tag(Uint8List jpeg) async {
    final http.Response res;
    try {
      res = await _client
          .post(
            endpoint,
            headers: {'authorization': 'Bearer $publicKey', 'apikey': publicKey, 'content-type': 'application/json'},
            body: jsonEncode({'image': base64Encode(jpeg), 'mime': 'image/jpeg'}),
          )
          .timeout(const Duration(seconds: 20));
    } catch (_) {
      throw const TaggingException(TagFailure.unavailable);
    }
    final body = jsonDecode(res.body) as Map<String, Object?>;
    if (res.statusCode == 422 && body['error'] == 'person_in_photo') {
      throw const TaggingException(TagFailure.personInPhoto);
    }
    if (res.statusCode != 200) throw const TaggingException(TagFailure.unavailable);
    final tags = (body['tags'] as Map).cast<String, Object?>();
    return SuggestedTags(
      category: _byName(Category.values, tags['category']),
      color: Palette.all.where((c) => c.key == tags['color']).firstOrNull,
      pattern: _byName(Pattern.values, tags['pattern']),
      season: _byName(Season.values, tags['season']),
      styles: {for (final s in (tags['styles'] as List? ?? const [])) ?_byName(Style.values, s)},
    );
  }
}
