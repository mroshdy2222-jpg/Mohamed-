import 'package:flutter/material.dart';

import '../app_state.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import 'add_item_screen.dart';
import 'item_swatch.dart';
import 'labels.dart';
import 'theme.dart';

class WardrobeScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onAddBasics;

  const WardrobeScreen({super.key, required this.state, required this.onAddBasics});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  Category? _filter;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    final text = Theme.of(context).textTheme;
    final items = widget.state.items.where((i) => _filter == null || i.category == _filter).toList();
    final present = widget.state.items.map((i) => i.category).toSet();

    return ListView(
      padding: const EdgeInsets.all(Space.s4),
      children: [
        Row(
          children: [
            Expanded(child: Text(t.wardrobeTitle, style: text.headlineSmall)),
            Text(t.wardrobeCount(widget.state.items.length), style: text.bodyMedium),
          ],
        ),
        const SizedBox(height: Space.s4),
        FilledButton.icon(
          key: const Key('addItem'),
          onPressed: () => _add(context),
          icon: const Icon(Icons.add_a_photo_outlined),
          label: Text(t.addItem),
        ),
        if (widget.state.items.isNotEmpty) ...[const SizedBox(height: Space.s4), _MissingCard(state: widget.state)],
        const SizedBox(height: Space.s4),
        Wrap(
          spacing: Space.s2,
          runSpacing: Space.s2,
          children: [
            ChoiceChip(
              label: Text(t.filterAll),
              selected: _filter == null,
              onSelected: (_) => setState(() => _filter = null),
            ),
            for (final cat in Category.values.where(present.contains))
              ChoiceChip(
                label: Text(t.category(cat)),
                selected: _filter == cat,
                onSelected: (_) => setState(() => _filter = cat),
              ),
          ],
        ),
        const SizedBox(height: Space.s4),
        if (widget.state.items.isEmpty) ...[
          Text(t.emptyWardrobe, style: text.bodyLarge),
          const SizedBox(height: Space.s4),
          FilledButton(onPressed: widget.onAddBasics, child: Text(t.addBasics)),
        ],
        GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: Space.s2,
          crossAxisSpacing: Space.s2,
          childAspectRatio: 3 / 4.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final i in items)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: i.status == ItemStatus.available ? 1 : 0.45,
                      child: ItemSwatch(
                        onPage: true,
                        item: i,
                        semanticLabel: t.itemName(i),
                        onTap: () => _status(context, i),
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.s1),
                  Text(
                    i.status == ItemStatus.available
                        ? t.color(i.color)
                        : i.status == ItemStatus.laundry
                        ? t.statusLaundry
                        : t.statusLent,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium!.copyWith(color: i.status == ItemStatus.available ? c.inkMuted : c.rose),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddItemScreen(state: widget.state)),
    );
    if (added == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.itemAdded)));
    }
  }

  /// One tap marks a piece as in the laundry, lent, back in the wardrobe, or
  /// removes it. Null means the user closed the sheet.
  Future<void> _status(BuildContext context, Item item) async {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    final picked = await showModalBottomSheet<Object>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(t.itemName(item), style: Theme.of(context).textTheme.titleMedium)),
            for (final (s, label) in [
              (ItemStatus.available, t.statusAvailable),
              (ItemStatus.laundry, t.statusLaundry),
              (ItemStatus.lent, t.statusLent),
            ])
              ListTile(
                title: Text(label),
                trailing: item.status == s ? const Icon(Icons.check_rounded) : null,
                onTap: () => Navigator.pop(context, s),
              ),
            ListTile(
              title: Text(t.deleteItem, style: TextStyle(color: c.rose)),
              leading: Icon(Icons.delete_outline_rounded, color: c.rose),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (picked is ItemStatus) widget.state.setStatus(item.id, picked);
    if (picked == 'delete') widget.state.removeItem(item.id);
  }
}

/// The one piece that would add the most outfits. Affiliate offers for it
/// will sit under the same card once the partner programmes are set up.
class _MissingCard extends StatelessWidget {
  final AppState state;

  const _MissingCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    final text = Theme.of(context).textTheme;
    final top = state.missing.isEmpty ? null : state.missing.first;

    return Container(
      padding: const EdgeInsets.all(Space.s4),
      decoration: BoxDecoration(color: c.surfaceRaised, borderRadius: BorderRadius.circular(Radii.md)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (top != null) ...[
            SizedBox(
              width: 64,
              height: 84,
              child: ItemSwatch(item: top.item, semanticLabel: t.itemName(top.item)),
            ),
            const SizedBox(width: Space.s4),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.missingTitle, style: text.titleMedium),
                const SizedBox(height: Space.s1),
                Text(
                  top == null ? t.missingNone : t.missingGain(t.itemName(top.item), top.gain, t.style(state.style)),
                  style: text.bodyLarge,
                ),
                if (top != null) ...[
                  const SizedBox(height: Space.s2),
                  OutlinedButton(
                    key: const Key('iHaveIt'),
                    onPressed: () => state.addItems([top.item]),
                    child: Text(t.iHaveIt),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
