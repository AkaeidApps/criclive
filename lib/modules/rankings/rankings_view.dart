import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/state_widgets.dart';
import '../../data/models/ranking.dart';
import 'rankings_controller.dart';

class RankingsView extends StatelessWidget {
  const RankingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = provide(() => RankingsController(), tag: 'rankings');
    return AppScaffold(
      title: 'ICC Rankings',
      subtitle: 'Demo ratings · not official ICC rankings',
      body: Obx(() {
        if (controller.state.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.state.value.hasError) {
          return ErrorView(
            message: 'Demo rankings could not be loaded.',
            onRetry: controller.load,
          );
        }
        final board = controller.current;
        if (board == null) {
          return const EmptyView(
            icon: Icons.leaderboard_outlined,
            title: 'No rankings',
            message: 'Demo rankings are not available right now.',
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                      children: RankingCategory.values.map((value) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: PillChip(
                            label: value.label,
                            selected: controller.category.value == value,
                            onTap: () => controller.category.value = value,
                          ),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.leaderboard,
                              size: 18, color: AppColors.green),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(board.title,
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(board.subtitle,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Column(
                  children: board.entries.map((entry) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                          leading: Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: entry.rank == 1
                                  ? AppColors.softAccent
                                  : AppColors.softGreen,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: Text('${entry.rank}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: entry.rank == 1
                                        ? const Color(0xFF8A6A00)
                                        : AppColors.darkGreen)),
                          ),
                          title: Text(entry.name,
                              style: Theme.of(context).textTheme.titleSmall),
                          subtitle: Text('${entry.countryCode} · Rating ${entry.ratingLabel}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _Movement(movement: entry.movement),
                              const SizedBox(width: AppSpacing.md),
                              Text(entry.ratingLabel,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.green,
                                      )),
                            ],
                          ),
                          onTap: () => _openEntry(entry),
                        ),
                        if (entry != board.entries.last)
                          Divider(height: 1, color: Theme.of(context).dividerColor),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Text(
                    'Ratings shown are fictional demo values used to exercise the interface. '
                    'They are not official ICC rankings.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _openEntry(RankingEntry entry) {
    if (entry.playerId != null) {
      Get.toNamed(AppRoutes.player(entry.playerId!));
    } else if (entry.teamId != null) {
      Get.toNamed(AppRoutes.team(entry.teamId!));
    }
  }
}

class _Movement extends StatelessWidget {
  final int movement;

  const _Movement({required this.movement});

  @override
  Widget build(BuildContext context) {
    if (movement == 0) {
      return Icon(Icons.remove, size: 14, color: AppColors.secondary);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(movement > 0 ? Icons.arrow_upward : Icons.arrow_downward,
            size: 13,
            color: movement > 0 ? AppColors.green : AppColors.live),
        Text('${movement.abs()}',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: movement > 0 ? AppColors.green : AppColors.live)),
      ],
    );
  }
}
