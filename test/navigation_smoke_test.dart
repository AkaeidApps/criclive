import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:criclive/app/app.dart';
import 'package:criclive/app/routes/app_routes.dart';
import 'package:criclive/core/constants/demo_config.dart';
import 'package:criclive/core/storage/key_value_store.dart';

void main() {
  const routes = <String>[
    AppRoutes.home,
    AppRoutes.live,
    AppRoutes.upcoming,
    AppRoutes.results,
    AppRoutes.fixtures,
    AppRoutes.points,
    '${AppRoutes.matchCenter}/m_live_ind_aus',
    '${AppRoutes.scorecard}/m_live_ind_aus',
    '${AppRoutes.commentary}/m_live_ind_aus',
    '${AppRoutes.overs}/m_live_ind_aus',
    '${AppRoutes.matchInfo}/m_live_ind_aus',
    AppRoutes.seriesHub,
    '${AppRoutes.seriesDetail}/s_t20_world_cup',
    AppRoutes.teams,
    '${AppRoutes.teamDetail}/ind',
    AppRoutes.players,
    '${AppRoutes.playerDetail}/p_aarav_mehta',
    AppRoutes.statistics,
    AppRoutes.rankings,
    AppRoutes.news,
    '${AppRoutes.newsDetail}/n_1',
    AppRoutes.search,
    AppRoutes.favorites,
    AppRoutes.settings,
    AppRoutes.notificationSettings,
    AppRoutes.about,
    AppRoutes.more,
  ];

  setUp(() {
    Get.reset();
    DemoConfig.networkDelay = Duration.zero;
    DemoConfig.simulateErrors = false;
    Get.put<KeyValueStore>(InMemoryStore(), permanent: true);
  });

  tearDown(() {
    DemoConfig.networkDelay = const Duration(milliseconds: 260);
    Get.reset();
  });

  for (final size in <Size>[
    const Size(390, 844),
    const Size(900, 700),
    const Size(1440, 900),
  ]) {
    testWidgets('all routes render at ${size.width.toInt()}x${size.height.toInt()}',
        (WidgetTester tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const CricLiveApp());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final failures = <String>[];
      for (final route in routes) {
        Get.offNamed(route);
        await tester.pumpAndSettle();
        final error = tester.takeException();
        if (error != null) failures.add('$route -> $error');
      }
      if (failures.isNotEmpty) {
        // ignore: avoid_print
        print('ROUTE FAILURES @ ${size.width.toInt()}:\n${failures.join('\n')}');
      }
      expect(failures, isEmpty);
    });
  }
}
