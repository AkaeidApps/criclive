import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/series.dart';
import '../../data/repositories/cricket_repositories.dart';

class PointsTableController extends GetxController {
  final SeriesRepository _repository;

  PointsTableController({SeriesRepository? repository})
      : _repository = repository ?? Get.find<SeriesRepository>();

  final state = ViewState.initial.obs;
  final series = <Series>[].obs;
  final selectedIndex = 0.obs;
  final tables = <PointsTable>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      series.value = await _repository.all();
      await selectSeries(selectedIndex.value);
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString();
      state.value = ViewState.error;
    }
  }

  Future<void> selectSeries(int index) async {
    if (series.isEmpty) return;
    selectedIndex.value = index;
    tables.value = await _repository.pointsTables(series[index].id);
  }
}
