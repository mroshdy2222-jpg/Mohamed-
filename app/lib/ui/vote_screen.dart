import 'package:flutter/material.dart';

import '../app_state.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import 'labels.dart';
import 'poll_card.dart';
import 'share_image.dart';
import 'theme.dart';

/// "This or that?" without a server: the poll is shared as one image and
/// friends answer in the chat. The WhatsApp voting link will build on this.
/// The store link added under the poll so friends can get the app. Empty
/// until the app is on Google Play; set at build time with
/// --dart-define=TALLA_LINK=<link>.
String inviteLink = const String.fromEnvironment('TALLA_LINK');

class VoteScreen extends StatefulWidget {
  final AppState state;

  /// Called after the user picks a winning outfit, to show it on Today.
  final VoidCallback onChosen;

  const VoteScreen({super.key, required this.state, required this.onChosen});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final _card = GlobalKey();
  bool _sharing = false;
  bool _tooFew = false;

  Future<void> _send() async {
    final t = AppLocalizations.of(context);
    setState(() => _sharing = true);
    try {
      final ask = t.shareText(t.occasion(widget.state.occasion));
      await shareImage(_card, inviteLink.isEmpty ? ask : '$ask\n${t.tryTalla(inviteLink)}');
      widget.state.sendPoll();
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final state = widget.state;
    final draft = state.pollDraft;

    return ListView(
      padding: const EdgeInsets.all(Space.s4),
      children: [
        Text(t.voteTitle, style: text.headlineSmall),
        const SizedBox(height: Space.s1),
        Text(t.pollIntro, style: text.bodyMedium),
        const SizedBox(height: Space.s4),
        if (draft == null) ...[
          FilledButton.icon(
            key: const Key('newPoll'),
            onPressed: () => setState(() => _tooFew = !state.startPollDraft()),
            icon: const Icon(Icons.add_rounded),
            label: Text(t.newPoll),
          ),
          if (_tooFew) ...[const SizedBox(height: Space.s2), Text(t.pollNeedsMore, style: text.bodyLarge)],
        ] else ...[
          RepaintBoundary(
            key: _card,
            child: PollCard(occasion: state.occasion, style: state.style, options: [for (final o in draft) o.items]),
          ),
          const SizedBox(height: Space.s4),
          Wrap(
            spacing: Space.s2,
            runSpacing: Space.s2,
            children: [
              FilledButton.icon(
                key: const Key('sendPoll'),
                onPressed: _sharing ? null : _send,
                icon: const Icon(Icons.send_rounded),
                label: Text(t.sendPoll),
              ),
              OutlinedButton(onPressed: state.swapPollOption, child: Text(t.swapOption)),
              TextButton(onPressed: state.cancelPollDraft, child: Text(t.cancel)),
            ],
          ),
        ],
        const SizedBox(height: Space.s8),
        Text(t.pollsHistory, style: text.titleMedium),
        const SizedBox(height: Space.s2),
        if (state.polls.isEmpty) Text(t.noPolls, style: text.bodyMedium),
        for (final p in state.polls) ...[
          _PastPoll(state: state, poll: p, onChosen: widget.onChosen),
          const SizedBox(height: Space.s4),
        ],
      ],
    );
  }
}

class _PastPoll extends StatelessWidget {
  final AppState state;
  final Poll poll;
  final VoidCallback onChosen;

  const _PastPoll({required this.state, required this.poll, required this.onChosen});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final date = MaterialLocalizations.of(context).formatMediumDate(poll.created);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: text.bodyMedium),
        const SizedBox(height: Space.s1),
        PollCard(
          occasion: poll.occasion,
          style: poll.style,
          options: [for (final o in poll.options) state.itemsOf(o)],
          winner: poll.winner,
        ),
        const SizedBox(height: Space.s2),
        if (poll.winner == null)
          Wrap(
            spacing: Space.s2,
            runSpacing: Space.s2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(t.whoWon, style: text.labelLarge),
              for (var i = 0; i < poll.options.length; i++)
                OutlinedButton(onPressed: () => state.setPollWinner(poll.id, i), child: Text(t.optionLabel(i + 1))),
            ],
          )
        else
          FilledButton(
            onPressed: () {
              state.useOutfit(poll, poll.winner!);
              onChosen();
            },
            child: Text('${t.wearIt} · ${t.optionLabel(poll.winner! + 1)}'),
          ),
      ],
    );
  }
}
