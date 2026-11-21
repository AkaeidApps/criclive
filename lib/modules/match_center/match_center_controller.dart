import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/ball_event.dart';
import '../../data/models/innings.dart';
import '../../data/models/match.dart';
import '../../data/repositories/local_repositories.dart';
import '../../data/repositories/match_repository.dart';
import '../favorites/favorites_controller.dart';

class MatchCenterController extends GetxController {
  final String matchId;
  final MatchRepository _repository;
  final FavoritesController _favorites;

  MatchCenterController({
    required this.matchId,
    MatchRepository? repository,
    FavoritesController? favorites,
  })  : _repository = repository ?? Get.find<MatchRepository>(),
        _favorites = favorites ?? Get.find<FavoritesController>();

  final state = ViewState.initial.obs;
  final match = Rxn<CricketMatch>();
  final selectedInningsIndex = 0.obs;
  final tabIndex = 0.obs;
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
      final result = await _repository.match(matchId);
      if (result == null) {
        errorMessage.value = 'Demo match not found for id: $matchId';
        state.value = ViewState.error;
        return;
      }
      match.value = result;
      selectedInningsIndex.value = result.currentInningsIndex;
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('RepositoryException: ', '');
      state.value = ViewState.error;
    }
  }

  Innings? get selectedInnings {
    final value = match.value;
    if (value == null || value.innings.isEmpty) return null;
    final index = selectedInningsIndex.value.clamp(0, value.innings.length - 1);
    return value.innings[index];
  }

  List<Innings> get innings => match.value?.innings ?? const [];

  List<BallEvent> get selectedBalls {
    final inning = selectedInnings;
    final value = match.value;
    if (inning == null || value == null) return const [];
    return value.commentary.where((ball) => ball.inningsId == inning.id).toList();
  }

  List<OverSummary> get selectedOvers {
    final inning = selectedInnings;
    final value = match.value;
    if (inning == null || value == null) return const [];
    return value.overs.where((over) => over.teamId == inning.battingTeamId).toList();
  }

  String get crrLabel => selectedInnings?.runRateLabel ?? '0.00';

  String? get rrrLabel => match.value?.requiredRunRateLabel;

  String? get targetLabel => match.value?.target?.toString();

  String? get partnershipLabel {
    final partnership = selectedInnings?.currentPartnership;
    if (partnership == null) return null;
    return '${partnership.runs} (${partnership.balls})';
  }

  bool get isFavorite => _favorites.isFavorite(FavoriteKind.match, matchId);

  Future<void> toggleFavorite() =>
      _favorites.toggle(FavoriteKind.match, matchId);
}
