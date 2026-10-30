import 'package:flutter/material.dart';

/// Colours and type from the Talla design system (tokens.json). Light and dark
/// share every token name; widgets read them through [TallaColors.of].
@immutable
class TallaColors extends ThemeExtension<TallaColors> {
  final Color surface, surfaceRaised, ink, inkMuted, line, nile, onNile, nileTint, saffron, rose;

  const TallaColors({
    required this.surface,
    required this.surfaceRaised,
    required this.ink,
    required this.inkMuted,
    required this.line,
    required this.nile,
    required this.onNile,
    required this.nileTint,
    required this.saffron,
    required this.rose,
  });

  static const light = TallaColors(
    surface: Color(0xFFF4F6F5),
    surfaceRaised: Color(0xFFFFFFFF),
    ink: Color(0xFF15201F),
    inkMuted: Color(0xFF56635F),
    line: Color(0xFFD5DDDA),
    nile: Color(0xFF0F6B66),
    onNile: Color(0xFFFFFFFF),
    nileTint: Color(0xFFDCEFEC),
    saffron: Color(0xFFF2A93B),
    rose: Color(0xFFC93C63),
  );

  static const dark = TallaColors(
    surface: Color(0xFF111716),
    surfaceRaised: Color(0xFF1A2221),
    ink: Color(0xFFECF2F0),
    inkMuted: Color(0xFFA3B1AD),
    line: Color(0xFF2A3533),
    nile: Color(0xFF5CC2B8),
    onNile: Color(0xFF0B1A19),
    nileTint: Color(0xFF173634),
    saffron: Color(0xFFF2A93B),
    rose: Color(0xFFE2708F),
  );

  static TallaColors of(BuildContext context) => Theme.of(context).extension<TallaColors>()!;

  @override
  TallaColors copyWith() => this;

  @override
  TallaColors lerp(TallaColors? other, double t) => t < 0.5 ? this : (other ?? this);
}

class Space {
  static const s1 = 4.0, s2 = 8.0, s4 = 16.0, s6 = 24.0, s8 = 32.0;
}

class Radii {
  static const sm = 6.0, md = 12.0, pill = 999.0;
}

const displayFont = 'Alexandria';
const bodyFont = 'IBM Plex Sans Arabic';

ThemeData buildTheme(Brightness brightness) {
  final c = brightness == Brightness.light ? TallaColors.light : TallaColors.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: c.nile,
    brightness: brightness,
  ).copyWith(primary: c.nile, onPrimary: c.onNile, surface: c.surface, onSurface: c.ink, error: c.rose);
  TextStyle display(double size, double height, FontWeight w) =>
      TextStyle(fontFamily: displayFont, fontSize: size, height: height / size, fontWeight: w, color: c.ink);
  TextStyle body(double size, double height, FontWeight w, [Color? color]) =>
      TextStyle(fontFamily: bodyFont, fontSize: size, height: height / size, fontWeight: w, color: color ?? c.ink);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.surface,
    fontFamily: bodyFont,
    extensions: [c],
    textTheme: TextTheme(
      displaySmall: display(48, 56, FontWeight.w700),
      headlineSmall: display(28, 36, FontWeight.w600),
      titleMedium: display(20, 28, FontWeight.w600),
      bodyLarge: body(16, 26, FontWeight.w400),
      bodyMedium: body(14, 22, FontWeight.w400, c.inkMuted),
      labelLarge: body(13, 18, FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.nile,
        foregroundColor: c.onNile,
        minimumSize: const Size(44, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
        textStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.ink,
        backgroundColor: c.surfaceRaised,
        minimumSize: const Size(44, 44),
        side: BorderSide(color: c.line, width: 1.5),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.nile,
        minimumSize: const Size(44, 44),
        textStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.surfaceRaised,
      selectedColor: c.nileTint,
      side: BorderSide(color: c.line, width: 1.5),
      shape: const StadiumBorder(),
      labelStyle: body(13, 18, FontWeight.w600),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.surfaceRaised,
      indicatorColor: c.nileTint,
      labelTextStyle: WidgetStatePropertyAll(body(12, 16, FontWeight.w600)),
    ),
  );
}
