/// A named garment colour. Items are tagged with the nearest name from this
/// catalog, so the engine reasons about "navy" and "camel" the way a stylist
/// does, instead of about raw pixels.
class FashionColor {
  final String key;

  /// Hue in degrees (0–360), saturation and lightness in 0–1.
  final double hue;
  final double saturation;
  final double lightness;

  /// Neutrals go with almost everything. Navy, denim, camel and olive count as
  /// neutrals in styling even though they have a visible hue.
  final bool neutral;

  const FashionColor(this.key, this.hue, this.saturation, this.lightness, {this.neutral = false});

  @override
  bool operator ==(Object other) => other is FashionColor && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

class Palette {
  static const white = FashionColor('white', 0, 0, 0.97, neutral: true);
  static const cream = FashionColor('cream', 40, 0.45, 0.9, neutral: true);
  static const black = FashionColor('black', 0, 0, 0.08, neutral: true);
  static const grey = FashionColor('grey', 0, 0, 0.55, neutral: true);
  static const navy = FashionColor('navy', 220, 0.45, 0.22, neutral: true);
  static const denim = FashionColor('denim', 212, 0.35, 0.45, neutral: true);
  static const beige = FashionColor('beige', 35, 0.35, 0.8, neutral: true);
  static const camel = FashionColor('camel', 30, 0.45, 0.55, neutral: true);
  static const brown = FashionColor('brown', 25, 0.4, 0.3, neutral: true);
  static const olive = FashionColor('olive', 70, 0.35, 0.35, neutral: true);
  static const khaki = FashionColor('khaki', 50, 0.3, 0.6, neutral: true);
  static const red = FashionColor('red', 355, 0.75, 0.47);
  static const burgundy = FashionColor('burgundy', 345, 0.6, 0.27);
  static const pink = FashionColor('pink', 340, 0.6, 0.75);
  static const blush = FashionColor('blush', 15, 0.5, 0.85);
  static const orange = FashionColor('orange', 25, 0.85, 0.55);
  static const mustard = FashionColor('mustard', 45, 0.7, 0.5);
  static const yellow = FashionColor('yellow', 52, 0.9, 0.6);
  static const green = FashionColor('green', 125, 0.45, 0.42);
  static const emerald = FashionColor('emerald', 155, 0.6, 0.32);
  static const teal = FashionColor('teal', 178, 0.6, 0.32);
  static const sky = FashionColor('sky', 200, 0.65, 0.75);
  static const blue = FashionColor('blue', 218, 0.7, 0.48);
  static const lavender = FashionColor('lavender', 265, 0.45, 0.78);
  static const purple = FashionColor('purple', 280, 0.5, 0.38);

  static const all = [
    white,
    cream,
    black,
    grey,
    navy,
    denim,
    beige,
    camel,
    brown,
    olive,
    khaki,
    red,
    burgundy,
    pink,
    blush,
    orange,
    mustard,
    yellow,
    green,
    emerald,
    teal,
    sky,
    blue,
    lavender,
    purple,
  ];

  static FashionColor byKey(String key) => all.firstWhere((c) => c.key == key);
}
