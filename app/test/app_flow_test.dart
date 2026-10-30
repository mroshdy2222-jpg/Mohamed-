import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talla/app_state.dart';
import 'package:talla/domain/languages.dart';
import 'package:talla/domain/models.dart';
import 'package:talla/domain/outfit_engine.dart';
import 'package:talla/main.dart';

void main() {
  testWidgets('onboarding to first outfit in Arabic, right to left', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    final state = AppState(engine: OutfitEngine(seed: 1), clock: () => DateTime(2026, 10, 30, 8));
    await tester.pumpWidget(TallaApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('عندك الحاجات دي؟'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('عندك الحاجات دي؟'))), TextDirection.rtl);

    for (final id in ['b-tee-white', 'b-jeans-denim', 'b-sneakers-white', 'b-chino-beige', 'b-blouse-blush']) {
      await tester.ensureVisible(find.byKey(Key(id)));
      await tester.tap(find.byKey(Key(id)));
      await tester.pump();
    }
    await tester.tap(find.byKey(const Key('basicsDone')));
    await tester.pumpAndSettle();

    expect(find.text('طقم النهارده'), findsOneWidget);
    expect(find.text('هلبسه'), findsOneWidget);
    expect(state.current, isNotNull);
    expect(state.current!.items.map((i) => i.category), containsAll([Category.top, Category.bottom, Category.shoes]));

    final first = state.current!.signature;
    await tester.tap(find.text('لبّسني تاني'));
    await tester.pumpAndSettle();
    expect(state.current!.signature, isNot(first));

    await tester.tap(find.text('هلبسه'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('withWhom')), 'صحاب الجامعة');
    await tester.tap(find.text('سجّل'));
    await tester.pumpAndSettle();
    expect(state.wearLog.single.withWhom, 'صحاب الجامعة');
    expect(find.text('اتسجل في سجل اللبس'), findsOneWidget);
  });

  testWidgets('English layout is left to right', (tester) async {
    final state = AppState()..setProfile(const Profile(language: AppLanguage.english));
    await tester.pumpWidget(TallaApp(state: state));
    await tester.pumpAndSettle();
    expect(find.text('Do you have these?'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('Do you have these?'))), TextDirection.ltr);
  });

  testWidgets('Gulf and Standard Arabic use their own words, and the choice is kept', (tester) async {
    final state = AppState();
    await tester.pumpWidget(TallaApp(state: state, deviceLocale: const Locale('ar', 'AE')));
    await tester.pumpAndSettle();
    expect(find.text('عندك هالأغراض؟'), findsOneWidget);

    await tester.tap(find.text('فصحى'));
    await tester.pumpAndSettle();
    expect(find.text('هل تملك هذه القطع؟'), findsOneWidget);
    expect(state.profile.language, AppLanguage.standard);
  });

  test('first launch follows the phone region', () {
    expect(defaultLanguage(const Locale('en', 'EG')), AppLanguage.egyptian);
    expect(defaultLanguage(const Locale('ar', 'EG')), AppLanguage.egyptian);
    expect(defaultLanguage(const Locale('en', 'AE')), AppLanguage.gulf);
    expect(defaultLanguage(const Locale('ar', 'SA')), AppLanguage.gulf);
    expect(defaultLanguage(const Locale('ar', 'JO')), AppLanguage.standard);
  });
}
