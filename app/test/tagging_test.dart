import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:talla/app_state.dart';
import 'package:talla/data/tagging.dart';
import 'package:talla/domain/fashion_color.dart';
import 'package:talla/domain/models.dart';
import 'package:talla/l10n/app_localizations.dart';
import 'package:talla/ui/add_item_screen.dart';
import 'package:talla/ui/theme.dart';

const dressTags = {
  'tags': {
    'category': 'onePiece',
    'color': 'burgundy',
    'pattern': 'solid',
    'season': 'winter',
    'styles': ['dressy', 'traditional', 'boho'],
  },
  'provider': 'gemini:test',
};

TaggingService server(http.Response Function(http.Request) reply) => TaggingService(
  projectUrl: 'https://proj.supabase.co',
  publicKey: 'anon',
  client: MockClient((r) async => reply(r)),
);

/// A real 1×1 PNG, so the preview can decode it.
final photo = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

void main() {
  test('sends the photo to the tag-item function and maps the answer to app values', () async {
    late http.Request sent;
    final tags = await server((r) {
      sent = r;
      return http.Response(jsonEncode(dressTags), 200);
    }).tag(photo);

    expect(sent.url.toString(), 'https://proj.supabase.co/functions/v1/tag-item');
    expect(sent.headers['authorization'], 'Bearer anon');
    expect(jsonDecode(sent.body)['image'], base64Encode(photo));
    expect(tags.category, Category.onePiece);
    expect(tags.color, Palette.burgundy);
    expect(tags.season, Season.winter);
    expect(tags.styles, {Style.dressy, Style.traditional});
  });

  test('a photo of a person and an unreachable server are told apart', () async {
    final person = server((_) => http.Response(jsonEncode({'error': 'person_in_photo'}), 422));
    await expectLater(
      person.tag(photo),
      throwsA(isA<TaggingException>().having((e) => e.reason, 'reason', TagFailure.personInPhoto)),
    );
    final down = TaggingService(
      projectUrl: 'https://proj.supabase.co',
      publicKey: 'anon',
      client: MockClient((_) async => throw Exception('offline')),
    );
    await expectLater(
      down.tag(photo),
      throwsA(isA<TaggingException>().having((e) => e.reason, 'reason', TagFailure.unavailable)),
    );
  });

  test('without a server in the build, auto-tagging is off', () {
    expect(TaggingService.fromEnvironment(), isNull);
  });

  Future<void> openAddScreen(WidgetTester tester, AppState state) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar', 'EG'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: buildTheme(Brightness.light),
        home: AddItemScreen(state: state, pickPhoto: (_) async => photo),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<bool> chipSelected(WidgetTester tester, String label) async {
    final chip = find.widgetWithText(ChoiceChip, label);
    await tester.scrollUntilVisible(chip, 200, scrollable: find.byType(Scrollable).first);
    return tester.widget<ChoiceChip>(chip).selected;
  }

  testWidgets('a photo pre-fills type, colour and styles, and says so', (tester) async {
    final state = AppState(taggingService: server((_) => http.Response(jsonEncode(dressTags), 200)));
    await openAddScreen(tester, state);

    await tester.tap(find.text('صوّر'));
    await tester.pumpAndSettle();

    expect(find.text('طالا اقترحت التفاصيل، راجعها قبل ما تضيف.'), findsOneWidget);
    expect(await chipSelected(tester, 'قطعة واحدة'), isTrue);
    expect(await chipSelected(tester, 'دريسي'), isTrue);
    expect(await chipSelected(tester, 'تراثي'), isTrue);
    expect(await chipSelected(tester, 'كاجوال'), isFalse);
    expect(find.text('عنابي'), findsOneWidget);
  });

  testWidgets('a photo of a person is not tagged and the user is told how to shoot it', (tester) async {
    final state = AppState(taggingService: server((_) => http.Response(jsonEncode({'error': 'person_in_photo'}), 422)));
    await openAddScreen(tester, state);

    await tester.tap(find.text('من المعرض'));
    await tester.pumpAndSettle();

    expect(find.text('صوّر القطعة لوحدها، من غير ما حد يلبسها.'), findsOneWidget);
    expect(await chipSelected(tester, 'لبس علوي'), isTrue);
  });
}
