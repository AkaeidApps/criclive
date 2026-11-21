import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/constants/demo_config.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/data_table_widgets.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import '../../core/widgets/team_crest.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../match_center/match_center_controller.dart';

class MatchInfoView extends StatelessWidget {
  final String matchId;

  const MatchInfoView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => MatchCenterController(matchId: matchId),
      tag: matchId,
    );
    return AppScaffold(
      title: 'Match Information',
      subtitle: controller.match.value?.title ?? 'Demo match',
      body: Obx(() {
        if (controller.state.value.isLoading) return const ListSkeleton(count: 4);
        if (controller.state.value.hasError) {
          return ErrorView(
              message: controller.errorMessage.value, onRetry: controller.load);
        }
        final match = controller.match.value;
        if (match == null) {
          return const EmptyView(
            icon: Icons.info_outline,
            title: 'Information unavailable',
            message: 'This demo fixture has no stored match information.',
          );
        }
        final playerRepo = Get.find<PlayerRepository>();
        final teamRepo = Get.find<TeamRepository>();
        return ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Venue & conditions',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.md),
                    InfoRow(label: 'Ground', value: match.venue),
                    InfoRow(label: 'City', value: match.city),
                    InfoRow(label: 'Format', value: match.format.label),
                    InfoRow(label: 'Match', value: match.round),
                    InfoRow(label: 'Start time', value: match.startTimeLabel),
                    InfoRow(label: 'Toss', value: match.toss),
                    if (match.resultText != null)
                      InfoRow(label: 'Result', value: match.resultText!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Series',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(match.seriesName,
                          style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text('Tap to view series details'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.toNamed(AppRoutes.series(match.seriesId)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...match.teamIds.map((teamId) {
              final team = teamRepo.cached(teamId);
              final squad = match.playingXIs[teamId] ?? const <String>[];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Card(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TeamCrest(team: team, size: 34),
                            const SizedBox(width: AppSpacing.sm),
                            Text('${team?.shortName ?? teamId} · Playing XI',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (squad.isEmpty)
                          Text('Playing XI not available for this demo fixture.',
                              style: Theme.of(context).textTheme.bodySmall)
                        else
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: squad.map((id) {
                              final player = playerRepo.cached(id);
                              return ActionChip(
                                avatar: const Icon(Icons.person_outline, size: 14),
                                label: Text(player?.name ?? id),
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.player(id)),
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Officials',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    ...match.umpires.map(
                      (umpire) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text('• $umpire',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Data provenance',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text(DemoConfig.dataDisclosure,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Last updated: ${AppFormatters.dateTime(match.lastUpdated)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (match.note != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(match.note!,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
