import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/match_cards.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import 'fixtures_controller.dart';

class FixturesView extends StatelessWidget {
  const FixturesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = provide(() => FixturesController(), tag: 'fixtures');
    return AppScaffold(
      title: 'Fixtures & Results',
      subtitle: 'All demo matches in one place',
      body: Obx(() {
        if (controller.state.value.isLoading) return const ListSkeleton(count: 5);
        if (controller.state.value.hasError) {
          return ErrorView(
              message: controller.errorMessage.value, onRetry: controller.load);
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                      children: FixturesController.filters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: PillChip(
                            label: filter,
                            selected: controller.filter.value == filter,
                            onTap: () => controller.filter.value = filter,
                          ),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (controller.filtered.isEmpty)
                const EmptyView(
                  icon: Icons.calendar_month_outlined,
                  title: 'No fixtures found',
                  message: 'Try a different filter.',
                )
              else
                ...controller.grouped.entries.map((entry) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          child: Text(
                            AppFormatters.date(entry.key),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        ...entry.value.map(
                          (match) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: CompactMatchTile(
                              match: match,
                              onTap: () => Get.toNamed(AppRoutes.match(match.id)),
                            ),
                          ),
                        ),
                      ],
                    )),
            ],
          ),
        );
      }),
    );
  }
}
