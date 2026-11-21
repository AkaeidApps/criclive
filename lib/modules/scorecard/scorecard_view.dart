import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import '../match_center/match_center_controller.dart';
import '../match_center/widgets/score_widgets.dart';

class ScorecardView extends StatelessWidget {
  final String matchId;

  const ScorecardView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => MatchCenterController(matchId: matchId),
      tag: matchId,
    );
    return AppScaffold(
      title: 'Full Scorecard',
      subtitle: controller.match.value?.title ?? 'Demo match',
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const TableSkeleton(rows: 10);
        }
        if (controller.state.value.hasError) {
          return ErrorView(
              message: controller.errorMessage.value, onRetry: controller.load);
        }
        final match = controller.match.value;
        final inning = controller.selectedInnings;
        if (match == null || inning == null) {
          return const EmptyView(
            icon: Icons.scoreboard_outlined,
            title: 'Scorecard unavailable',
            message: 'No demo innings data exists for this fixture.',
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              if (match.innings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InningsSelector(
                    innings: match.innings,
                    selected: controller.selectedInningsIndex.value,
                    onChanged: (value) =>
                        controller.selectedInningsIndex.value = value,
                  ),
                ),
              MetricsRow(
                crr: controller.crrLabel,
                rrr: controller.rrrLabel,
                target: controller.targetLabel,
                partnership: controller.partnershipLabel,
              ),
              const SizedBox(height: AppSpacing.md),
              BattingCard(innings: inning),
              const SizedBox(height: AppSpacing.md),
              BowlingCard(innings: inning),
              const SizedBox(height: AppSpacing.md),
              FallOfWicketsCard(innings: inning),
              const SizedBox(height: AppSpacing.md),
              if (match.resultText != null)
                Card(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Text(
                      match.resultText!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
