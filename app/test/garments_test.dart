import 'package:flutter_test/flutter_test.dart';
import 'package:talla/data/basics.dart';
import 'package:talla/domain/fashion_color.dart';
import 'package:talla/domain/models.dart';
import 'package:talla/ui/garments.dart';
import 'package:talla/ui/item_swatch.dart';

void main() {
  test('every onboarding piece has its own drawing, and every category has one', () {
    for (final b in basics) {
      expect(garmentFor(b.item), b.kind, reason: b.item.id);
    }
    for (final c in Category.values) {
      final item = Item(id: 'x', category: c, color: Palette.black);
      expect(garments.containsKey(garmentFor(item)), isTrue, reason: '$c');
    }
  });
}
