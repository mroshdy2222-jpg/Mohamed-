import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:talla/app_state.dart';
import 'package:talla/data/basics.dart';
import 'package:talla/data/store.dart';
import 'package:talla/data/weather.dart';
import 'package:talla/domain/fashion_color.dart';
import 'package:talla/domain/models.dart';
import 'package:talla/main.dart';

WeatherService fixedWeather(int high, {List<Uri>? calls}) => WeatherService(
  MockClient((req) async {
    calls?.add(req.url);
    return http.Response(
      jsonEncode({
        'daily': {
          'temperature_2m_max': [high + 0.4],
        },
      }),
      200,
    );
  }),
);

void main() {
  test('wardrobe, profile and wear log survive a restart', () async {
    final store = MemoryStore();
    final a = AppState(store: store);
    a.setProfile(const Profile(gender: Gender.female, wearsHijab: true, city: 'Riyadh'));
    const ids = ['b-tee-white', 'b-shirt-sky', 'b-jeans-denim', 'b-sneakers-white', 'b-scarf-beige'];
    a.addItems(basics.where((b) => ids.contains(b.item.id)).map((b) => b.item));
    a.setStatus('b-tee-white', ItemStatus.laundry);
    expect(a.current, isNotNull);
    a.wearCurrent(withWhom: 'العيلة');

    final b = AppState(store: store);
    await b.restore();
    expect(b.profile.city, 'Riyadh');
    expect(b.profile.wearsHijab, isTrue);
    expect(b.items.map((i) => i.id), a.items.map((i) => i.id));
    expect(b.items.first.status, ItemStatus.laundry);
    expect(b.items.first.color, a.items.first.color);
    expect(b.wearLog.single.withWhom, 'العيلة');
  });

  test('a snapshot round-trips through JSON', () {
    const item = Item(
      id: 'x',
      category: Category.onePiece,
      color: Palette.burgundy,
      pattern: Pattern.printed,
      season: Season.winter,
      styles: {Style.dressy, Style.traditional},
      photoPath: '/photos/x.jpg',
    );
    final snap = Snapshot(profile: const Profile(), items: const [item], wearLog: const []);
    final back = Snapshot.fromJson(jsonDecode(jsonEncode(snap.toJson())) as Map<String, Object?>).items.single;
    expect(back.category, Category.onePiece);
    expect(back.color, Palette.burgundy);
    expect(back.pattern, Pattern.printed);
    expect(back.season, Season.winter);
    expect(back.styles, {Style.dressy, Style.traditional});
    expect(back.photoPath, '/photos/x.jpg');
  });

  test('weather sets the temperature for the chosen city, and offline keeps the last value', () async {
    final calls = <Uri>[];
    final state = AppState(weatherService: fixedWeather(33, calls: calls));
    await state.restore();
    expect(state.temperatureC, 33);
    expect(calls.single.queryParameters['latitude'], '30.04');

    final offline = AppState(weatherService: WeatherService(MockClient((_) async => throw Exception('offline'))));
    await offline.restore();
    expect(offline.temperatureC, 24);
  });

  testWidgets('add a piece by hand from the wardrobe', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    final state = AppState();
    state.addItems([basics.first.item]);
    await tester.pumpWidget(TallaApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('الدولاب').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addItem')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('قطعة واحدة'));
    await tester.tap(find.byKey(const Key('color-emerald')));
    await tester.ensureVisible(find.text('دريسي'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('دريسي'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('saveItem')));
    await tester.pumpAndSettle();

    final added = state.items.last;
    expect(state.items, hasLength(2));
    expect(added.category, Category.onePiece);
    expect(added.color, Palette.emerald);
    expect(added.styles, containsAll([Style.casual, Style.dressy]));
    expect(find.text('القطعة اتضافت'), findsOneWidget);
  });
}
