import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../data/models/team.dart';

class TeamCrest extends StatelessWidget {
  final Team? team;
  final double size;
  final bool showName;

  const TeamCrest({
    super.key,
    required this.team,
    this.size = 36,
    this.showName = false,
  });

  @override
  Widget build(BuildContext context) {
    final crest = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: team?.color.withValues(alpha: 0.12) ?? AppColorsFallback.soft,
        shape: BoxShape.circle,
        border: Border.all(
          color: team?.color.withValues(alpha: 0.35) ?? AppColorsFallback.border,
        ),
      ),
      child: Text(
        team?.flag ?? '🏏',
        style: TextStyle(fontSize: size * 0.48),
      ),
    );
    if (!showName) return crest;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        crest,
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            team?.shortName ?? 'Unknown',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

abstract final class AppColorsFallback {
  static const soft = Color(0xFFEFF1F2);
  static const border = Color(0xFFDDE1E3);
}
