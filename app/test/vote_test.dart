import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talla/app_state.dart';
import 'package:talla/data/basics.dart';
import 'package:talla/data/store.dart';
import 'package:talla/main.dart';
import 'package:talla/ui/share_image.dart';
import 'package:talla/ui/vote_screen.dart';

const wardrobe = ['b-tee-white', 'b-tee-black', 'b-shirt-sky', 'b-jeans-denim', 'b-chino-beige', 'b-sneakers-white'];

AppState stocked([AppStore? store]) =>
    AppState(store: store)..addItems(basics.where((b) => wardrobe.contains(b.item.id)).map((b) => b.item));

void main() {
  test('a poll pits today\'s outfit against a different one, and swapping keeps option 1', () {
    final state = stocked();
    expect(state.startPollDraft(), isTrue);
    final draft = state.pollDraft!;
    expect(draft[0].signature, state.current!.signature);
    expect(draft[1].signature, isNot(draft[0].signature));

    state.swapPollOption();
    expect(state.pollDraft![0].signature, draft[0].signature);
    expect(state.pollDraft![1].signature, isNot(draft[1].signature));
  });

  test('one top and one bottom cannot make a poll', () {
    final state = AppState()
      ..addItems(basics.where((b) => ['b-tee-white', 'b-jeans-denim'].contains(b.item.id)).map((b) => b.item));
    expect(state.startPollDraft(), isFalse);
  });

  test('sent polls and their winners are saved', () async {
    final store = MemoryStore();
    final a = stocked(store)..startPollDraft();
    final poll = a.sendPoll()!;
    a.setPollWinner(poll.id, 1);

    final b = AppState(store: store);
    await b.restore();
    expect(b.polls.single.winner, 1);
    expect(b.polls.single.options, poll.options);

    b.useOutfit(b.polls.single, 1);
    expect(b.current!.items.map((i) => i.id), poll.options[1]);
  });

  testWidgets('ask friends from Today, share the image, record the winner, wear it', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final shared = <String>[];
    shareImage = (key, text) async => shared.add(text);

    final state = stocked();
    await tester.pumpWidget(TallaApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('خد رأي صحابك'));
    await tester.pumpAndSettle();
    expect(find.text('ده ولا ده؟'), findsWidgets);
    expect(find.text('رد برقم 1 أو 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sendPoll')));
    await tester.pumpAndSettle();
    expect(shared.single, 'ده ولا ده؟ المناسبة: خروجة. رد برقم 1 أو 2.');
    expect(state.polls, hasLength(1));

    await tester.tap(find.text('طقم 2'));
    await tester.pumpAndSettle();
    expect(state.polls.single.winner, 1);
    expect(find.text('الكسبان'), findsOneWidget);

    await tester.tap(find.text('هختاره · طقم 2'));
    await tester.pumpAndSettle();
    expect(find.text('طقم النهارده'), findsOneWidget);
    expect(state.current!.items.map((i) => i.id), state.polls.single.options[1]);
  });

  testWidgets('once the app has a store link, the poll carries it', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final shared = <String>[];
    shareImage = (key, text) async => shared.add(text);
    inviteLink = 'https://example.com/talla';
    addTearDown(() => inviteLink = '');

    await tester.pumpWidget(TallaApp(state: stocked()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('خد رأي صحابك'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sendPoll')));
    await tester.pumpAndSettle();
    expect(shared.single, 'ده ولا ده؟ المناسبة: خروجة. رد برقم 1 أو 2.\nجرّب طلّة: https://example.com/talla');
  });
}
