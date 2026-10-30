import 'package:flutter_test/flutter_test.dart';
import 'package:talla/app_state.dart';
import 'package:talla/data/basics.dart';
import 'package:talla/domain/fashion_color.dart';
import 'package:talla/domain/missing_piece.dart';
import 'package:talla/domain/models.dart';

Item item(String id, Category c, FashionColor color) =>
    Item(id: id, category: c, color: color, styles: const {Style.casual});

List<MissingPiece> run(List<Item> wardrobe, List<Item> candidates, {bool hijab = false}) => missingPieces(
  wardrobe: wardrobe,
  candidates: candidates,
  style: Style.casual,
  profile: Profile(wearsHijab: hijab),
  temperatureC: 24,
);

void main() {
  final tops = [
    item('t1', Category.top, Palette.white),
    item('t2', Category.top, Palette.black),
    item('t3', Category.top, Palette.sky),
  ];
  final jeans = item('j', Category.bottom, Palette.denim);
  final sneakers = item('s', Category.shoes, Palette.white);

  test('with no shoes, a first pair completes every outfit and comes first', () {
    final result = run([...tops, jeans], [item('chino', Category.bottom, Palette.beige), sneakers]);
    expect(result.first.item.id, 's');
    expect(result.first.gain, 3);
  });

  test('with shoes, a second bottom adds one outfit per top', () {
    final result = run([...tops, jeans, sneakers], [item('chino', Category.bottom, Palette.beige)]);
    expect(result.single.gain, 3);
  });

  test('pieces already owned in the same colour are not suggested', () {
    final result = run([...tops, jeans, sneakers], [item('other-jeans', Category.bottom, Palette.denim)]);
    expect(result, isEmpty);
  });

  test('a headscarf is the missing piece for a user who wears one', () {
    final result = run([...tops, jeans, sneakers], [item('scarf', Category.headscarf, Palette.beige)], hijab: true);
    expect(result.single.gain, 3);
  });

  test('"I have this" adds the piece and the suggestion moves on', () {
    final state = AppState()
      ..addItems(basics.where((b) => ['b-tee-white', 'b-jeans-denim'].contains(b.item.id)).map((b) => b.item));
    final first = state.missing.first.item;
    state.addItems([first]);
    expect(state.items.map((i) => i.id), contains(first.id));
    expect(state.missing.map((m) => m.item.id), isNot(contains(first.id)));
  });
}
