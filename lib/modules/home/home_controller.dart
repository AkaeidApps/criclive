import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/match.dart';
import '../../data/models/series.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../../data/repositories/local_repositories.dart';
import '../../data/repositories/match_repository.dart';
import '../favorites/favorites_controller.dart';

class HomeController extends GetxController {
  final MatchRepository _matches;
  final SeriesRepository _series;
  final TeamRepository _teams;
  final FavoritesController _favorites;

  HomeController({
    MatchRepository? matches,
    SeriesRepository? series,
    TeamRepository? teams,
    FavoritesController? favorites,
  })  : _matches = matches ?? Get.find<MatchRepository>(),
        _series = series ?? Get.find<SeriesRepository>(),
        _teams = teams ?? Get.find<TeamRepository>(),
        _favorites = favorites ?? Get.find<FavoritesController>();

  final state = ViewState.initial.obs;
  final selectedTab = 0.obs;
  final live = <CricketMatch>[].obs;
  final upcoming = <CricketMatch>[].obs;
  final results = <CricketMatch>[].obs;
  final series = <Series>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    errorMessage.value = '';
    try {
      final results = await Future.wait([
        _matches.liveMatches(),
        _matches.upcomingMatches(),
        _matches.recentResults(),
        _series.all(),
      ]);
      live.value = results[0] as List<CricketMatch>;
      upcoming.value = results[1] as List<CricketMatch>;
      this.results.value = results[2] as List<CricketMatch>;
      series.value = results[3] as List<Series>;
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('RepositoryException: ', '');
      state.value = ViewState.error;
    }
  }

  List<CricketMatch> get visibleMatches => switch (selectedTab.value) {
        0 => live,
        1 => upcoming,
        _ => results,
      };

  bool isInternational(String teamId) =>
      _teams.cached(teamId)?.international ?? false;

  bool isFavorite(String id) => _favorites.isFavorite(FavoriteKind.match, id);

  Future<void> toggleFavorite(String id) =>
      _favorites.toggle(FavoriteKind.match, id);
}
