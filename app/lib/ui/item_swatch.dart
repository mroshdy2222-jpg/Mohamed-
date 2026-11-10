import 'package:flutter/material.dart';

import '../data/photos.dart';
import '../domain/fashion_color.dart';
import '../domain/models.dart';
import 'theme.dart';

Color colorOf(FashionColor c) => HSLColor.fromAHSL(1, c.hue, c.saturation, c.lightness).toColor();

/// A piece of clothing: its photo when there is one, otherwise a flat
/// silhouette of its category in its colour, on a plain raised tile.
class ItemSwatch extends StatelessWidget {
  final Item item;
  final bool locked;

  /// Picked in a multi-select grid (onboarding), shown with a check.
  final bool selected;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// True when the tile sits directly on the page, so it needs the raised
  /// surface to stand out. Inside a card the plain surface already contrasts.
  final bool onPage;

  const ItemSwatch({
    super.key,
    required this.item,
    this.locked = false,
    this.selected = false,
    this.onTap,
    this.semanticLabel,
    this.onPage = false,
  });

  Widget _silhouette(TallaColors c) => Padding(
    padding: const EdgeInsets.all(Space.s2),
    child: CustomPaint(painter: _Silhouette(item.category, colorOf(item.color), c.line)),
  );

  @override
  Widget build(BuildContext context) {
    final c = TallaColors.of(context);
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      selected: locked || selected,
      child: Material(
        color: onPage ? c.surfaceRaised : c.surface,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.sm),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.sm),
              border: locked
                  ? Border.all(color: c.saffron, width: 2)
                  : selected
                  ? Border.all(color: c.nile, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: item.photoPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(Radii.sm),
                          child: Image(
                            image: photoProvider(item.photoPath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _silhouette(c),
                          ),
                        )
                      : _silhouette(c),
                ),
                if (locked)
                  PositionedDirectional(
                    top: Space.s1,
                    start: Space.s1,
                    child: Icon(Icons.lock_rounded, size: 16, color: c.saffron),
                  ),
                if (selected)
                  PositionedDirectional(
                    top: Space.s1,
                    start: Space.s1,
                    child: Icon(Icons.check_circle_rounded, size: 18, color: c.nile),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Silhouette extends CustomPainter {
  final Category category;
  final Color fill;
  final Color outline;

  _Silhouette(this.category, this.fill, this.outline);

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn in a 40×48 box, scaled to fit and centred.
    final scale = (size.width / 40).clamp(0.0, size.height / 48);
    canvas.translate((size.width - 40 * scale) / 2, (size.height - 48 * scale) / 2);
    canvas.scale(scale);
    final path = _path(category);
    canvas.drawPath(path, Paint()..color = fill);
    // Light colours need an edge to read on the light tile.
    if (fill.computeLuminance() > 0.7) {
      canvas.drawPath(
        path,
        Paint()
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  static Path _path(Category c) {
    final p = Path();
    switch (c) {
      case Category.top:
        p.moveTo(12, 6);
        p.lineTo(4, 14);
        p.lineTo(9, 19);
        p.lineTo(12, 16);
        p.lineTo(12, 42);
        p.lineTo(28, 42);
        p.lineTo(28, 16);
        p.lineTo(31, 19);
        p.lineTo(36, 14);
        p.lineTo(28, 6);
        p.quadraticBezierTo(20, 11, 12, 6);
      case Category.outerwear:
        // Two front panels with lapels, open down the middle.
        p.moveTo(13, 5);
        p.lineTo(3, 14);
        p.lineTo(6, 42);
        p.lineTo(19, 42);
        p.lineTo(19, 24);
        p.lineTo(14, 8);
        p.close();
        p.moveTo(27, 5);
        p.lineTo(37, 14);
        p.lineTo(34, 42);
        p.lineTo(21, 42);
        p.lineTo(21, 24);
        p.lineTo(26, 8);
        p.close();
      case Category.bottom:
        p.moveTo(10, 4);
        p.lineTo(30, 4);
        p.lineTo(32, 44);
        p.lineTo(23, 44);
        p.lineTo(20, 18);
        p.lineTo(17, 44);
        p.lineTo(8, 44);
        p.close();
      case Category.onePiece:
        // Shoulders and short sleeves, flaring to the hem: a dress or a robe.
        p.moveTo(15, 4);
        p.quadraticBezierTo(20, 8, 25, 4);
        p.lineTo(32, 7);
        p.lineTo(37, 17);
        p.lineTo(32, 19);
        p.lineTo(29, 14);
        p.lineTo(33, 45);
        p.lineTo(7, 45);
        p.lineTo(11, 14);
        p.lineTo(8, 19);
        p.lineTo(3, 17);
        p.lineTo(8, 7);
        p.close();
      case Category.shoes:
        // A sneaker from the side: the upper, then the sole below a gap.
        p.moveTo(5, 34);
        p.lineTo(5, 25);
        p.quadraticBezierTo(5, 21, 9, 21);
        p.lineTo(15, 21);
        p.lineTo(18, 25);
        p.quadraticBezierTo(27, 26, 33, 29);
        p.quadraticBezierTo(36, 30.5, 36, 34);
        p.close();
        p.addRRect(RRect.fromLTRBR(4, 35.5, 37, 39, const Radius.circular(1.5)));
      case Category.headscarf:
      case Category.shemagh:
        // A hood around an open face, falling over the shoulders.
        p.fillType = PathFillType.evenOdd;
        p.moveTo(20, 4);
        p.quadraticBezierTo(34, 4, 34, 20);
        p.lineTo(37, 44);
        p.lineTo(3, 44);
        p.lineTo(6, 20);
        p.quadraticBezierTo(6, 4, 20, 4);
        p.close();
        p.addOval(const Rect.fromLTRB(13, 12, 27, 31));
      case Category.bag:
        p.addRRect(RRect.fromLTRBR(6, 16, 34, 42, const Radius.circular(4)));
        p.addRect(const Rect.fromLTRB(14, 8, 26, 11));
      case Category.belt:
        p.addRRect(RRect.fromLTRBR(2, 21, 38, 27, const Radius.circular(2)));
        p.addRRect(RRect.fromLTRBR(15, 18, 25, 30, const Radius.circular(2)));
      case Category.watch:
        p.addRRect(RRect.fromLTRBR(15, 4, 25, 44, const Radius.circular(3)));
        p.addOval(Rect.fromCircle(center: const Offset(20, 24), radius: 9));
      case Category.jewelry:
        p.moveTo(8, 8);
        p.quadraticBezierTo(20, 34, 32, 8);
        p.lineTo(30, 8);
        p.quadraticBezierTo(20, 30, 10, 8);
        p.close();
        p.addOval(Rect.fromCircle(center: const Offset(20, 30), radius: 5));
      case Category.sunglasses:
        p.addOval(const Rect.fromLTRB(3, 18, 18, 30));
        p.addOval(const Rect.fromLTRB(22, 18, 37, 30));
        p.addRect(const Rect.fromLTRB(17, 21, 23, 23));
      case Category.perfume:
        p.addRRect(RRect.fromLTRBR(10, 18, 30, 44, const Radius.circular(4)));
        p.addRect(const Rect.fromLTRB(16, 10, 24, 18));
      case Category.cap:
        p.moveTo(6, 30);
        p.quadraticBezierTo(8, 12, 22, 12);
        p.quadraticBezierTo(34, 12, 34, 30);
        p.lineTo(38, 30);
        p.lineTo(38, 34);
        p.lineTo(6, 34);
        p.close();
      case Category.beanie:
        p.moveTo(8, 34);
        p.quadraticBezierTo(8, 12, 20, 12);
        p.quadraticBezierTo(32, 12, 32, 34);
        p.close();
        p.addRRect(RRect.fromLTRBR(6, 32, 34, 40, const Radius.circular(2)));
        p.addOval(Rect.fromCircle(center: const Offset(20, 9), radius: 4));
      case Category.turban:
        p.moveTo(6, 32);
        p.quadraticBezierTo(4, 10, 20, 8);
        p.quadraticBezierTo(36, 10, 34, 32);
        p.quadraticBezierTo(20, 26, 6, 32);
        p.close();
      case Category.neckScarf:
        p.moveTo(8, 10);
        p.quadraticBezierTo(20, 18, 32, 10);
        p.lineTo(32, 16);
        p.quadraticBezierTo(26, 20, 24, 22);
        p.lineTo(26, 44);
        p.lineTo(19, 44);
        p.lineTo(18, 22);
        p.quadraticBezierTo(12, 18, 8, 16);
        p.close();
      case Category.accessory:
        p.addOval(Rect.fromCircle(center: const Offset(20, 24), radius: 12));
    }
    return p;
  }

  @override
  bool shouldRepaint(_Silhouette old) => old.category != category || old.fill != fill;
}
