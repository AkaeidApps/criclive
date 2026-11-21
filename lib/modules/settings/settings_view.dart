import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/constants/demo_config.dart';
import '../../core/enums/app_enums.dart';
import '../../core/widgets/preference_tiles.dart';
import '../../data/repositories/local_repositories.dart';
import '../favorites/favorites_controller.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  final bool showNotifications;

  const SettingsView({super.key, this.showNotifications = false});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return showNotifications
        ? _NotificationSettings(controller: settings)
        : _AppSettings(controller: settings);
  }
}

class _AppSettings extends StatelessWidget {
  final SettingsController controller;

  const _AppSettings({required this.controller});

  @override
  Widget build(BuildContext context) => AppScaffold(
        title: 'App Settings',
        subtitle: 'Preferences are stored on this device',
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            Obx(() => SegmentedPreference<ThemePreference>(
                  title: 'Appearance',
                  subtitle: 'Light theme is the default',
                  values: ThemePreference.values,
                  labels: ThemePreference.values.map((value) => value.label).toList(),
                  selected: controller.themePreference.value,
                  onChanged: controller.setTheme,
                )),
            const SizedBox(height: AppSpacing.md),
            Obx(() => SegmentedPreference<int>(
                  title: 'Demo refresh interval',
                  subtitle: 'How often the UI would poll for updates in Phase 2',
                  values: const [15, 30, 60],
                  labels: const ['15 sec', '30 sec', '60 sec'],
                  selected: controller.refreshSeconds.value,
                  onChanged: controller.setRefreshSeconds,
                )),
            const SizedBox(height: AppSpacing.md),
            Obx(() => SwitchTile(
                  icon: Icons.data_usage_outlined,
                  title: 'Data saver',
                  subtitle: 'Shortens simulated loading delays',
                  value: controller.dataSaver.value,
                  onChanged: controller.setDataSaver,
                )),
            const SizedBox(height: AppSpacing.md),
            Obx(() => SwitchTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Simulate refresh error',
                  subtitle: 'Development tool: shows the error and retry states',
                  value: controller.simulateErrors.value,
                  onChanged: controller.setSimulateErrors,
                )),
            const SizedBox(height: AppSpacing.md),
            NavigationTile(
              icon: Icons.notifications_none,
              title: 'Notification Settings',
              subtitle: 'Choose which demo events would alert you',
              onTap: () => Get.toNamed(AppRoutes.notificationSettings),
            ),
            const SizedBox(height: AppSpacing.md),
            NavigationTile(
              icon: Icons.info_outline,
              title: 'About & Data Sources',
              subtitle: 'Phase 1 disclosure and licensing notes',
              onTap: () => Get.toNamed(AppRoutes.about),
            ),
            const SizedBox(height: AppSpacing.md),
            _LocalDataCard(controller: controller),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Text(DemoConfig.dataDisclosure,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
          ],
        ),
      );
}

class _LocalDataCard extends StatelessWidget {
  final SettingsController controller;

  const _LocalDataCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Local data', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Obx(() => Text('${favorites.total} favorite items saved on this device.',
                style: Theme.of(context).textTheme.bodySmall)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => _confirmReset(context, controller),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Reset preferences'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(
      BuildContext context, SettingsController controller) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset preferences?'),
        content: const Text(
            'Notification choices, theme and demo settings will return to defaults. Favorites are kept.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset')),
        ],
      ),
    );
    if (confirmed == true) await controller.resetAll();
  }
}

class _NotificationSettings extends StatelessWidget {
  final SettingsController controller;

  const _NotificationSettings({required this.controller});

  @override
  Widget build(BuildContext context) => AppScaffold(
        title: 'Notification Settings',
        subtitle: 'Local preferences · no push service in Phase 1',
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Text(
                  'These choices are saved locally. Phase 1 does not send push notifications; '
                  'the settings prepare the preference model for the real-data phase.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Column(
                  children: [
                    _toggle(context, controller, SettingsKeys.liveScores,
                        Icons.bolt, 'Live score updates', 'Every over and major score change'),
                    const SizedBox(height: AppSpacing.sm),
                    _toggle(context, controller, SettingsKeys.wickets,
                        Icons.sports_cricket, 'Wickets', 'Alert when a wicket falls'),
                    const SizedBox(height: AppSpacing.sm),
                    _toggle(context, controller, SettingsKeys.boundaries,
                        Icons.grid_view, 'Boundaries', 'Fours and sixes'),
                    const SizedBox(height: AppSpacing.sm),
                    _toggle(context, controller, SettingsKeys.results,
                        Icons.emoji_events_outlined, 'Match results', 'Innings and match outcomes'),
                    const SizedBox(height: AppSpacing.sm),
                    _toggle(context, controller, SettingsKeys.news,
                        Icons.article_outlined, 'Cricket news', 'New stories in your feed'),
                    const SizedBox(height: AppSpacing.sm),
                    _toggle(context, controller, SettingsKeys.dailyDigest,
                        Icons.summarize_outlined, 'Daily digest', 'One summary per day'),
                  ],
                ),
            const SizedBox(height: AppSpacing.md),
            Obx(() => SwitchTile(
                  icon: Icons.nightlight_round,
                  title: 'Quiet hours',
                  subtitle: 'Pause non-critical alerts overnight',
                  value: controller.quietHours.value,
                  onChanged: controller.setQuietHours,
                )),
            const SizedBox(height: AppSpacing.md),
            _SummaryCard(controller: controller),
          ],
        ),
      );

  Widget _toggle(BuildContext context, SettingsController controller, String key,
          IconData icon, String title, String subtitle) =>
      Obx(() => SwitchTile(
            icon: icon,
            title: title,
            subtitle: subtitle,
            value: controller.isEnabled(key),
            onChanged: (value) => controller.setNotification(key, value),
          ));
}

class _SummaryCard extends StatelessWidget {
  final SettingsController controller;

  const _SummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
        final enabled = <String>[];
        if (controller.isEnabled(SettingsKeys.liveScores)) enabled.add('live scores');
        if (controller.isEnabled(SettingsKeys.wickets)) enabled.add('wickets');
        if (controller.isEnabled(SettingsKeys.boundaries)) enabled.add('boundaries');
        if (controller.isEnabled(SettingsKeys.results)) enabled.add('results');
        if (controller.isEnabled(SettingsKeys.news)) enabled.add('news');
        if (controller.isEnabled(SettingsKeys.dailyDigest)) enabled.add('daily digest');
        return Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alert summary', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  enabled.isEmpty ? 'No alerts enabled.' : 'Enabled: ${enabled.join(', ')}.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (controller.quietHours.value) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text('Quiet hours are on.',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
        );
      });
}
