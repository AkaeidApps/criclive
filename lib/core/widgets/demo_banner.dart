import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../constants/demo_config.dart';

/// Persistent disclosure so demo fixtures are never mistaken for live data.
class DemoBanner extends StatelessWidget {
  final bool compact;

  const DemoBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.softAccent,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 15, color: Color(0xFF8A6A00)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              compact
                  ? 'DEMO DATA · NOT REAL LIVE SCORES'
                  : 'DEMO DATA · Scores and players are illustrative only',
              style: TextStyle(
                fontSize: compact ? 10.5 : 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A5D00),
                letterSpacing: 0.3,
              ),
            ),
          ),
          Tooltip(
            message: DemoConfig.dataDisclosure,
            child: const Icon(Icons.help_outline, size: 15, color: Color(0xFF8A6A00)),
          ),
        ],
      ),
    );
  }
}
