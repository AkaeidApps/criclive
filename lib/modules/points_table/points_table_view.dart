import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/state_widgets.dart';
import 'points_table_controller.dart';
import 'points_table_widget.dart';

class PointsTableView extends StatelessWidget {
  const PointsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = provide(() => PointsTableController(), tag: 'points');
    return AppScaffold(
      title: 'Points Table',
      subtitle: 'Demo standings',
      actions: [
        IconButton(
          tooltip: 'Fixtures',
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () => Get.toNamed(AppRoutes.fixtures),
        ),
      ],
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
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
                      children: controller.series.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: PillChip(
                            label: entry.value.shortName,
                            selected: controller.selectedIndex.value == entry.key,
                            onTap: () => controller.selectSeries(entry.key),
                          ),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: AppSpacing.lg),
              Obx(() {
                if (controller.tables.isEmpty) {
                  return const EmptyView(
                    icon: Icons.table_chart_outlined,
                    title: 'No table for this series',
                    message: 'Choose a different tournament from the chips above.',
                  );
                }
                return Column(
                  children: controller.tables
                      .map((table) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: PointsTableCard(table: table),
                          ))
                      .toList(),
                );
              }),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Text(
                    'Points, net run rates and form shown here are bundled demo values. '
                    'They are not official tournament standings.',
                    style: Theme.of(context).textTheme.bodySmall,
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
