import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../enums/app_enums.dart';

class StatusChip extends StatelessWidget {
  final MatchStatus status;
  final bool compact;

  const StatusChip({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      MatchStatus.live => (bg: AppColors.softRed, fg: AppColors.live),
      MatchStatus.upcoming => (bg: AppColors.softBlue, fg: const Color(0xFF2A5C9A)),
      MatchStatus.completed => (bg: AppColors.softGreen, fg: AppColors.darkGreen),
      MatchStatus.delayed => (bg: AppColors.softAccent, fg: const Color(0xFF8A6A00)),
      MatchStatus.dataUnavailable => (bg: const Color(0xFFEEEFF1), fg: AppColors.secondary),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status.isLive)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 5),
              decoration: const BoxDecoration(
                  color: AppColors.live, shape: BoxShape.circle),
            ),
          Text(
            status.label,
            style: TextStyle(
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w800,
              color: colors.fg,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class FormatChip extends StatelessWidget {
  final MatchFormat format;

  const FormatChip({super.key, required this.format});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          format.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
        ),
      );
}

class PillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const PillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      avatar: icon == null ? null : Icon(icon, size: 14),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    );
  }
}

class MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String? hint;

  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.green,
                      fontSize: 15,
                    ),
              ),
              if (hint != null)
                Text(hint!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9)),
            ],
          ),
        ),
      );
}
