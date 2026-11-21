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
import '../../data/models/series.dart';
import '../../data/repositories/local_repositories.dart';
import '../favorites/favorites_controller.dart';
import '../points_table/points_table_widget.dart';
import 'series_controller.dart';

class SeriesView extends StatelessWidget {
  final String? seriesId;

  const SeriesView({super.key, this.seriesId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => SeriesController(seriesId: seriesId),
      tag: seriesId ?? 'hub',
    );
    final isDetail = seriesId != null;
    final favorites = Get.find<FavoritesController>();
    return AppScaffold(
      title: isDetail ? 'Series Details' : 'Series & Tournaments',
      subtitle: isDetail ? null : 'Demo tournaments and fixtures',
      actions: !isDetail
          ? null
          : [
              Obx(() => IconButton(
                    tooltip: favorites.isFavorite(FavoriteKind.series, seriesId!)
                        ? 'Remove favorite'
                        : 'Add favorite',
                    icon: Icon(
                      favorites.isFavorite(FavoriteKind.series, seriesId!)
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: favorites.isFavorite(FavoriteKind.series, seriesId!)
                          ? const Color(0xFFF7D154)
                          : null,
                    ),
                    onPressed: () =>
                        favorites.toggle(FavoriteKind.series, seriesId!),
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
        return isDetail
            ? _SeriesDetail(controller: controller)
            : _SeriesHub(controller: controller);
      }),
    );
  }
}

class _SeriesHub extends StatelessWidget {
  final SeriesController controller;

  const _SeriesHub({required this.controller});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          const SectionHeader(
            icon: Icons.emoji_events_outlined,
            title: 'All series',
            subtitle: 'Select a tournament to see matches, standings and squads',
          ),
          ...controller.all.map((series) => _SeriesListTile(series: series)),
        ],
      );
}

class _SeriesListTile extends StatelessWidget {
  final Series series;

  const _SeriesListTile({required this.series});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.lg),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColorsSoft.green,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.emoji_events, color: Color(0xFF006B53)),
            ),
            title: Text(series.name,
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(
                '${series.format.label} · ${series.host} · ${series.dateRange}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.series(series.id)),
          ),
        ),
      );
}

abstract final class AppColorsSoft {
  static const Color green = Color(0xFFE7F5F1);
}

class _SeriesDetail extends StatelessWidget {
  final SeriesController controller;

  const _SeriesDetail({required this.controller});

  @override
  Widget build(BuildContext context) {
    final series = controller.series.value;
    if (series == null) {
      return const EmptyView(
        icon: Icons.emoji_events_outlined,
        title: 'Series not found',
        message: 'Try selecting a series from the tournament list.',
      );
    }
    final tabs = ['Overview', 'Matches', 'Points', 'Squads'];
    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          _SeriesHero(series: series),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => Row(
                  children: List.generate(tabs.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: PillChip(
                        label: tabs[index],
                        selected: controller.selectedTab.value == index,
                        onTap: () => controller.selectedTab.value = index,
                      ),
                    );
                  }),
                )),
          ),
          const SizedBox(height: AppSpacing.md),
          Obx(() => switch (controller.selectedTab.value) {
                0 => _Overview(series: series, controller: controller),
                1 => _Matches(controller: controller),
                2 => _Points(controller: controller),
                _ => _Squads(series: series),
              }),
        ],
      ),
    );
  }
}

class _SeriesHero extends StatelessWidget {
  final Series series;

  const _SeriesHero({required this.series});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF009270), Color(0xFF005E49)]),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(series.format.label,
                style: const TextStyle(
                    color: Color(0xFFF7D154), fontSize: 11,
                    fontWeight: FontWeight.w800, letterSpacing: 0.6)),
            const SizedBox(height: AppSpacing.sm),
            Text(series.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.sm),
            Text('${series.host} · ${series.dateRange}',
                style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
            const SizedBox(height: AppSpacing.md),
            Text(series.description,
                style: const TextStyle(color: Colors.white, fontSize: 12.5)),
          ],
        ),
      );
}

class _Overview extends StatelessWidget {
  final Series series;
  final SeriesController controller;

  const _Overview({required this.series, required this.controller});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tournament snapshot',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.md),
                  _stat('Matches in demo', '${controller.matches.length}'),
                  _stat('Teams', '${series.teamIds.length}'),
                  _stat('Format', series.format.label),
                  if (series.champion != null)
                    _stat('Champion', series.champion!),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(
              icon: Icons.emoji_events_outlined, title: 'Recent matches'),
          if (controller.matches.isEmpty)
            const EmptyView(
              icon: Icons.sports_cricket_outlined,
              title: 'No matches yet',
              message: 'Demo fixtures for this series will appear here.',
            )
          else
            ...controller.matches.take(3).map(
                  (match) => CompactMatchTile(
                    match: match,
                    onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                  ),
                ),
        ],
      );

  Widget _stat(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF777777), fontSize: 13)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _Matches extends StatelessWidget {
  final SeriesController controller;

  const _Matches({required this.controller});

  @override
  Widget build(BuildContext context) => controller.matches.isEmpty
      ? const EmptyView(
          icon: Icons.sports_cricket_outlined,
          title: 'No fixtures',
          message: 'This demo series has no fixtures attached.',
        )
      : Column(
          children: controller.matches
              .map((match) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: MatchCard(
                      match: match,
                      onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                    ),
                  ))
              .toList(),
        );
}

class _Points extends StatelessWidget {
  final SeriesController controller;

  const _Points({required this.controller});

  @override
  Widget build(BuildContext context) => controller.points.isEmpty
      ? const EmptyView(
          icon: Icons.table_chart_outlined,
          title: 'No points table',
          message: 'A demo points table is not available for this series.',
        )
      : Column(
          children: controller.points
              .map((table) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PointsTableCard(table: table),
                  ))
              .toList(),
        );
}

class _Squads extends StatelessWidget {
  final Series series;

  const _Squads({required this.series});

  @override
  Widget build(BuildContext context) => ResponsiveGrid(
        mobile: 2,
        tablet: 3,
        desktop: 4,
        children: series.teamIds.map((id) {
          return Card(
            child: ListTile(
              title: Text(id.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall),
              subtitle: const Text('View team profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(AppRoutes.team(id)),
            ),
          );
        }).toList(),
      );
}
