import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import '../match_center/match_center_controller.dart';
import '../match_center/widgets/score_widgets.dart';

class OversViewController extends GetxController {
  final selectedOver = 0.obs;
}

class OversView extends StatelessWidget {
  final String matchId;

  const OversView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => MatchCenterController(matchId: matchId),
      tag: matchId,
    );
    final viewState = provide(
      () => OversViewController(),
      tag: 'overs-$matchId',
    );
    return AppScaffold(
      title: 'Over Summary',
      subtitle: controller.match.value?.title ?? 'Demo match',
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const ListSkeleton(count: 5);
        }
        if (controller.state.value.hasError) {
          return ErrorView(
              message: controller.errorMessage.value, onRetry: controller.load);
        }
        final match = controller.match.value;
        final overs = controller.selectedOvers;
        if (match == null || overs.isEmpty) {
          return const EmptyView(
            icon: Icons.grid_view_outlined,
            title: 'No over data',
            message: 'Overs appear here once the demo innings begins.',
          );
        }
        if (viewState.selectedOver.value >= overs.length) {
          viewState.selectedOver.value = overs.length - 1;
        }
        final selected = overs[viewState.selectedOver.value];
        final maxRuns = overs
            .map((over) => over.runs)
            .reduce((a, b) => a > b ? a : b);
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
                      Text('Runs per over',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 132,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: overs.map((over) {
                              final height =
                                  maxRuns == 0 ? 4.0 : 6 + (over.runs / maxRuns) * 60;
                              final index = overs.indexOf(over);
                              return SizedBox(
                                width: 30,
                                child: GestureDetector(
                                  onTap: () =>
                                      viewState.selectedOver.value = index,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${over.runs}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(fontSize: 9)),
                                        const SizedBox(height: 3),
                                        Container(
                                          height: height,
                                          decoration: BoxDecoration(
                                            color: index == viewState.selectedOver.value
                                                ? AppColors.green
                                                : AppColors.softGreen,
                                            borderRadius: const BorderRadius.vertical(
                                                top: Radius.circular(4)),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('${over.number + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(fontSize: 8)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OverSummaryCard(over: selected),
              const SizedBox(height: AppSpacing.md),
              Text('All overs', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              ...overs.reversed.map((over) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      title: Text('Over ${over.number + 1}',
                          style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text(
                          '${over.runs} runs · ${over.wickets} wickets · ${over.dotBalls} dots'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => viewState.selectedOver.value =
                          overs.indexWhere((item) => item.number == over.number),
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
