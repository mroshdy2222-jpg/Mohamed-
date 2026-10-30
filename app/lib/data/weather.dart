import 'dart:convert';

import 'package:http/http.dart' as http;

class City {
  final String key;
  final double lat, lon;

  const City(this.key, this.lat, this.lon);
}

/// The launch markets first: Egypt for testing, then the Gulf.
const cities = [
  City('Cairo', 30.04, 31.24),
  City('Alexandria', 31.2, 29.92),
  City('Riyadh', 24.71, 46.68),
  City('Jeddah', 21.49, 39.19),
  City('Dubai', 25.2, 55.27),
  City('AbuDhabi', 24.45, 54.38),
  City('Kuwait', 29.38, 47.99),
  City('Doha', 25.29, 51.53),
];

City cityByKey(String key) => cities.firstWhere((c) => c.key == key, orElse: () => cities.first);

/// Today's daytime high from Open-Meteo: free, no key, no account. Returns
/// null when offline or on any error, and the app keeps its last value.
class WeatherService {
  final http.Client _client;

  WeatherService([http.Client? client]) : _client = client ?? http.Client();

  Future<int?> todayHighC(City city) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${city.lat}',
      'longitude': '${city.lon}',
      'daily': 'temperature_2m_max',
      'timezone': 'auto',
      'forecast_days': '1',
    });
    try {
      final res = await _client.get(uri).timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) return null;
      final daily = (jsonDecode(res.body) as Map)['daily'] as Map;
      final highs = daily['temperature_2m_max'] as List;
      return highs.isEmpty ? null : (highs.first as num).round();
    } catch (_) {
      return null;
    }
  }
}
