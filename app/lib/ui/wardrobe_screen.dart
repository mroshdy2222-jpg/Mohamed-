import 'package:flutter/material.dart';

import '../app_state.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';
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

  /// One tap marks a piece as in the laundry, lent, or back in the wardrobe.
  Future<void> _status(BuildContext context, Item item) async {
    final t = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<ItemStatus>(
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
          ],
        ),
      ),
    );
    if (picked != null) widget.state.setStatus(item.id, picked);
  }
}
