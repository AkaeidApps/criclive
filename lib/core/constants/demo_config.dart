/// Phase 1 configuration. All score data in this build is bundled demo data.
abstract final class DemoConfig {
  static const bool isDemoBuild = true;
  static const String dataDisclosure =
      'DEMO DATA — scores, schedules, players and news are illustrative only. '
      'Real provider integration is planned for Phase 2.';

  /// The UI simulates short async loads so skeletons and pull-to-refresh are
  /// exercised during development. Flip this off in widget tests.
  static Duration networkDelay = const Duration(milliseconds: 260);

  /// Toggled in App Settings to exercise the error/retry UI.
  static bool simulateErrors = false;
}
