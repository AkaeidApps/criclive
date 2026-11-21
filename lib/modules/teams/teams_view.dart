import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/match_cards.dart';
import '../../core/widgets/responsive.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/state_widgets.dart';
import '../../core/widgets/team_crest.dart';
import '../../data/models/player.dart';
import '../../data/repositories/local_repositories.dart';
import '../favorites/favorites_controller.dart';
import 'teams_controller.dart';

class TeamsView extends StatelessWidget {
  final String? teamId;

  const TeamsView({super.key, this.teamId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => TeamsController(teamId: teamId),
      tag: teamId ?? 'teams-hub',
    );
    final favorites = Get.find<FavoritesController>();
    return AppScaffold(
      title: teamId == null ? 'Teams' : 'Team Profile',
      subtitle: teamId == null ? 'Demo team catalogue' : null,
      actions: teamId == null
          ? null
          : [
              Obx(() => IconButton(
                    tooltip: favorites.isFavorite(FavoriteKind.team, teamId!)
                        ? 'Remove favorite'
                        : 'Add favorite',
                    icon: Icon(
                      favorites.isFavorite(FavoriteKind.team, teamId!)
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: favorites.isFavorite(FavoriteKind.team, teamId!)
                          ? const Color(0xFFF7D154)
                          : null,
                    ),
                    onPressed: () =>
                        favorites.toggle(FavoriteKind.team, teamId!),
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
        return teamId == null
            ? _TeamsHub(controller: controller)
            : _TeamDetail(controller: controller);
      }),
    );
  }
}

class _TeamsHub extends StatelessWidget {
  final TeamsController controller;

  const _TeamsHub({required this.controller});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['International', 'Domestic', 'All'].map((group) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: PillChip(
                        label: group,
                        selected: controller.selectedGroup.value == group,
                        onTap: () => controller.selectedGroup.value = group,
                      ),
                    );
                  }).toList(),
                ),
              )),
          const SizedBox(height: AppSpacing.md),
          Obx(() => ResponsiveGrid(
                mobile: 2,
                tablet: 3,
                desktop: 4,
                children: controller.filteredTeams.map((team) {
                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      onTap: () => Get.toNamed(AppRoutes.team(team.id)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
                        child: Column(
                          children: [
                            TeamCrest(team: team, size: 42),
                            const SizedBox(height: AppSpacing.sm),
                            Text(team.shortName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall),
                            Text(team.abbreviation,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ],
      );
}

class _TeamDetail extends StatelessWidget {
  final TeamsController controller;

  const _TeamDetail({required this.controller});

  @override
  Widget build(BuildContext context) {
    final team = controller.team.value;
    if (team == null) {
      return const EmptyView(
        icon: Icons.groups_outlined,
        title: 'Team not found',
        message: 'Select a team from the team list.',
      );
    }
    final grouped = <PlayerRole, List<Player>>{};
    for (final player in controller.squad) {
      grouped.putIfAbsent(player.role, () => []).add(player);
    }
    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Row(
                children: [
                  TeamCrest(team: team, size: 56),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(team.name,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('${team.abbreviation} · ${team.city}',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          team.international ? 'International side' : 'Domestic franchise',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(icon: Icons.groups_outlined, title: 'Squad'),
          if (controller.squad.isEmpty)
            const EmptyView(
              icon: Icons.person_off_outlined,
              title: 'Squad not available',
              message: 'Demo squad data is not linked to this team.',
            )
          else
            ...grouped.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Card(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key.label,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        ...entry.value.map(
                          (player) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: team.color.withValues(alpha: 0.14),
                              child: Text(player.initials,
                                  style: TextStyle(
                                      fontSize: 11, color: team.color)),
                            ),
                            title: Text(player.name,
                                style: Theme.of(context).textTheme.titleSmall),
                            subtitle: Text('${player.battingStyle} · ${player.bowlingStyle}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Get.toNamed(AppRoutes.player(player.id)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SectionHeader(icon: Icons.sports_cricket_outlined, title: 'Recent & upcoming'),
          if (controller.matches.isEmpty)
            const EmptyView(
              icon: Icons.sports_cricket_outlined,
              title: 'No matches',
              message: 'No demo fixtures involve this team.',
            )
          else
            ...controller.matches.map(
              (match) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: CompactMatchTile(
                  match: match,
                  onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
