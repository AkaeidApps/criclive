import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/enums/app_enums.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/data_table_widgets.dart';
import '../../../core/widgets/team_crest.dart';
import '../../../data/models/ball_event.dart';
import '../../../data/models/innings.dart';
import '../../../data/models/match.dart';
import '../../../data/models/team.dart';
import '../../../data/repositories/cricket_repositories.dart';

String _playerName(String id) {
  if (Get.isRegistered<PlayerRepository>()) {
    return Get.find<PlayerRepository>().cached(id)?.name ?? id;
  }
  return id;
}

Team? _team(String id) {
  if (Get.isRegistered<TeamRepository>()) {
    return Get.find<TeamRepository>().cached(id);
  }
  return null;
}

class ScoreboardCard extends StatelessWidget {
  final CricketMatch match;
  final int selectedInningsIndex;
  final ValueChanged<int> onInningsChanged;

  const ScoreboardCard({
    super.key,
    required this.match,
    required this.selectedInningsIndex,
    required this.onInningsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final inningA = match.innings.isEmpty ? null : match.innings[0];
    final inningB = match.innings.length > 1 ? match.innings[1] : null;
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusChip(status: match.status),
                const SizedBox(width: AppSpacing.sm),
                Text(match.round,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _TeamScoreRow(
              teamId: match.teamAId,
              score: inningA == null
                  ? '—'
                  : '${inningA.runs}/${inningA.wickets} (${inningA.oversLabel})',
              highlight: selectedInningsIndex == 0,
            ),
            const SizedBox(height: AppSpacing.md),
            _TeamScoreRow(
              teamId: match.teamBId,
              score: inningB == null
                  ? '—'
                  : '${inningB.runs}/${inningB.wickets} (${inningB.oversLabel})',
              highlight: selectedInningsIndex == 1,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: match.status.isLive ? AppColors.softGreen : AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    match.status.isLive
                        ? Icons.bolt
                        : match.status.isCompleted
                            ? Icons.emoji_events_outlined
                            : Icons.schedule,
                    size: 15,
                    color: AppColors.darkGreen,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      match.statusText,
                      style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGreen),
                    ),
                  ),
                ],
              ),
            ),
            if (match.innings.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              InningsSelector(
                innings: match.innings,
                selected: selectedInningsIndex,
                onChanged: onInningsChanged,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TeamScoreRow extends StatelessWidget {
  final String teamId;
  final String score;
  final bool highlight;

  const _TeamScoreRow({
    required this.teamId,
    required this.score,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final team = _team(teamId);
    return Row(
      children: [
        TeamCrest(team: team, size: 38),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(team?.shortName ?? teamId,
                  style: Theme.of(context).textTheme.titleMedium),
              Text(team?.abbreviation ?? '',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text(
          score,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: highlight ? AppColors.green : AppColors.text,
              ),
        ),
      ],
    );
  }
}

class InningsSelector extends StatelessWidget {
  final List<Innings> innings;
  final int selected;
  final ValueChanged<int> onChanged;

  const InningsSelector({
    super.key,
    required this.innings,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: innings.map((inning) {
            final team = _team(inning.battingTeamId);
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text('${team?.abbreviation ?? inning.battingTeamId} · ${inning.number}${_ordinal(inning.number)} innings'),
                selected: innings.indexOf(inning) == selected,
                onSelected: (_) => onChanged(innings.indexOf(inning)),
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
      );

  String _ordinal(int number) => AppFormatters.ordinal(number);
}

class MetricsRow extends StatelessWidget {
  final String crr;
  final String? rrr;
  final String? target;
  final String? partnership;

  const MetricsRow({
    super.key,
    required this.crr,
    this.rrr,
    this.target,
    this.partnership,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          MetricTile(label: 'CRR', value: crr),
          const SizedBox(width: AppSpacing.sm),
          MetricTile(label: 'RRR', value: rrr ?? '—'),
          const SizedBox(width: AppSpacing.sm),
          MetricTile(label: 'TARGET', value: target ?? '—'),
          const SizedBox(width: AppSpacing.sm),
          MetricTile(label: 'PARTNERSHIP', value: partnership ?? '—'),
        ],
      );
}

class BattingCard extends StatelessWidget {
  final Innings innings;

  const BattingCard({super.key, required this.innings});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Batting',
                      style: Theme.of(context).textTheme.titleSmall),
                  const Spacer(),
                  Text('${innings.runs}/${innings.wickets} · ${innings.oversLabel} ov',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ScoreTable(
                headers: const ['BATTER', 'R', 'B', '4s', '6s', 'SR'],
                flex: const [9, 2, 2, 2, 2, 3],
                emphasizedRows: {
                  innings.batting.indexWhere((figure) => figure.onStrike)
                },
                rows: innings.batting.map((figure) {
                  return [
                    '${_playerName(figure.playerId)}${figure.notOut ? ' *' : ''}',
                    '${figure.runs}',
                    '${figure.balls}',
                    '${figure.fours}',
                    '${figure.sixes}',
                    figure.strikeRateLabel,
                  ];
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Extras: ${innings.extras.total} (${innings.extras.detail})',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
}

class BowlingCard extends StatelessWidget {
  final Innings innings;

  const BowlingCard({super.key, required this.innings});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bowling', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.md),
              ScoreTable(
                headers: const ['BOWLER', 'O', 'M', 'R', 'W', 'ECO'],
                flex: const [9, 2, 2, 2, 2, 3],
                emphasizedRows: {
                  innings.bowling.indexWhere((figure) => figure.bowling)
                },
                rows: innings.bowling.map((figure) {
                  return [
                    _playerName(figure.playerId),
                    figure.oversLabel,
                    '${figure.maidens}',
                    '${figure.runs}',
                    '${figure.wickets}',
                    figure.economyLabel,
                  ];
                }).toList(),
              ),
            ],
          ),
        ),
      );
}

class FallOfWicketsCard extends StatelessWidget {
  final Innings innings;

  const FallOfWicketsCard({super.key, required this.innings});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fall of wickets', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              ...innings.fallOfWickets.map(
                (fow) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text('${fow.wicket}-${fow.score}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          '${_playerName(fow.playerId)} · ${fow.over} ov',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (innings.partnerships.isNotEmpty) ...[
                const Divider(height: AppSpacing.xl),
                Text('Partnerships', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                ...innings.partnerships.map(
                  (partnership) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      '${_playerName(partnership.playerAId)} / ${_playerName(partnership.playerBId)} · ${partnership.runs} runs (${partnership.balls} balls)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}

class BallChip extends StatelessWidget {
  final BallEvent ball;
  final bool selected;
  final VoidCallback? onTap;

  const BallChip({
    super.key,
    required this.ball,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = ball.isWicket
        ? AppColors.live
        : ball.isBoundary
            ? AppColors.green
            : ball.isDot
                ? AppColors.secondary
                : AppColors.darkGreen;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : color.withValues(alpha: 0.11),
          border: selected ? null : Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          ball.shortLabel,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}

class CommentaryTile extends StatelessWidget {
  final BallEvent ball;
  final bool showOverHeader;
  final VoidCallback? onPlayerTap;

  const CommentaryTile({
    super.key,
    required this.ball,
    this.showOverHeader = false,
    this.onPlayerTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BallChip(ball: ball),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showOverHeader)
                    Text(
                      'Over ${ball.over + 1}',
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  InkWell(
                    onTap: onPlayerTap,
                    child: Text(
                      '${_playerName(ball.batterId)} → ${_playerName(ball.bowlerId)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.green,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(ball.commentary,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${ball.totalAfterBall}/${ball.wicketsAfterBall}',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
}

class OverSummaryCard extends StatelessWidget {
  final OverSummary over;

  const OverSummaryCard({super.key, required this.over});

  @override
  Widget build(BuildContext context) {
    final overValue = over;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Over ${overValue.number + 1}',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                Text(
                    '${overValue.runs} run${overValue.runs == 1 ? '' : 's'} · ${overValue.wickets} wicket${overValue.wickets == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: overValue.balls
                  .map((ball) => BallChip(ball: ball))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

void openPlayerProfile(String playerId) {
  Get.toNamed(AppRoutes.player(playerId));
}
