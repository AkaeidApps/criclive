import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/data_table_widgets.dart';
import '../../core/widgets/responsive.dart';
import '../../core/widgets/state_widgets.dart';
import '../../core/widgets/team_crest.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../../data/repositories/local_repositories.dart';
import '../favorites/favorites_controller.dart';
import 'players_controller.dart';

class PlayersView extends StatelessWidget {
  final String? playerId;

  const PlayersView({super.key, this.playerId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => PlayersController(playerId: playerId),
      tag: playerId ?? 'players-hub',
    );
    final favorites = Get.find<FavoritesController>();
    return AppScaffold(
      title: playerId == null ? 'Players' : 'Player Profile',
      subtitle: playerId == null ? 'Demo player directory' : null,
      actions: playerId == null
          ? null
          : [
              Obx(() => IconButton(
                    tooltip: favorites.isFavorite(FavoriteKind.player, playerId!)
                        ? 'Remove favorite'
                        : 'Add favorite',
                    icon: Icon(
                      favorites.isFavorite(FavoriteKind.player, playerId!)
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: favorites.isFavorite(FavoriteKind.player, playerId!)
                          ? const Color(0xFFF7D154)
                          : null,
                    ),
                    onPressed: () =>
                        favorites.toggle(FavoriteKind.player, playerId!),
                  )),
            ],
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.state.value.hasError) {
          return ErrorView(
              message: controller.errorMessage.value, onRetry: controller.load);
        }
        return playerId == null
            ? _PlayersHub(controller: controller)
            : _PlayerDetail(controller: controller);
      }),
    );
  }
}

class _PlayersHub extends StatelessWidget {
  final PlayersController controller;

  const _PlayersHub({required this.controller});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: PlayersController.filters.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: PillChip(
                        label: filter,
                        selected: controller.filter.value == filter,
                        onTap: () => controller.filter.value = filter,
                      ),
                    );
                  }).toList(),
                ),
              )),
          const SizedBox(height: AppSpacing.md),
          Obx(() => ResponsiveGrid(
                mobile: 1,
                tablet: 2,
                desktop: 3,
                children: controller.filtered.map((player) {
                  final team = Get.find<TeamRepository>().cached(player.teamId);
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: TeamCrest(team: team, size: 38),
                      title: Text(player.name,
                          style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text('${player.role.label} · ${team?.abbreviation ?? ''}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.toNamed(AppRoutes.player(player.id)),
                    ),
                  );
                }).toList(),
              )),
        ],
      );
}

class _PlayerDetail extends StatelessWidget {
  final PlayersController controller;

  const _PlayerDetail({required this.controller});

  @override
  Widget build(BuildContext context) {
    final player = controller.player.value;
    if (player == null) {
      return const EmptyView(
        icon: Icons.person_off_outlined,
        title: 'Player not found',
        message: 'Select a player from the directory.',
      );
    }
    final team = Get.find<TeamRepository>().cached(player.teamId);
    final batting = player.batting(controller.selectedFormat.value);
    final bowling = player.bowling(controller.selectedFormat.value);
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: (team?.color ?? AppColors.green).withValues(alpha: 0.15),
                  child: Text(player.initials,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: team?.color ?? AppColors.green)),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(player.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 3),
                      Text(player.role.label,
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(team?.name ?? player.teamId,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                InfoRow(label: 'Batting style', value: player.battingStyle),
                InfoRow(label: 'Bowling style', value: player.bowlingStyle),
                InfoRow(label: 'Age', value: '${player.age} years'),
                const SizedBox(height: AppSpacing.sm),
                Text(player.bio, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: ['T20I', 'ODI'].map((format) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: PillChip(
                label: format,
                selected: controller.selectedFormat.value == format,
                onTap: () => controller.selectedFormat.value = format,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${controller.selectedFormat.value} batting',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                if (batting == null)
                  Text('No batting data available for this format.',
                      style: Theme.of(context).textTheme.bodySmall)
                else
                  ScoreTable(
                    minWidth: 430,
                    headers: const ['M', 'INN', 'RUNS', 'HS', 'AVG', 'SR', '100s', '50s'],
                    flex: const [1, 1, 2, 1, 2, 2, 1, 1],
                    rows: [
                      [
                        '${batting.matches}',
                        '${batting.innings}',
                        '${batting.runs}',
                        batting.highestScoreLabel,
                        batting.average.toStringAsFixed(2),
                        batting.strikeRate.toStringAsFixed(2),
                        '${batting.hundreds}',
                        '${batting.fifties}',
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${controller.selectedFormat.value} bowling',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                if (bowling == null)
                  Text('No bowling data available for this format.',
                      style: Theme.of(context).textTheme.bodySmall)
                else
                  ScoreTable(
                    minWidth: 430,
                    headers: const ['M', 'WKT', 'RUNS', 'AVG', 'ECO', 'BEST', '5WI'],
                    flex: const [1, 1, 2, 2, 2, 2, 1],
                    rows: [
                      [
                        '${bowling.matches}',
                        '${bowling.wickets}',
                        '${bowling.runsConceded}',
                        bowling.average.toStringAsFixed(2),
                        bowling.economy.toStringAsFixed(2),
                        bowling.bestFiguresLabel,
                        '${bowling.fiveWicketHauls}',
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (player.recentScores.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent form (demo)',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: player.recentScores
                        .map((score) => Chip(label: Text(score)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
