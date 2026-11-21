import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/match.dart';
import '../../data/models/player.dart';
import '../../data/models/team.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../../data/repositories/match_repository.dart';

class TeamsController extends GetxController {
  final String? teamId;
  final TeamRepository _teamRepository;
  final PlayerRepository _playerRepository;
  final MatchRepository _matchRepository;

  TeamsController({
    this.teamId,
    TeamRepository? teamRepository,
    PlayerRepository? playerRepository,
    MatchRepository? matchRepository,
  })  : _teamRepository = teamRepository ?? Get.find<TeamRepository>(),
        _playerRepository = playerRepository ?? Get.find<PlayerRepository>(),
        _matchRepository = matchRepository ?? Get.find<MatchRepository>();

  final state = ViewState.initial.obs;
  final teams = <Team>[].obs;
  final team = Rxn<Team>();
  final squad = <Player>[].obs;
  final matches = <CricketMatch>[].obs;
  final selectedGroup = 'International'.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      if (teamId == null) {
        teams.value = await _teamRepository.all();
      } else {
        final results = await Future.wait([
          _teamRepository.find(teamId!),
          _playerRepository.forTeam(teamId!),
          _matchRepository.allMatches(),
        ]);
        team.value = results[0] as Team?;
        squad.value = results[1] as List<Player>;
        final allMatches = results[2] as List<CricketMatch>;
        matches.value = allMatches
            .where((match) => match.teamIds.contains(teamId))
            .toList();
      }
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString();
      state.value = ViewState.error;
    }
  }

  List<Team> get filteredTeams {
    if (selectedGroup.value == 'All') return teams;
    final international = selectedGroup.value == 'International';
    return teams.where((team) => team.international == international).toList();
  }
}
