import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/responsive.dart';
import '../../core/widgets/section_header.dart';

class MoreView extends StatelessWidget {
  final bool embedded;

  const MoreView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final groups = <MapEntry<String, List<(String, IconData, String)>>>[
      MapEntry('Matches', [
        ('Live Matches', Icons.bolt, AppRoutes.live),
        ('Upcoming Matches', Icons.schedule, AppRoutes.upcoming),
        ('Recent Results', Icons.emoji_events_outlined, AppRoutes.results),
        ('Fixtures & Results', Icons.calendar_month_outlined, AppRoutes.fixtures),
        ('Match Centre', Icons.scoreboard_outlined, AppRoutes.match('m_live_ind_aus')),
        ('Full Scorecard', Icons.table_chart_outlined, AppRoutes.matchScorecard('m_live_ind_aus')),
        ('Ball-by-ball Commentary', Icons.format_list_bulleted, AppRoutes.matchCommentary('m_live_ind_aus')),
        ('Over Summary', Icons.grid_view_outlined, AppRoutes.matchOvers('m_live_ind_aus')),
        ('Match Information', Icons.info_outline, AppRoutes.matchInfoFor('m_live_ind_aus')),
      ]),
      MapEntry('Tournaments', [
        ('Series & Tournaments', Icons.emoji_events, AppRoutes.seriesHub),
        ('Points Table', Icons.leaderboard_outlined, AppRoutes.points),
        ('Teams & Squads', Icons.groups_outlined, AppRoutes.teams),
        ('Players', Icons.person_outline, AppRoutes.players),
        ('Statistics', Icons.bar_chart_outlined, AppRoutes.statistics),
        ('ICC Rankings', Icons.military_tech_outlined, AppRoutes.rankings),
      ]),
      MapEntry('Discover', [
        ('Cricket News', Icons.article_outlined, AppRoutes.news),
        ('Search', Icons.search, AppRoutes.search),
        ('Favorites', Icons.star_border, AppRoutes.favorites),
        ('Notification Settings', Icons.notifications_none, AppRoutes.notificationSettings),
        ('App Settings', Icons.settings_outlined, AppRoutes.settings),
        ('About & Data Sources', Icons.help_outline, AppRoutes.about),
      ]),
    ];

    return AppScaffold(
      title: 'More',
      subtitle: 'Every CRICLIVE screen in one place',
      automaticallyImplyLeading: !embedded,
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          for (final group in groups) ...[
            SectionHeader(title: group.key, icon: Icons.apps_outlined),
            ResponsiveGrid(
              mobile: 2,
              tablet: 3,
              desktop: 4,
              children: group.value.map((item) {
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    onTap: () => Get.toNamed(item.$3),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Icon(item.$2,
                              size: 18, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              item.$1,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
