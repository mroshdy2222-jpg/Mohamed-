import 'package:flutter/material.dart';

import '../app_state.dart';
import '../domain/models.dart';
import '../domain/outfit_engine.dart';
import '../l10n/app_localizations.dart';
import 'item_swatch.dart';
import 'labels.dart';
import 'theme.dart';

class TodayScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onAskFriends;

  const TodayScreen({super.key, required this.state, required this.onAskFriends});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    final text = Theme.of(context).textTheme;
    final outfit = state.current;

    return ListView(
      padding: const EdgeInsets.all(Space.s4),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: Text(t.todayTitle, style: text.headlineSmall)),
            Text(t.weatherLine(state.temperatureC, t.city(state.profile.city)), style: text.bodyMedium),
          ],
        ),
        const SizedBox(height: Space.s4),
        DropdownMenu<Occasion>(
          key: const Key('occasion'),
          initialSelection: state.occasion,
          label: Text(t.occasionLabel),
          expandedInsets: EdgeInsets.zero,
          onSelected: (o) => o == null ? null : state.setOccasion(o),
          dropdownMenuEntries: [for (final o in Occasion.values) DropdownMenuEntry(value: o, label: t.occasion(o))],
        ),
        const SizedBox(height: Space.s4),
        Wrap(
          spacing: Space.s2,
          runSpacing: Space.s2,
          children: [
            for (final s in Style.values)
              ChoiceChip(label: Text(t.style(s)), selected: state.style == s, onSelected: (_) => state.setStyle(s)),
          ],
        ),
        const SizedBox(height: Space.s6),
        Container(
          padding: const EdgeInsets.all(Space.s4),
          decoration: BoxDecoration(color: c.surfaceRaised, borderRadius: BorderRadius.circular(Radii.md)),
          child: outfit == null ? _Empty(t: t) : _OutfitBody(state: state, outfit: outfit, onAskFriends: onAskFriends),
        ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  final AppLocalizations t;

  const _Empty({required this.t});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.noOutfit, style: text.titleMedium),
        const SizedBox(height: Space.s2),
        Text(t.noOutfitHint, style: text.bodyLarge),
      ],
    );
  }
}

class _OutfitBody extends StatelessWidget {
  final AppState state;
  final Outfit outfit;
  final VoidCallback onAskFriends;

  const _OutfitBody({required this.state, required this.outfit, required this.onAskFriends});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final note = state.temperatureC >= hotFromC
        ? t.noteHot
        : outfit.items.any((i) => i.category == Category.outerwear) && state.temperatureC < coldBelowC
        ? t.noteCold
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, box) {
            final perRow = outfit.items.length <= 4 ? 4 : 5;
            final w = (box.maxWidth - Space.s2 * (perRow - 1)) / perRow;
            return Wrap(
              spacing: Space.s2,
              runSpacing: Space.s2,
              children: [
                for (final i in outfit.items)
                  SizedBox(
                    width: w,
                    height: w * 4 / 3,
                    child: ItemSwatch(
                      item: i,
                      locked: state.lockedItemId == i.id,
                      semanticLabel: t.itemName(i),
                      onTap: () => state.toggleLock(i.id),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: Space.s2),
        Text(t.lockHint, style: text.bodyMedium),
        const SizedBox(height: Space.s4),
        Text(
          note == null ? t.reason(outfit.harmony.harmony) : '${t.reason(outfit.harmony.harmony)} $note',
          style: text.bodyLarge,
        ),
        const SizedBox(height: Space.s4),
        Wrap(
          spacing: Space.s2,
          runSpacing: Space.s2,
          children: [
            FilledButton(onPressed: () => _wear(context), child: Text(t.wearIt)),
            OutlinedButton(onPressed: state.dressMeAgain, child: Text(t.dressMeAgain)),
            TextButton(onPressed: onAskFriends, child: Text(t.askFriends)),
          ],
        ),
      ],
    );
  }

  Future<void> _wear(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _WearSheet(state: state),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.wornSaved)));
    }
  }
}

/// Asks who the user is with, and warns live if they already wore a
/// memorable piece of this outfit with the same people.
class _WearSheet extends StatefulWidget {
  final AppState state;

  const _WearSheet({required this.state});

  @override
  State<_WearSheet> createState() => _WearSheetState();
}

class _WearSheetState extends State<_WearSheet> {
  final _who = TextEditingController();
  WearEntry? _before;

  @override
  void dispose() {
    _who.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    final text = Theme.of(context).textTheme;
    final date = _before == null ? null : MaterialLocalizations.of(context).formatMediumDate(_before!.date);

    return Padding(
      padding: EdgeInsets.fromLTRB(Space.s4, Space.s6, Space.s4, Space.s4 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.withWhomTitle, style: text.titleMedium),
          const SizedBox(height: Space.s4),
          TextField(
            key: const Key('withWhom'),
            controller: _who,
            autofocus: true,
            decoration: InputDecoration(hintText: t.withWhomHint, border: const OutlineInputBorder()),
            onChanged: (v) => setState(() => _before = widget.state.checkWornBefore(v)),
          ),
          if (date != null) ...[
            const SizedBox(height: Space.s2),
            Text(t.wornBefore(date), style: text.bodyLarge!.copyWith(color: c.rose)),
          ],
          const SizedBox(height: Space.s4),
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  widget.state.wearCurrent(withWhom: _who.text);
                  Navigator.pop(context, true);
                },
                child: Text(t.save),
              ),
              const SizedBox(width: Space.s2),
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
            ],
          ),
        ],
      ),
    );
  }
}
