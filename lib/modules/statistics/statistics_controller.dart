import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/statistics.dart';
import '../../data/repositories/cricket_repositories.dart';

class StatisticsController extends GetxController {
  final StatsRepository _repository;

  StatisticsController({StatsRepository? repository})
      : _repository = repository ?? Get.find<StatsRepository>();

  final state = ViewState.initial.obs;
  final category = StatsCategory.batting.obs;
  final format = 'All'.obs;
  final batting = <BattingStatRow>[].obs;
  final bowling = <BowlingStatRow>[].obs;
  final records = <RecordRow>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      final results = await Future.wait([
        _repository.batting(),
        _repository.bowling(),
        _repository.records(),
      ]);
      batting.value = results[0] as List<BattingStatRow>;
      bowling.value = results[1] as List<BowlingStatRow>;
      records.value = results[2] as List<RecordRow>;
      state.value = ViewState.success;
    } catch (error) {
      state.value = ViewState.error;
    }
  }

  List<BattingStatRow> get filteredBatting => format.value == 'All'
      ? batting
      : batting.where((row) => row.format == format.value).toList();

  List<BowlingStatRow> get filteredBowling => format.value == 'All'
      ? bowling
      : bowling.where((row) => row.format == format.value).toList();
}
