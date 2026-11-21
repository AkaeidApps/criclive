import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/state_widgets.dart';
import 'search_controller.dart' as search;

class SearchView extends StatelessWidget {
  final bool embedded;

  const SearchView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = provide(() => search.SearchController(), tag: 'search');
    final textController = TextEditingController(text: controller.query.value);
    return AppScaffold(
      title: 'Search',
      subtitle: 'Matches, teams, players, series and news',
      automaticallyImplyLeading: !embedded,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: textController,
            autofocus: !embedded,
            onChanged: controller.onQueryChanged,
            decoration: const InputDecoration(
              hintText: 'Search “India”, “Mehta”, “T20 World Cup”…',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.tune),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: Obx(() {
              if (controller.state.value == ViewState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.query.value.isEmpty) {
                return _RecentSearches(
                  controller: controller,
                  onTermSelected: (term) {
                    textController.text = term;
                    controller.useRecent(term);
                  },
                );
              }
              if (controller.state.value == ViewState.empty) {
                return EmptyView(
                  icon: Icons.search_off,
                  title: 'No results for “${controller.query.value}”',
                  message: 'Try a team, player, series or match keyword.',
                );
              }
              return ListView.separated(
                itemCount: controller.results.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: AppSpacing.lg),
                itemBuilder: (context, index) {
                  final result = controller.results[index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      child: Icon(_iconFor(result.kind),
                          size: 18,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(result.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(result.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    onTap: () => _open(result),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(search.SearchResultKind kind) => switch (kind) {
        search.SearchResultKind.match => Icons.sports_cricket_outlined,
        search.SearchResultKind.team => Icons.groups_outlined,
        search.SearchResultKind.player => Icons.person_outline,
        search.SearchResultKind.series => Icons.emoji_events_outlined,
        search.SearchResultKind.news => Icons.article_outlined,
      };

  void _open(search.SearchResult result) {
    switch (result.kind) {
      case search.SearchResultKind.match:
        Get.toNamed(AppRoutes.match(result.id));
      case search.SearchResultKind.team:
        Get.toNamed(AppRoutes.team(result.id));
      case search.SearchResultKind.player:
        Get.toNamed(AppRoutes.player(result.id));
      case search.SearchResultKind.series:
        Get.toNamed(AppRoutes.series(result.id));
      case search.SearchResultKind.news:
        Get.toNamed(AppRoutes.article(result.id));
    }
  }
}

class _RecentSearches extends StatelessWidget {
  final search.SearchController controller;
  final ValueChanged<String> onTermSelected;

  const _RecentSearches({
    required this.controller,
    required this.onTermSelected,
  });

  @override
  Widget build(BuildContext context) => Obx(() {
        if (controller.recent.isEmpty) {
          return const EmptyView(
            icon: Icons.history,
            title: 'Start typing to search',
            message: 'Recent searches will be saved locally on this device.',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Recent searches',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                TextButton(
                  onPressed: controller.clearRecent,
                  child: const Text('Clear'),
                ),
              ],
            ),
            Wrap(
              spacing: AppSpacing.sm,
              children: controller.recent
                  .map((term) => InputChip(
                        label: Text(term),
                        onPressed: () => onTermSelected(term),
                      ))
                  .toList(),
            ),
          ],
        );
      });
}
