import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:criclive/app/app.dart';
import 'package:criclive/core/constants/demo_config.dart';
import 'package:criclive/core/storage/key_value_store.dart';
import 'package:criclive/modules/home/home_controller.dart';

void main() {
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

  testWidgets('splash discloses demo data and navigates to home shell',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CricLiveApp());

    expect(find.textContaining('CRICLIVE'), findsWidgets);
    expect(find.textContaining('DEMO DATA'), findsWidgets);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Matches'), findsWidgets);
    expect(find.textContaining('FEATURED LIVE MATCH'), findsOneWidget);
  });

  testWidgets('home renders live, upcoming and results tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CricLiveApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('LIVE'), findsWidgets);
    expect(find.text('UPCOMING'), findsWidgets);
    expect(find.text('RESULTS'), findsWidgets);
    expect(find.textContaining('Tap a card for the full match centre'),
        findsOneWidget);
  });

  testWidgets('home error state offers a working retry action',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CricLiveApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    DemoConfig.networkDelay = Duration.zero;
    DemoConfig.simulateErrors = true;
    await tester.runAsync(() => Get.find<HomeController>().load());
    await tester.pumpAndSettle();
    expect(find.text("Couldn’t load data"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    DemoConfig.simulateErrors = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.textContaining('FEATURED LIVE MATCH'), findsOneWidget);
  });
}
