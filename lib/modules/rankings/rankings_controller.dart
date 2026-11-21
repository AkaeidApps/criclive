import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/ranking.dart';
import '../../data/repositories/cricket_repositories.dart';

class RankingsController extends GetxController {
  final RankingRepository _repository;

  RankingsController({RankingRepository? repository})
      : _repository = repository ?? Get.find<RankingRepository>();

  final state = ViewState.initial.obs;
  final boards = <RankingBoard>[].obs;
  final category = RankingCategory.batting.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      boards.value = await _repository.all();
      state.value = ViewState.success;
    } catch (error) {
      state.value = ViewState.error;
    }
  }

  RankingBoard? get current {
    for (final board in boards) {
      if (board.category == category.value) return board;
    }
    return boards.isEmpty ? null : boards.first;
  }
}
