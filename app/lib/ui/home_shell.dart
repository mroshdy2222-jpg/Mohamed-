import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/weather.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import '../domain/languages.dart';
import 'basics_screen.dart';
import 'language_picker.dart';
import 'labels.dart';
import 'theme.dart';
import 'today_screen.dart';
import 'wardrobe_screen.dart';

class HomeShell extends StatefulWidget {
  final AppState state;
  final AppLanguage language;

  const HomeShell({super.key, required this.state, required this.language});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  bool _addingBasics = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final state = widget.state;

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (!state.onboarded || _addingBasics) {
          return BasicsScreen(
            language: widget.language,
            state: state,
            onDone: () => setState(() {
              _addingBasics = false;
              _tab = 0;
            }),
          );
        }
        final pages = [
          TodayScreen(state: state, onAskFriends: () => setState(() => _tab = 2)),
          WardrobeScreen(state: state, onAddBasics: () => setState(() => _addingBasics = true)),
          const _VoteScreen(),
          _AccountScreen(state: state, language: widget.language),
        ];
        return Scaffold(
          body: SafeArea(child: pages[_tab]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.wb_sunny_outlined),
                selectedIcon: const Icon(Icons.wb_sunny_rounded),
                label: t.navToday,
              ),
              NavigationDestination(
                icon: const Icon(Icons.checkroom_outlined),
                selectedIcon: const Icon(Icons.checkroom_rounded),
                label: t.navWardrobe,
              ),
              NavigationDestination(
                icon: const Icon(Icons.how_to_vote_outlined),
                selectedIcon: const Icon(Icons.how_to_vote_rounded),
                label: t.navVote,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: t.navAccount,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VoteScreen extends StatelessWidget {
  const _VoteScreen();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(Space.s4),
      children: [
        Text(t.voteTitle, style: text.headlineSmall),
        const SizedBox(height: Space.s4),
        Text(t.voteSoon, style: text.bodyLarge),
      ],
    );
  }
}

class _AccountScreen extends StatelessWidget {
  final AppState state;
  final AppLanguage language;

  const _AccountScreen({required this.state, required this.language});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final p = state.profile;
    return ListView(
      padding: const EdgeInsets.all(Space.s4),
      children: [
        Text(t.navAccount, style: text.headlineSmall),
        const SizedBox(height: Space.s6),
        Text(t.languageLabel, style: text.titleMedium),
        const SizedBox(height: Space.s2),
        LanguagePicker(state: state, current: language),
        const SizedBox(height: Space.s6),
        Text(t.cityLabel, style: text.titleMedium),
        const SizedBox(height: Space.s2),
        Wrap(
          spacing: Space.s2,
          runSpacing: Space.s2,
          children: [
            for (final city in cities)
              ChoiceChip(
                label: Text(t.city(city.key)),
                selected: p.city == city.key,
                onSelected: (_) => state.setProfile(p.copyWith(city: city.key)),
              ),
          ],
        ),
        if (p.gender == Gender.female) ...[
          const SizedBox(height: Space.s6),
          Text(t.hijabQuestion, style: text.titleMedium),
          const SizedBox(height: Space.s2),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(t.yes)),
              ButtonSegment(value: false, label: Text(t.no)),
            ],
            selected: {p.wearsHijab},
            onSelectionChanged: (s) => state.setProfile(p.copyWith(wearsHijab: s.first)),
          ),
        ],
      ],
    );
  }
}
