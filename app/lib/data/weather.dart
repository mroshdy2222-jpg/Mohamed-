import 'dart:convert';

import 'package:http/http.dart' as http;

class City {
  final String key;
  final double lat, lon;

  /// Standard time offset from UTC, used only to tell where the local day ends.
  final int utcOffset;

  const City(this.key, this.lat, this.lon, this.utcOffset);
}

/// The launch markets first: Egypt for testing, then the Gulf.
const cities = [
  City('Cairo', 30.04, 31.24, 2),
  City('Alexandria', 31.2, 29.92, 2),
  City('Riyadh', 24.71, 46.68, 3),
  City('Jeddah', 21.49, 39.19, 3),
  City('Dubai', 25.2, 55.27, 4),
  City('AbuDhabi', 24.45, 54.38, 4),
  City('Kuwait', 29.38, 47.99, 3),
  City('Doha', 25.29, 51.53, 3),
];

City cityByKey(String key) => cities.firstWhere((c) => c.key == key, orElse: () => cities.first);

/// The highest temperature left today, from MET Norway (the Norwegian
/// Meteorological Institute): free for commercial apps, no key, no account.
/// Its terms ask for an app name and a contact in the User-Agent, and credit
/// to MET Norway (CC BY 4.0). Returns null when offline or on any error, and
/// the app keeps its last value.
class WeatherService {
  final http.Client _client;
  final DateTime Function() _now;

  WeatherService([http.Client? client, DateTime Function()? now])
    : _client = client ?? http.Client(),
      _now = now ?? DateTime.now;

  static const _userAgent = 'Talla/1.0 github.com/mroshdy2222-jpg/Mohamed-';

  Future<int?> todayHighC(City city) async {
    final uri = Uri.https('api.met.no', '/weatherapi/locationforecast/2.0/compact', {
      'lat': city.lat.toStringAsFixed(2),
      'lon': city.lon.toStringAsFixed(2),
    });
    try {
      final res = await _client.get(uri, headers: {'User-Agent': _userAgent}).timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) return null;
      final series = ((jsonDecode(res.body) as Map)['properties'] as Map)['timeseries'] as List;
      final offset = Duration(hours: city.utcOffset);
      final today = _now().toUtc().add(offset).day;
      final temps = [
        for (final entry in series.cast<Map>())
          if (DateTime.parse(entry['time'] as String).add(offset).day == today)
            ((entry['data'] as Map)['instant'] as Map)['details']['air_temperature'] as num,
      ];
      if (temps.isEmpty) return null;
      return temps.reduce((a, b) => a > b ? a : b).round();
    } catch (_) {
      return null;
    }
  }
}
