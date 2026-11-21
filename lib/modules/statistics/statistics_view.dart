import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/data_table_widgets.dart';
import '../../core/widgets/state_widgets.dart';
import 'statistics_controller.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = provide(() => StatisticsController(), tag: 'stats');
    return AppScaffold(
      title: 'Batting & Bowling Statistics',
      subtitle: 'Demo career leaders',
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.state.value.hasError) {
          return const ErrorView(
            message: 'Demo statistics could not be loaded.',
            onRetry: _retry,
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: StatsCategory.values.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: PillChip(
                            label: category.label,
                            selected: controller.category.value == category,
                            onTap: () => controller.category.value = category,
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              const SizedBox(height: AppSpacing.md),
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'T20I', 'ODI'].map((format) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: PillChip(
                            label: format,
                            selected: controller.format.value == format,
                            onTap: () => controller.format.value = format,
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              const SizedBox(height: AppSpacing.lg),
              Obx(() => switch (controller.category.value) {
                    StatsCategory.batting => _BattingTable(controller: controller),
                    StatsCategory.bowling => _BowlingTable(controller: controller),
                    StatsCategory.records => _Records(controller: controller),
                  }),
            ],
          ),
        );
      }),
    );
  }
}

void _retry() {
  if (Get.isRegistered<StatisticsController>(tag: 'stats')) {
    Get.find<StatisticsController>(tag: 'stats').load();
  }
}

class _BattingTable extends StatelessWidget {
  final StatisticsController controller;

  const _BattingTable({required this.controller});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Obx(() {
            final rows = controller.filteredBatting;
            if (rows.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: Text('No batting rows for this filter.')),
              );
            }
            return ScoreTable(
              minWidth: 620,
              headers: const ['#', 'PLAYER', 'FMT', 'M', 'RUNS', 'HS', 'AVG', 'SR'],
              flex: const [1, 7, 2, 1, 2, 2, 2, 2],
              rows: rows.map((row) {
                return [
                  '${row.rank}',
                  '${row.playerName} (${row.teamCode})',
                  row.format,
                  '${row.matches}',
                  '${row.runs}',
                  '${row.highestScore}',
                  row.average.toStringAsFixed(2),
                  row.strikeRate.toStringAsFixed(2),
                ];
              }).toList(),
            );
          }),
        ),
      );
}

class _BowlingTable extends StatelessWidget {
  final StatisticsController controller;

  const _BowlingTable({required this.controller});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Obx(() {
            final rows = controller.filteredBowling;
            if (rows.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: Text('No bowling rows for this filter.')),
              );
            }
            return ScoreTable(
              minWidth: 620,
              headers: const ['#', 'PLAYER', 'FMT', 'M', 'WKT', 'AVG', 'ECO', 'BEST'],
              flex: const [1, 7, 2, 1, 2, 2, 2, 2],
              rows: rows.map((row) {
                return [
                  '${row.rank}',
                  '${row.playerName} (${row.teamCode})',
                  row.format,
                  '${row.matches}',
                  '${row.wickets}',
                  row.average.toStringAsFixed(2),
                  row.economy.toStringAsFixed(2),
                  row.bestFigures,
                ];
              }).toList(),
            );
          }),
        ),
      );
}

class _Records extends StatelessWidget {
  final StatisticsController controller;

  const _Records({required this.controller});

  @override
  Widget build(BuildContext context) => Column(
        children: controller.records.map((record) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(AppSpacing.lg),
                leading: Text(record.icon, style: const TextStyle(fontSize: 24)),
                title: Text(record.title,
                    style: Theme.of(context).textTheme.titleSmall),
                subtitle: Text('${record.holder} · ${record.detail}'),
                trailing: Text(record.value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                onTap: () => Get.toNamed(AppRoutes.rankings),
              ),
            ),
          );
        }).toList(),
      );
}
