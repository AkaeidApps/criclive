import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/match.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../../data/repositories/local_repositories.dart';
import '../../data/repositories/match_repository.dart';
import '../favorites/favorites_controller.dart';

class MatchListController extends GetxController {
  final MatchCategory category;
  final MatchRepository _repository;
  final FavoritesController _favorites;

  MatchListController({
    required this.category,
    MatchRepository? repository,
    FavoritesController? favorites,
  })  : _repository = repository ?? Get.find<MatchRepository>(),
        _favorites = favorites ?? Get.find<FavoritesController>();

  final state = ViewState.initial.obs;
  final matches = <CricketMatch>[].obs;
  final errorMessage = ''.obs;
  final filter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    errorMessage.value = '';
    try {
      final result = switch (category) {
        MatchCategory.live => await _repository.liveMatches(),
        MatchCategory.upcoming => await _repository.upcomingMatches(),
        MatchCategory.results => await _repository.recentResults(),
      };
      matches.value = result;
      state.value = result.isEmpty ? ViewState.empty : ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('RepositoryException: ', '');
      state.value = ViewState.error;
    }
  }

  List<CricketMatch> get filteredMatches {
    if (filter.value == 'All') return matches;
    return matches.where((match) {
      return switch (filter.value) {
        'International' => _isInternational(match),
        'Domestic' => !_isInternational(match),
        'T20' => match.format == MatchFormat.t20,
        'ODI' => match.format == MatchFormat.odi,
        'Test' => match.format == MatchFormat.test,
        _ => true,
      };
    }).toList();
  }

  bool _isInternational(CricketMatch match) {
    final repository = Get.isRegistered<TeamRepository>()
        ? Get.find<TeamRepository>()
        : const TeamRepository();
    return match.teamIds.any((id) {
      final team = repository.cached(id);
      return team?.international ?? false;
    });
  }

  bool isFavorite(String id) =>
      _favorites.isFavorite(FavoriteKind.match, id);

  Future<void> toggleFavorite(String id) =>
      _favorites.toggle(FavoriteKind.match, id);

  List<String> get filters => category == MatchCategory.results
      ? const ['All', 'International', 'Domestic', 'T20', 'ODI', 'Test']
      : const ['All', 'International', 'Domestic', 'T20', 'ODI'];
}
