import 'package:get/get.dart';

import '../../core/constants/demo_config.dart';
import '../../core/storage/key_value_store.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../../data/repositories/local_repositories.dart';
import '../../data/repositories/match_repository.dart';
import '../../modules/favorites/favorites_controller.dart';
import '../../modules/settings/settings_controller.dart';

/// Registers dependencies used across the whole app. All local-only in Phase 1.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<KeyValueStore>()) {
      Get.put<KeyValueStore>(GetStorageStore(), permanent: true);
    }

    if (!Get.isRegistered<MatchRepository>()) {
      Get.put<MatchRepository>(const MatchRepository(), permanent: true);
    }
    if (!Get.isRegistered<SeriesRepository>()) {
      Get.put<SeriesRepository>(const SeriesRepository(), permanent: true);
    }
    if (!Get.isRegistered<TeamRepository>()) {
      Get.put<TeamRepository>(const TeamRepository(), permanent: true);
    }
    if (!Get.isRegistered<PlayerRepository>()) {
      Get.put<PlayerRepository>(const PlayerRepository(), permanent: true);
    }
    if (!Get.isRegistered<StatsRepository>()) {
      Get.put<StatsRepository>(const StatsRepository(), permanent: true);
    }
    if (!Get.isRegistered<RankingRepository>()) {
      Get.put<RankingRepository>(const RankingRepository(), permanent: true);
    }
    if (!Get.isRegistered<NewsRepository>()) {
      Get.put<NewsRepository>(const NewsRepository(), permanent: true);
    }
    if (!Get.isRegistered<FavoritesRepository>()) {
      Get.put<FavoritesRepository>(
        FavoritesRepository(Get.find<KeyValueStore>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<SettingsRepository>()) {
      Get.put<SettingsRepository>(
        SettingsRepository(Get.find<KeyValueStore>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<SettingsController>()) {
      Get.put(SettingsController(), permanent: true);
    }
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put(FavoritesController(), permanent: true);
    }

    DemoConfig.simulateErrors =
        Get.find<SettingsRepository>().readBool(SettingsKeys.simulateErrors);
  }
}
