import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: SwitchListTile(
          secondary: Icon(icon, color: AppColors.green, size: 21),
          title: Text(title, style: Theme.of(context).textTheme.titleSmall),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          value: value,
          activeThumbColor: AppColors.green,
          onChanged: onChanged,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        ),
      );
}

class NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const NavigationTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icon, color: AppColors.green, size: 21),
          title: Text(title, style: Theme.of(context).textTheme.titleSmall),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          trailing: trailing ??
              const Icon(Icons.chevron_right, color: AppColors.secondary, size: 20),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        ),
      );
}

class SegmentedPreference<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<T> values;
  final List<String> labels;
  final T selected;
  final ValueChanged<T> onChanged;

  const SegmentedPreference({
    super.key,
    required this.title,
    this.subtitle,
    required this.values,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: List.generate(values.length, (index) {
                  final value = values[index];
                  return ChoiceChip(
                    label: Text(labels[index]),
                    selected: value == selected,
                    onSelected: (_) => onChanged(value),
                    showCheckmark: false,
                    visualDensity: VisualDensity.compact,
                  );
                }),
              ),
            ],
          ),
        ),
      );
}
