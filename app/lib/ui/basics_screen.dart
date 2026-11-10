import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/basics.dart';
import '../domain/languages.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import 'item_swatch.dart';
import 'labels.dart';
import 'language_picker.dart';
import 'theme.dart';

/// Onboarding: three quick questions, then the basics grid. The user sees a
/// first outfit without photographing anything.
class BasicsScreen extends StatefulWidget {
  final AppState state;
  final AppLanguage language;
  final VoidCallback onDone;

  const BasicsScreen({super.key, required this.state, required this.language, required this.onDone});

  @override
  State<BasicsScreen> createState() => _BasicsScreenState();
}

class _BasicsScreenState extends State<BasicsScreen> {
  final Set<String> _picked = {};

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final profile = widget.state.profile;
    final list = basicsFor(profile.gender);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.s4),
          children: [
            LanguagePicker(state: widget.state, current: widget.language),
            const SizedBox(height: Space.s6),
            Text(t.genderQuestion, style: text.titleMedium),
            const SizedBox(height: Space.s2),
            SegmentedButton<Gender>(
              segments: [
                ButtonSegment(value: Gender.female, label: Text(t.genderFemale)),
                ButtonSegment(value: Gender.male, label: Text(t.genderMale)),
              ],
              selected: {profile.gender},
              onSelectionChanged: (s) => setState(() {
                _picked.clear();
                widget.state.setProfile(
                  profile.copyWith(gender: s.first, wearsHijab: s.first == Gender.male ? false : profile.wearsHijab),
                );
              }),
            ),
            if (profile.gender == Gender.female) ...[
              const SizedBox(height: Space.s4),
              Text(t.hijabQuestion, style: text.titleMedium),
              const SizedBox(height: Space.s2),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: true, label: Text(t.yes)),
                  ButtonSegment(value: false, label: Text(t.no)),
                ],
                selected: {profile.wearsHijab},
                onSelectionChanged: (s) =>
                    setState(() => widget.state.setProfile(profile.copyWith(wearsHijab: s.first))),
              ),
            ],
            const SizedBox(height: Space.s6),
            Text(t.basicsTitle, style: text.headlineSmall),
            const SizedBox(height: Space.s1),
            Text(t.basicsHint, style: text.bodyMedium),
            const SizedBox(height: Space.s4),
            GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: Space.s4,
              crossAxisSpacing: Space.s2,
              childAspectRatio: 0.56,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final b in list)
                  Column(
                    children: [
                      Expanded(
                        child: ItemSwatch(
                          onPage: true,
                          key: Key(b.item.id),
                          item: b.item,
                          selected: _picked.contains(b.item.id),
                          semanticLabel: t.basicName(b),
                          onTap: () => setState(
                            () => _picked.contains(b.item.id) ? _picked.remove(b.item.id) : _picked.add(b.item.id),
                          ),
                        ),
                      ),
                      const SizedBox(height: Space.s1),
                      // Two lines' room for every name, so all the tiles stay the same size.
                      SizedBox(
                        height: 34,
                        child: ExcludeSemantics(
                          child: Text(
                            t.basicName(b),
                            style: text.bodySmall,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.s4),
          child: FilledButton(
            key: const Key('basicsDone'),
            onPressed: _picked.isEmpty
                ? null
                : () {
                    widget.state.addItems(list.where((b) => _picked.contains(b.item.id)).map((b) => b.item));
                    widget.onDone();
                  },
            child: Text(_picked.isEmpty ? t.basicsDone : '${t.basicsDone} · ${t.basicsSelected(_picked.length)}'),
          ),
        ),
      ),
    );
  }
}
