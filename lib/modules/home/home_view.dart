import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/match_cards.dart';
import '../../core/widgets/responsive.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import '../../data/models/match.dart';
import '../../data/models/series.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final bool embedded;

  const HomeView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return AppScaffold(
      title: 'CRICLIVE',
      subtitle: 'Live cricket scores · demo data',
      automaticallyImplyLeading: !embedded,
      actions: [
        IconButton(
          tooltip: 'Settings',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Get.toNamed(AppRoutes.settings),
        ),
      ],
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const RefreshIndicator(
            onRefresh: _noop,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [MatchCardSkeleton(), MatchCardSkeleton(), MatchCardSkeleton()],
              ),
            ),
          );
        }
        if (controller.state.value.hasError) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.load,
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              _FeaturedMatch(controller: controller),
              const SectionHeader(
                title: 'Matches',
                subtitle: 'Tap a card for the full match centre',
                icon: Icons.sports_cricket_outlined,
              ),
              _MatchTabs(controller: controller),
              const SizedBox(height: AppSpacing.md),
              Obx(() => ResponsiveGrid(
                    mobile: 1,
                    tablet: 2,
                    desktop: 3,
                    children: controller.visibleMatches.map((match) {
                      return MatchCard(
                        match: match,
                        onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                        isFavorite: controller.isFavorite(match.id),
                        onToggleFavorite: () => controller.toggleFavorite(match.id),
                      );
                    }).toList(),
                  )),
              SectionHeader(
                title: 'Popular series',
                subtitle: 'Tournaments in the demo catalogue',
                icon: Icons.emoji_events_outlined,
                actionLabel: 'All series',
                onAction: () => Get.toNamed(AppRoutes.seriesHub),
              ),
              SizedBox(
                height: 132,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.series.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) =>
                      _SeriesTile(series: controller.series[index]),
                ),
              ),
              const SectionHeader(title: 'Explore CRICLIVE', icon: Icons.apps_outlined),
              const _QuickLinks(),
              SectionHeader(
                title: 'International cricket',
                icon: Icons.public_outlined,
                actionLabel: 'Fixtures',
                onAction: () => Get.toNamed(AppRoutes.fixtures),
              ),
              _MatchStrip(controller: controller, international: true),
              SectionHeader(
                title: 'Domestic cricket',
                icon: Icons.local_fire_department_outlined,
                actionLabel: 'Points',
                onAction: () => Get.toNamed(AppRoutes.points),
              ),
              _MatchStrip(controller: controller, international: false),
            ],
          ),
        );
      }),
    );
  }
}

Future<void> _noop() async {}

class _MatchTabs extends StatelessWidget {
  final HomeController controller;

  const _MatchTabs({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: PillChip(
                  label: ['LIVE', 'UPCOMING', 'RESULTS'][i],
                  selected: controller.selectedTab.value == i,
                  onTap: () => controller.selectedTab.value = i,
                ),
              ),
          ],
        ),
      ));
}

class _FeaturedMatch extends StatelessWidget {
  final HomeController controller;

  const _FeaturedMatch({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
        final match = controller.live.isNotEmpty ? controller.live.first : null;
        if (match == null) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.green, AppColors.darkGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              onTap: () => Get.toNamed(AppRoutes.match(match.id)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: AppColors.accent, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'FEATURED LIVE MATCH · DEMO',
                          style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      match.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${match.round} · ${match.venue}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _FeaturedScore(match: match),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      match.statusText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

class _FeaturedScore extends StatelessWidget {
  final CricketMatch match;

  const _FeaturedScore({required this.match});

  @override
  Widget build(BuildContext context) {
    final inningA = match.innings.isEmpty ? null : match.innings.first;
    final inningB = match.innings.length > 1 ? match.innings[1] : null;
    return Row(
      children: [
        Expanded(
          child: _scoreColumn(
            context,
            match.teamIds.first,
            inningA == null
                ? 'Yet to bat'
                : '${inningA.runs}/${inningA.wickets} (${inningA.oversLabel})',
          ),
        ),
        Container(width: 1, height: 38, color: Colors.white24),
        Expanded(
          child: _scoreColumn(
            context,
            match.teamIds.last,
            inningB == null
                ? 'Yet to bat'
                : '${inningB.runs}/${inningB.wickets} (${inningB.oversLabel})',
          ),
        ),
      ],
    );
  }

  Widget _scoreColumn(BuildContext context, String teamId, String score) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(teamId.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(score,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
        ],
      );
}

class _SeriesTile extends StatelessWidget {
  final Series series;

  const _SeriesTile({required this.series});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            onTap: () => Get.toNamed(AppRoutes.series(series.id)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          size: 18, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(series.format.label,
                            style: Theme.of(context).textTheme.labelMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    series.shortName,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${series.host} · ${series.dateRange}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    final links = [
      ('Points Table', Icons.table_chart_outlined, AppRoutes.points),
      ('Rankings', Icons.leaderboard_outlined, AppRoutes.rankings),
      ('Statistics', Icons.bar_chart_outlined, AppRoutes.statistics),
      ('News', Icons.article_outlined, AppRoutes.news),
      ('Teams', Icons.groups_outlined, AppRoutes.teams),
      ('Players', Icons.person_outline, AppRoutes.players),
    ];
    return ResponsiveGrid(
      mobile: 2,
      tablet: 3,
      desktop: 6,
      children: links.map((link) {
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            onTap: () => Get.toNamed(link.$3),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
              child: Column(
                children: [
                  Icon(link.$2, size: 22, color: AppColors.green),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    link.$1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w700, color: AppColors.text),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MatchStrip extends StatelessWidget {
  final HomeController controller;
  final bool international;

  const _MatchStrip({required this.controller, required this.international});

  @override
  Widget build(BuildContext context) => Obx(() {
        final matches = [...controller.live, ...controller.upcoming]
            .where((match) => match.teamIds
                .any((id) => controller.isInternational(id) == international))
            .take(6)
            .toList();
        if (matches.isEmpty) {
          return const SizedBox(height: 40, child: EmptyView(
            icon: Icons.sports_cricket_outlined,
            title: 'No matches to show',
            message: 'Demo fixtures will appear here.',
          ));
        }
        return SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final match = matches[index];
              return SizedBox(
                width: 230,
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              StatusChip(status: match.status, compact: true),
                              const Spacer(),
                              Text(match.format.label,
                                  style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            match.title,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            match.statusText,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      });
}
