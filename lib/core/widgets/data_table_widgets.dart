import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class ScoreTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final List<int> flex;
  final Set<int>? emphasizedRows;
  final double minWidth;

  const ScoreTable({
    super.key,
    required this.headers,
    required this.rows,
    this.flex = const [4, 2, 2, 2, 2],
    this.emphasizedRows,
    this.minWidth = 360,
  });

  @override
  Widget build(BuildContext context) {
    final widths = flex.length == headers.length ? flex : List.filled(headers.length, 1);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: Table(
          columnWidths: {
            for (var i = 0; i < widths.length; i++)
              i: FlexColumnWidth(widths[i].toDouble()),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurface
                    : AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              children: headers.map((header) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.md),
                  child: Text(
                    header,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 10.5,
                        ),
                    textAlign: TextAlign.start,
                  ),
                );
              }).toList(),
            ),
            ...rows.asMap().entries.map(
                  (entry) => TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
                        ),
                      ),
                      color: emphasizedRows?.contains(entry.key) == true
                          ? AppColors.softGreen.withValues(alpha: 0.45)
                          : null,
                    ),
                    children: entry.value.map((cell) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: AppSpacing.md),
                        child: Text(
                          cell,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.5,
                                fontWeight: entry.key == 0 ? FontWeight.w700 : null,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 118,
              child: Text(label, style: Theme.of(context).textTheme.bodySmall),
            ),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            ?trailing,
          ],
        ),
      );
}
