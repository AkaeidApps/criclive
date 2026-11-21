import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/data_table_widgets.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import 'match_center_controller.dart';
import 'widgets/score_widgets.dart';

class MatchCenterView extends StatelessWidget {
  final String matchId;

  const MatchCenterView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => MatchCenterController(matchId: matchId),
      tag: matchId,
    );
    return Obx(() {
      final match = controller.match.value;
      return AppScaffold(
        title: match?.seriesName ?? 'Match Centre',
        subtitle: match?.title ?? 'Loading demo match…',
        actions: [
          Obx(() => IconButton(
                tooltip: controller.isFavorite ? 'Remove favorite' : 'Add favorite',
                icon: Icon(
                  controller.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: controller.isFavorite ? AppColors.accent : null,
                ),
                onPressed: controller.toggleFavorite,
              )),
        ],
        body: _body(controller),
      );
    });
  }

  Widget _body(MatchCenterController controller) {
    if (controller.state.value.isLoading) {
      return const SingleChildScrollView(
        child: Column(children: [TableSkeleton(), MatchCardSkeleton()]),
      );
    }
    if (controller.state.value.hasError) {
      return ErrorView(
          message: controller.errorMessage.value, onRetry: controller.load);
    }
    final match = controller.match.value;
    if (match == null) {
      return const EmptyView(
        icon: Icons.search_off,
        title: 'Match unavailable',
        message: 'This demo match could not be found.',
      );
    }
    return Column(
      children: [
        _MatchTabs(controller: controller),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: IndexedStack(
            index: controller.tabIndex.value,
            children: [
              _ScoreTab(controller: controller),
              _CommentaryPreview(controller: controller),
              _OversPreview(controller: controller),
              _InfoPreview(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}

class _MatchTabs extends StatelessWidget {
  final MatchCenterController controller;
  static const labels = ['Scorecard', 'Commentary', 'Overs', 'Info'];
  static const icons = [
    Icons.scoreboard_outlined,
    Icons.format_list_bulleted_outlined,
    Icons.grid_view_outlined,
    Icons.info_outline,
  ];

  const _MatchTabs({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(labels.length, (index) {
            final selected = controller.tabIndex.value == index;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                avatar: Icon(icons[index],
                    size: 15,
                    color: selected ? AppColors.green : AppColors.secondary),
                label: Text(labels[index]),
                selected: selected,
                onSelected: (_) => controller.tabIndex.value = index,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
              ),
            );
          }),
        ),
      ));
}

class _ScoreTab extends StatelessWidget {
  final MatchCenterController controller;

  const _ScoreTab({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
        final match = controller.match.value!;
        final inning = controller.selectedInnings;
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              ScoreboardCard(
                match: match,
                selectedInningsIndex: controller.selectedInningsIndex.value,
                onInningsChanged: (index) =>
                    controller.selectedInningsIndex.value = index,
              ),
              const SizedBox(height: AppSpacing.md),
              MetricsRow(
                crr: controller.crrLabel,
                rrr: controller.rrrLabel,
                target: controller.targetLabel,
                partnership: controller.partnershipLabel,
              ),
              const SizedBox(height: AppSpacing.md),
              if (inning != null) ...[
                BattingCard(innings: inning),
                const SizedBox(height: AppSpacing.md),
                BowlingCard(innings: inning),
                const SizedBox(height: AppSpacing.md),
                FallOfWicketsCard(innings: inning),
              ] else
                const EmptyView(
                  icon: Icons.hourglass_top,
                  title: 'Match yet to start',
                  message: 'Scorecards will appear here once play begins in the demo.',
                ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.matchScorecard(match.id)),
                icon: const Icon(Icons.open_in_full),
                label: const Text('Open full scorecard'),
              ),
            ],
          ),
        );
      });
}

class _CommentaryPreview extends StatelessWidget {
  final MatchCenterController controller;

  const _CommentaryPreview({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
        final match = controller.match.value!;
        final balls = controller.selectedBalls.take(8).toList().reversed.toList();
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latest commentary',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(
                        'Demo timeline · updated ${match.lastUpdatedLabel}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (balls.isEmpty)
                const EmptyView(
                  icon: Icons.chat_bubble_outline,
                  title: 'No commentary yet',
                  message: 'Ball-by-ball updates will appear here.',
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    child: Column(
                      children: balls
                          .map((ball) => CommentaryTile(
                                ball: ball,
                                onPlayerTap: () =>
                                    openPlayerProfile(ball.batterId),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () =>
                    Get.toNamed(AppRoutes.matchCommentary(match.id)),
                icon: const Icon(Icons.open_in_full),
                label: const Text('Open ball-by-ball commentary'),
              ),
            ],
          ),
        );
      });
}

class _OversPreview extends StatelessWidget {
  final MatchCenterController controller;

  const _OversPreview({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
        final match = controller.match.value!;
        final overs = controller.selectedOvers.reversed.take(5).toList();
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              if (overs.isEmpty)
                const EmptyView(
                  icon: Icons.grid_view_outlined,
                  title: 'No overs yet',
                  message: 'Over summaries appear as the demo innings progresses.',
                )
              else
                ...overs.map((over) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: OverSummaryCard(over: over),
                    )),
              OutlinedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.matchOvers(match.id)),
                icon: const Icon(Icons.open_in_full),
                label: const Text('Open over summary'),
              ),
            ],
          ),
        );
      });
}

class _InfoPreview extends StatelessWidget {
  final MatchCenterController controller;

  const _InfoPreview({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
        final match = controller.match.value!;
        return ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Match information',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.md),
                    InfoRow(label: 'Venue', value: '${match.venue}, ${match.city}'),
                    InfoRow(label: 'Format', value: match.format.label),
                    InfoRow(label: 'Toss', value: match.toss),
                    InfoRow(label: 'Start', value: match.startTimeLabel),
                    InfoRow(
                        label: 'Last updated',
                        value: AppFormatters.dateTime(match.lastUpdated)),
                    if (match.resultText != null)
                      InfoRow(label: 'Result', value: match.resultText!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.matchInfoFor(match.id)),
              icon: const Icon(Icons.open_in_full),
              label: const Text('Open match information'),
            ),
          ],
        );
      });
}
