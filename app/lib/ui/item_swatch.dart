import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/photos.dart';
import '../domain/fashion_color.dart';
import '../domain/models.dart';
import 'garments.dart';
import 'theme.dart';

Color colorOf(FashionColor c) => HSLColor.fromAHSL(1, c.hue, c.saturation, c.lightness).toColor();

/// The drawing for a piece without a photo. Onboarding pieces say what they
/// are in their id (b-loafers-brown); the rest get their category's drawing.
String garmentFor(Item item) {
  final parts = item.id.split('-');
  if (parts.length > 2 && parts.first == 'b' && garments.containsKey(parts[1])) return parts[1];
  return switch (item.category) {
    Category.top => 'tee',
    Category.bottom => 'trousers',
    Category.onePiece => 'dress',
    Category.outerwear => 'jacket',
    Category.shoes => 'sneakers',
    Category.headscarf => 'scarf',
    Category.bag => 'bag',
    Category.shemagh => 'shemagh',
    Category.belt => 'belt',
    Category.watch => 'watch',
    Category.jewelry => 'jewelry',
    Category.sunglasses => 'sunglasses',
    Category.perfume => 'perfume',
    Category.cap => 'cap',
    Category.beanie => 'beanie',
    Category.turban => 'turban',
    Category.neckScarf => 'neckScarf',
    Category.accessory => 'accessory',
  };
}

/// A piece of clothing: its photo when there is one, otherwise a drawing of
/// it in its colour, on a plain raised tile.
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
    child: SvgPicture.string(
      garments[garmentFor(item)]!,
      theme: SvgTheme(currentColor: colorOf(item.color)),
      fit: BoxFit.contain,
    ),
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
