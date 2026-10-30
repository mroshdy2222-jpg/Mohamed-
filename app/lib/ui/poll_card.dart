import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import 'item_swatch.dart';
import 'labels.dart';
import 'theme.dart';

/// The "this or that?" card. It is also the image friends receive, so it
/// carries everything they need: the occasion, two numbered outfits and how
/// to answer.
class PollCard extends StatelessWidget {
  final Occasion occasion;
  final Style style;
  final List<List<Item>> options;
  final int? winner;

  const PollCard({super.key, required this.occasion, required this.style, required this.options, this.winner});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(Space.s4),
      decoration: BoxDecoration(color: c.surfaceRaised, borderRadius: BorderRadius.circular(Radii.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t.voteTitle, style: text.titleMedium),
          Text('${t.occasion(occasion)} · ${t.style(style)}', style: text.bodyMedium),
          const SizedBox(height: Space.s4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const SizedBox(width: Space.s2),
                Expanded(
                  child: _Option(number: i + 1, items: options[i], won: winner == i),
                ),
              ],
            ],
          ),
          const SizedBox(height: Space.s4),
          Row(
            children: [
              Text(
                t.appTitle,
                style: TextStyle(fontFamily: displayFont, fontWeight: FontWeight.w700, fontSize: 18, color: c.nile),
              ),
              const Spacer(),
              Text(t.replyWithNumber, style: text.labelLarge),
            ],
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final int number;
  final List<Item> items;
  final bool won;

  const _Option({required this.number, required this.items, required this.won});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = TallaColors.of(context);
    return Container(
      padding: const EdgeInsets.all(Space.s2),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: won ? Border.all(color: c.saffron, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: won ? c.saffron : c.nile, shape: BoxShape.circle),
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontFamily: displayFont,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: won ? const Color(0xFF15201F) : c.onNile,
                  ),
                ),
              ),
              if (won) ...[
                const SizedBox(width: Space.s2),
                Text(t.winnerLabel, style: Theme.of(context).textTheme.labelLarge),
              ],
            ],
          ),
          const SizedBox(height: Space.s2),
          LayoutBuilder(
            builder: (context, box) {
              final w = (box.maxWidth - Space.s1) / 2;
              return Wrap(
                spacing: Space.s1,
                runSpacing: Space.s1,
                children: [
                  for (final i in items)
                    SizedBox(
                      width: w,
                      height: w * 4 / 3,
                      child: ItemSwatch(item: i, onPage: true, semanticLabel: t.itemName(i)),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
