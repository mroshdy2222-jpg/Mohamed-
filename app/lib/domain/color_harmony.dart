import 'fashion_color.dart';
import 'models.dart';

/// Why a set of colours works. The UI turns it into the one-line reason.
enum Harmony { neutrals, accent, monochrome, analogous, complementary, clash }

class HarmonyResult {
  final Harmony harmony;

  /// 0–1. Higher is a safer, better-balanced combination.
  final double score;

  const HarmonyResult(this.harmony, this.score);
}

double hueDistance(double a, double b) {
  final d = (a - b).abs() % 360;
  return d > 180 ? 360 - d : d;
}

/// Scores the colours of an outfit with the rules a stylist would use:
/// one accent on neutrals is the safest; two accents must be close on the
/// wheel or opposite it; three or more accents clash.
HarmonyResult scoreColors(List<FashionColor> colors, {List<Pattern> patterns = const []}) {
  final accents = <FashionColor>{...colors.where((c) => !c.neutral)}.toList();

  HarmonyResult result;
  if (accents.isEmpty) {
    result = const HarmonyResult(Harmony.neutrals, 0.8);
  } else if (accents.length == 1) {
    result = const HarmonyResult(Harmony.accent, 1.0);
  } else if (accents.length == 2) {
    final d = hueDistance(accents[0].hue, accents[1].hue);
    if (d < 15) {
      result = const HarmonyResult(Harmony.monochrome, 0.9);
    } else if (d <= 45) {
      result = const HarmonyResult(Harmony.analogous, 0.85);
    } else if (d >= 150) {
      result = const HarmonyResult(Harmony.complementary, 0.75);
    } else {
      result = const HarmonyResult(Harmony.clash, 0.25);
    }
  } else {
    result = const HarmonyResult(Harmony.clash, 0.15);
  }

  // Two patterned pieces fight each other; keep one pattern per outfit.
  final patterned = patterns.where((p) => p != Pattern.solid).length;
  if (patterned > 1) {
    return HarmonyResult(Harmony.clash, (result.score - 0.4).clamp(0, 1).toDouble());
  }
  return result;
}
