import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../data/models/match.dart';
import '../../data/models/team.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../enums/app_enums.dart';
import '../utils/formatters.dart';
import 'chips.dart';
import 'team_crest.dart';

class MatchCard extends StatelessWidget {
  final CricketMatch match;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return switch (match.status) {
      MatchStatus.live => LiveMatchCard(
          match: match,
          onTap: onTap,
          isFavorite: isFavorite,
          onToggleFavorite: onToggleFavorite,
        ),
      MatchStatus.upcoming => UpcomingMatchCard(
          match: match,
          onTap: onTap,
          isFavorite: isFavorite,
          onToggleFavorite: onToggleFavorite,
        ),
      _ => ResultMatchCard(
          match: match,
          onTap: onTap,
          isFavorite: isFavorite,
          onToggleFavorite: onToggleFavorite,
        ),
    };
  }
}

class _CardFrame extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const _CardFrame({
    required this.child,
    required this.onTap,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              if (onToggleFavorite != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                      color: isFavorite ? AppColors.accent : AppColors.secondary,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Team? _team(String id) {
  if (Get.isRegistered<TeamRepository>()) {
    return Get.find<TeamRepository>().cached(id);
  }
  return null;
}

String _score(CricketMatch match, String teamId) {
  for (final inning in match.innings) {
    if (inning.battingTeamId == teamId) {
      return '${inning.runs}/${inning.wickets} (${inning.oversLabel})';
    }
  }
  return '—';
}

class LiveMatchCard extends StatelessWidget {
  final CricketMatch match;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const LiveMatchCard({
    super.key,
    required this.match,
    required this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final teamA = _team(match.teamAId);
    final teamB = _team(match.teamBId);
    return _CardFrame(
      onTap: onTap,
      isFavorite: isFavorite,
      onToggleFavorite: onToggleFavorite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  match.round,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const StatusChip(status: MatchStatus.live),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TeamCrest(team: teamA, size: 34),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teamA?.shortName ?? match.teamAId,
                        style: Theme.of(context).textTheme.titleSmall),
                    Text(_score(match, match.teamAId),
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              TeamCrest(team: teamB, size: 34),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teamB?.shortName ?? match.teamBId,
                        style: Theme.of(context).textTheme.titleSmall),
                    Text(_score(match, match.teamBId),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.green,
                            )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              match.statusText,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${match.venue}, ${match.city} · Updated ${match.lastUpdatedLabel}',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class UpcomingMatchCard extends StatelessWidget {
  final CricketMatch match;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const UpcomingMatchCard({
    super.key,
    required this.match,
    required this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final teamA = _team(match.teamAId);
    final teamB = _team(match.teamBId);
    return _CardFrame(
      onTap: onTap,
      isFavorite: isFavorite,
      onToggleFavorite: onToggleFavorite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FormatChip(format: match.format),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  match.round,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const StatusChip(status: MatchStatus.upcoming),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TeamCrest(team: teamA, size: 40),
                    const SizedBox(height: AppSpacing.xs),
                    Text(teamA?.shortName ?? match.teamAId,
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Text('VS',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      )),
              Expanded(
                child: Column(
                  children: [
                    TeamCrest(team: teamB, size: 40),
                    const SizedBox(height: AppSpacing.xs),
                    Text(teamB?.shortName ?? match.teamBId,
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppColors.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${AppFormatters.shortDate(match.startTime)}, ${AppFormatters.time(match.startTime)}  ·  ${match.venue}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultMatchCard extends StatelessWidget {
  final CricketMatch match;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const ResultMatchCard({
    super.key,
    required this.match,
    required this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final teamA = _team(match.teamAId);
    final teamB = _team(match.teamBId);
    return _CardFrame(
      onTap: onTap,
      isFavorite: isFavorite,
      onToggleFavorite: onToggleFavorite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FormatChip(format: match.format),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(match.round,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis),
              ),
              const StatusChip(status: MatchStatus.completed),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _resultTeamRow(context, teamA, _score(match, match.teamAId)),
          const SizedBox(height: AppSpacing.sm),
          _resultTeamRow(context, teamB, _score(match, match.teamBId)),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined,
                    size: 15, color: AppColors.darkGreen),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    match.resultText ?? match.statusText,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${AppFormatters.shortDate(match.startTime)} · ${match.venue}',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _resultTeamRow(BuildContext context, Team? team, String score) => Row(
        children: [
          TeamCrest(team: team, size: 32),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(team?.shortName ?? '',
                style: Theme.of(context).textTheme.titleSmall),
          ),
          Text(score,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      );
}

class CompactMatchTile extends StatelessWidget {
  final CricketMatch match;
  final VoidCallback onTap;

  const CompactMatchTile({super.key, required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final teamA = _team(match.teamAId);
    final teamB = _team(match.teamBId);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: SizedBox(
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(teamA?.flag ?? '', style: const TextStyle(fontSize: 18)),
            Text(teamB?.flag ?? '', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
      title: Text(match.title,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${match.round} · ${match.statusText}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: StatusChip(status: match.status, compact: true),
      onTap: onTap,
    );
  }
}
