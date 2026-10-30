import 'package:flutter/material.dart';

import '../app_state.dart';
import '../domain/languages.dart';
import '../l10n/app_localizations.dart';

/// Egyptian, Gulf, Standard Arabic or English. Each name is written the way
/// its speakers write it, so people find their own whatever is on screen.
class LanguagePicker extends StatelessWidget {
  final AppState state;
  final AppLanguage current;

  const LanguagePicker({super.key, required this.state, required this.current});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final labels = {
      AppLanguage.egyptian: t.arabicEgyptian,
      AppLanguage.gulf: t.arabicGulf,
      AppLanguage.standard: t.arabicStandard,
      AppLanguage.english: t.english,
    };
    return SegmentedButton<AppLanguage>(
      key: const Key('language'),
      showSelectedIcon: false,
      segments: [for (final l in AppLanguage.values) ButtonSegment(value: l, label: Text(labels[l]!))],
      selected: {current},
      onSelectionChanged: (s) => state.setProfile(state.profile.copyWith(language: s.first)),
    );
  }
}
