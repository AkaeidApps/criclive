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
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import 'matches_controller.dart';

class MatchesView extends StatelessWidget {
  final MatchCategory? category;
  final bool embedded;

  const MatchesView({
    super.key,
    this.category,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCategory = category ?? MatchCategory.live;
    return AppScaffold(
      title: _title(effectiveCategory),
      subtitle: 'Bundled demo fixtures · not real live data',
      automaticallyImplyLeading: !embedded,
      actions: [
        IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.search),
          onPressed: () => Get.toNamed(AppRoutes.search),
        ),
      ],
      body: DefaultTabController(
        length: 3,
        initialIndex: effectiveCategory.index,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category == null) const _CategoryTabs(),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: MatchCategory.values
                    .map((value) => _MatchList(category: value))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _title(MatchCategory value) => switch (value) {
        MatchCategory.live => 'Live Matches',
        MatchCategory.upcoming => 'Upcoming Matches',
        MatchCategory.results => 'Recent Results',
      };
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) => const TabBar(
        tabs: [
          Tab(text: 'LIVE'),
          Tab(text: 'UPCOMING'),
          Tab(text: 'RESULTS'),
        ],
      );
}

class _MatchList extends StatelessWidget {
  final MatchCategory category;

  const _MatchList({required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => MatchListController(category: category),
      tag: category.name,
    );
    return Obx(() {
      if (controller.state.value.isLoading) {
        return const SingleChildScrollView(
          child: Column(children: [
            MatchCardSkeleton(),
            MatchCardSkeleton(),
            MatchCardSkeleton(),
          ]),
        );
      }
      if (controller.state.value.hasError) {
        return ErrorView(
          message: controller.errorMessage.value,
          onRetry: controller.load,
        );
      }
      if (controller.state.value == ViewState.empty) {
        return EmptyView(
          icon: Icons.sports_cricket_outlined,
          title: 'No matches here yet',
          message: 'Try another category or refresh the demo data.',
          actionLabel: 'Refresh',
          onAction: controller.load,
        );
      }
      return RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.filters
                    .map((filter) => Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: PillChip(
                            label: filter,
                            selected: controller.filter.value == filter,
                            onTap: () => controller.filter.value = filter,
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Obx(() {
              final matches = controller.filteredMatches;
              if (matches.isEmpty) {
                return const EmptyView(
                  icon: Icons.filter_alt_off_outlined,
                  title: 'No matches match this filter',
                  message: 'Choose a different filter to see demo fixtures.',
                );
              }
              return ResponsiveGrid(
                mobile: 1,
                tablet: 2,
                desktop: 3,
                children: matches
                    .map((match) => MatchCard(
                          match: match,
                          onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                          isFavorite: controller.isFavorite(match.id),
                          onToggleFavorite: () =>
                              controller.toggleFavorite(match.id),
                        ))
                    .toList(),
              );
            }),
          ],
        ),
      );
    });
  }
}
