import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import '../../data/models/ball_event.dart';
import '../match_center/match_center_controller.dart';
import '../match_center/widgets/score_widgets.dart';
import 'commentary_controller.dart';

class CommentaryView extends StatelessWidget {
  final String matchId;

  const CommentaryView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => MatchCenterController(matchId: matchId),
      tag: matchId,
    );
    final selectedFilter = provide(
      () => CommentaryViewController(),
      tag: 'filter-$matchId',
    ).filterIndex;
    return AppScaffold(
      title: 'Ball-by-ball Commentary',
      subtitle: controller.match.value?.title ?? 'Demo match',
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const ListSkeleton(count: 6);
        }
        if (controller.state.value.hasError) {
          return ErrorView(
              message: controller.errorMessage.value, onRetry: controller.load);
        }
        final match = controller.match.value;
        if (match == null) {
          return const EmptyView(
            icon: Icons.chat_bubble_outline,
            title: 'Commentary unavailable',
            message: 'This demo fixture has no commentary timeline.',
          );
        }
        final filtered = controller.selectedBalls
            .where(BallFilter.values[selectedFilter.value].predicate)
            .toList()
            .reversed
            .toList();
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...BallFilter.values.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: PillChip(
                              label: entry.value.label,
                              selected: selectedFilter.value == entry.key,
                              onTap: () => selectedFilter.value = entry.key,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (controller.innings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InningsSelector(
                    innings: controller.innings,
                    selected: controller.selectedInningsIndex.value,
                    onChanged: (value) =>
                        controller.selectedInningsIndex.value = value,
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Text('Timeline',
                              style: Theme.of(context).textTheme.titleSmall),
                          const Spacer(),
                          Text(
                            'Updated ${match.lastUpdatedLabel}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                          child: Center(
                            child: Text('No balls match this filter.'),
                          ),
                        )
                      else
                        ..._groupByOver(filtered, context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _groupByOver(List<BallEvent> balls, BuildContext context) {
    final widgets = <Widget>[];
    int? currentOver;
    for (final ball in balls) {
      if (currentOver != ball.over) {
        currentOver = ball.over;
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              'OVER ${ball.over + 1}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ));
      }
      widgets.add(CommentaryTile(
        ball: ball,
        onPlayerTap: () => openPlayerProfile(ball.batterId),
      ));
    }
    return widgets;
  }
}
