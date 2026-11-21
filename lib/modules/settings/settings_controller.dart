import 'package:get/get.dart';

import '../../core/constants/demo_config.dart';
import '../../core/enums/app_enums.dart';
import '../../data/repositories/local_repositories.dart';

class SettingsController extends GetxController {
  final SettingsRepository _repository;

  SettingsController({SettingsRepository? repository})
      : _repository = repository ?? Get.find<SettingsRepository>();

  final themePreference = ThemePreference.light.obs;
  final refreshSeconds = 30.obs;
  final dataSaver = false.obs;
  final simulateErrors = false.obs;
  final quietHours = false.obs;
  final notifications = <String, bool>{}.obs;

  static const Map<String, bool> _notificationDefaults = {
    SettingsKeys.liveScores: true,
    SettingsKeys.wickets: true,
    SettingsKeys.boundaries: false,
    SettingsKeys.results: true,
    SettingsKeys.news: false,
    SettingsKeys.dailyDigest: false,
  };

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    themePreference.value = _repository.themePreference;
    refreshSeconds.value = _repository.readInt(SettingsKeys.refreshInterval, fallback: 30);
    dataSaver.value = _repository.readBool(SettingsKeys.dataSaver);
    simulateErrors.value = _repository.readBool(SettingsKeys.simulateErrors);
    quietHours.value = _repository.readBool(SettingsKeys.quietHours);
    notifications.addAll({
      for (final entry in _notificationDefaults.entries)
        entry.key: _repository.readBool(entry.key, fallback: entry.value),
    });
    _applyDemoConfig();
  }

  void _applyDemoConfig() {
    DemoConfig.simulateErrors = simulateErrors.value;
    DemoConfig.networkDelay = dataSaver.value
        ? const Duration(milliseconds: 80)
        : const Duration(milliseconds: 260);
  }

  bool isEnabled(String key) => notifications[key] ?? _notificationDefaults[key] ?? false;

  Future<void> setTheme(ThemePreference preference) async {
    themePreference.value = preference;
    await _repository.setThemePreference(preference);
  }

  Future<void> setRefreshSeconds(int seconds) async {
    refreshSeconds.value = seconds;
    await _repository.writeInt(SettingsKeys.refreshInterval, seconds);
  }

  Future<void> setDataSaver(bool value) async {
    dataSaver.value = value;
    await _repository.writeBool(SettingsKeys.dataSaver, value);
    _applyDemoConfig();
  }

  Future<void> setSimulateErrors(bool value) async {
    simulateErrors.value = value;
    await _repository.writeBool(SettingsKeys.simulateErrors, value);
    _applyDemoConfig();
  }

  Future<void> setQuietHours(bool value) async {
    quietHours.value = value;
    await _repository.writeBool(SettingsKeys.quietHours, value);
  }

  Future<void> setNotification(String key, bool value) async {
    notifications[key] = value;
    await _repository.writeBool(key, value);
  }

  Future<void> resetAll() async {
    await _repository.clearPreferences();
    load();
  }
}
