import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/player.dart';
import '../../data/repositories/cricket_repositories.dart';

class PlayersController extends GetxController {
  final String? playerId;
  final PlayerRepository _repository;

  PlayersController({this.playerId, PlayerRepository? repository})
      : _repository = repository ?? Get.find<PlayerRepository>();

  final state = ViewState.initial.obs;
  final players = <Player>[].obs;
  final player = Rxn<Player>();
  final filter = 'All'.obs;
  final selectedFormat = 'T20I'.obs;
  final errorMessage = ''.obs;

  static const filters = ['All', 'Batter', 'Bowler', 'All-rounder', 'Wicketkeeper'];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      if (playerId == null) {
        players.value = await _repository.all();
      } else {
        player.value = await _repository.find(playerId!);
      }
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString();
      state.value = ViewState.error;
    }
  }

  List<Player> get filtered {
    if (filter.value == 'All') return players;
    return players.where((item) {
      return switch (filter.value) {
        'Batter' => item.role == PlayerRole.batter,
        'Bowler' => item.role == PlayerRole.bowler,
        'All-rounder' => item.role == PlayerRole.allRounder,
        'Wicketkeeper' => item.role == PlayerRole.wicketKeeper,
        _ => true,
      };
    }).toList();
  }
}
