import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/data_table_widgets.dart';
import '../../data/models/series.dart';
import '../../data/repositories/cricket_repositories.dart';

class PointsTableCard extends StatelessWidget {
  final PointsTable table;

  const PointsTableCard({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    final teamRepository = Get.isRegistered<TeamRepository>()
        ? Get.find<TeamRepository>()
        : const TeamRepository();
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.table_chart_outlined,
                    size: 18, color: AppColors.green),
                const SizedBox(width: AppSpacing.sm),
                Text(table.title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ScoreTable(
              minWidth: 520,
              headers: const ['#', 'TEAM', 'P', 'W', 'L', 'NRR', 'PTS', 'FORM'],
              flex: const [1, 5, 1, 1, 1, 2, 1, 4],
              emphasizedRows: table.rows
                  .asMap()
                  .entries
                  .where((entry) => entry.value.position <= 2)
                  .map((entry) => entry.key)
                  .toSet(),
              rows: table.rows.map((row) {
                return [
                  '${row.position}',
                  teamRepository.cached(row.teamId)?.shortName ?? row.teamId,
                  '${row.played}',
                  '${row.won}',
                  '${row.lost}',
                  row.nrrLabel,
                  '${row.points}',
                  row.form.join(' '),
                ];
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
