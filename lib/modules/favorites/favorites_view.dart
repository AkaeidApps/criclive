import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/match_cards.dart';
import '../../core/widgets/state_widgets.dart';
import '../../core/widgets/team_crest.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../../data/repositories/local_repositories.dart';
import '../../data/repositories/match_repository.dart';
import 'favorites_controller.dart';

class FavoritesView extends StatelessWidget {
  final bool embedded;

  const FavoritesView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();
    final selected = 0.obs;
    final kinds = FavoriteKind.values;
    final labels = ['Matches', 'Teams', 'Players', 'Series'];

    return AppScaffold(
      title: 'Favorites',
      subtitle: 'Saved locally · no login required',
      automaticallyImplyLeading: !embedded,
      actions: [
        Obx(() => controller.total == 0
            ? const SizedBox.shrink()
            : IconButton(
                tooltip: 'Clear all favorites',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _clearAll(controller),
              )),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(kinds.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: PillChip(
                        label: labels[index],
                        selected: selected.value == index,
                        onTap: () => selected.value = index,
                      ),
                    );
                  }),
                ),
              )),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Obx(() {
              final kind = kinds[selected.value];
              final ids = controller.listFor(kind);
              if (ids.isEmpty) {
                return EmptyView(
                  icon: Icons.star_border_rounded,
                  title: 'No favorites yet',
                  message: 'Tap the star on any match, team, player or series to save it here.',
                  actionLabel: 'Browse matches',
                  onAction: () => Get.toNamed(AppRoutes.live),
                );
              }
              return switch (kind) {
                FavoriteKind.match => _MatchFavorites(ids: ids, controller: controller),
                FavoriteKind.team => _TeamFavorites(ids: ids, controller: controller),
                FavoriteKind.player => _PlayerFavorites(ids: ids, controller: controller),
                FavoriteKind.series => _SeriesFavorites(ids: ids, controller: controller),
              };
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAll(FavoritesController controller) async {
    for (final kind in FavoriteKind.values) {
      for (final id in controller.listFor(kind).toList()) {
        await controller.remove(kind, id);
      }
    }
  }
}

class _MatchFavorites extends StatelessWidget {
  final List<String> ids;
  final FavoritesController controller;

  const _MatchFavorites({required this.ids, required this.controller});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<MatchRepository>();
    final matches = ids
        .map(repository.cachedMatch)
        .where((match) => match != null)
        .toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: matches
          .map((match) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: MatchCard(
                  match: match!,
                  onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                  isFavorite: true,
                  onToggleFavorite: () => controller.toggle(FavoriteKind.match, match.id),
                ),
              ))
          .toList(),
    );
  }
}

class _TeamFavorites extends StatelessWidget {
  final List<String> ids;
  final FavoritesController controller;

  const _TeamFavorites({required this.ids, required this.controller});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<TeamRepository>();
    final teams = ids.map(repository.cached).where((team) => team != null).toList();
    return ListView(
      children: teams.map((team) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            leading: TeamCrest(team: team, size: 38),
            title: Text(team!.name, style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(team.abbreviation),
            trailing: IconButton(
              icon: const Icon(Icons.star, color: Color(0xFFF7D154)),
              onPressed: () => controller.toggle(FavoriteKind.team, team.id),
            ),
            onTap: () => Get.toNamed(AppRoutes.team(team.id)),
          ),
        );
      }).toList(),
    );
  }
}

class _PlayerFavorites extends StatelessWidget {
  final List<String> ids;
  final FavoritesController controller;

  const _PlayerFavorites({required this.ids, required this.controller});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<PlayerRepository>();
    final players = ids.map(repository.cached).where((player) => player != null).toList();
    return ListView(
      children: players.map((player) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            leading: CircleAvatar(child: Text(player!.initials, style: const TextStyle(fontSize: 11))),
            title: Text(player.name, style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(player.role.label),
            trailing: IconButton(
              icon: const Icon(Icons.star, color: Color(0xFFF7D154)),
              onPressed: () => controller.toggle(FavoriteKind.player, player.id),
            ),
            onTap: () => Get.toNamed(AppRoutes.player(player.id)),
          ),
        );
      }).toList(),
    );
  }
}

class _SeriesFavorites extends StatelessWidget {
  final List<String> ids;
  final FavoritesController controller;

  const _SeriesFavorites({required this.ids, required this.controller});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<SeriesRepository>();
    final seriesList = repository
        .cachedAll()
        .where((series) => ids.contains(series.id))
        .toList();
    return ListView(
      children: seriesList.map((series) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            leading: const Icon(Icons.emoji_events, color: Color(0xFFF7D154)),
            title: Text(series.name, style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text('${series.format.label} · ${series.host}'),
            trailing: IconButton(
              icon: const Icon(Icons.star, color: Color(0xFFF7D154)),
              onPressed: () => controller.toggle(FavoriteKind.series, series.id),
            ),
            onTap: () => Get.toNamed(AppRoutes.series(series.id)),
          ),
        );
      }).toList(),
    );
  }
}
