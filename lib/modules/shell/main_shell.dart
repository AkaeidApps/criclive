import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/responsive.dart';
import '../favorites/favorites_view.dart';
import '../home/home_view.dart';
import '../matches/matches_view.dart';
import '../more/more_view.dart';
import '../search/search_view.dart';
import 'shell_controller.dart';

/// Responsive root navigation: bottom bar on mobile, rail on larger screens.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = provide(() => ShellController(), tag: 'root');

    final views = <Widget>[
      const HomeView(embedded: true),
      const MatchesView(embedded: true),
      const SearchView(embedded: true),
      const FavoritesView(embedded: true),
      const MoreView(embedded: true),
    ];

    return Scaffold(
      body: isDesktop(context)
          ? Row(
              children: [
                Obx(() => NavigationRail(
                      selectedIndex: controller.index.value,
                      onDestinationSelected: controller.select,
                      labelType: NavigationRailLabelType.all,
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 8),
                        child: Icon(Icons.sports_cricket_rounded,
                            color: AppColors.green, size: 30),
                      ),
                      destinations: const [
                        NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Home')),
                        NavigationRailDestination(
                            icon: Icon(Icons.sports_cricket_outlined),
                            label: Text('Matches')),
                        NavigationRailDestination(
                            icon: Icon(Icons.search_outlined),
                            label: Text('Search')),
                        NavigationRailDestination(
                            icon: Icon(Icons.star_border_outlined),
                            selectedIcon: Icon(Icons.star),
                            label: Text('Favorites')),
                        NavigationRailDestination(
                            icon: Icon(Icons.apps_outlined),
                            label: Text('More')),
                      ],
                    )),
                const VerticalDivider(width: 1),
                Expanded(child: Obx(() => IndexedStack(
                      index: controller.index.value,
                      children: views,
                    ))),
              ],
            )
          : Obx(() => IndexedStack(
                index: controller.index.value,
                children: views,
              )),
      bottomNavigationBar: isDesktop(context)
          ? null
          : Obx(() => NavigationBar(
                selectedIndex: controller.index.value,
                onDestinationSelected: controller.select,
                destinations: const <NavigationDestination>[
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home'),
                  NavigationDestination(
                      icon: Icon(Icons.sports_cricket_outlined),
                      label: 'Matches'),
                  NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
                  NavigationDestination(
                      icon: Icon(Icons.star_border_outlined),
                      selectedIcon: Icon(Icons.star),
                      label: 'Favorites'),
                  NavigationDestination(
                      icon: Icon(Icons.apps_outlined), label: 'More'),
                ],
              )),
    );
  }
}
