import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/match.dart';
import '../../data/models/series.dart';
import '../../data/repositories/cricket_repositories.dart';
import '../../data/repositories/match_repository.dart';

class SeriesController extends GetxController {
  final String? seriesId;
  final SeriesRepository _seriesRepository;
  final MatchRepository _matchRepository;

  SeriesController({
    this.seriesId,
    SeriesRepository? seriesRepository,
    MatchRepository? matchRepository,
  })  : _seriesRepository = seriesRepository ?? Get.find<SeriesRepository>(),
        _matchRepository = matchRepository ?? Get.find<MatchRepository>();

  final state = ViewState.initial.obs;
  final all = <Series>[].obs;
  final series = Rxn<Series>();
  final matches = <CricketMatch>[].obs;
  final points = <PointsTable>[].obs;
  final selectedTab = 0.obs;
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
      if (seriesId == null) {
        all.value = await _seriesRepository.all();
      } else {
        final results = await Future.wait([
          _seriesRepository.find(seriesId!),
          _matchRepository.matchesForSeries(seriesId!),
          _seriesRepository.pointsTables(seriesId!),
        ]);
        series.value = results[0] as Series?;
        matches.value = results[1] as List<CricketMatch>;
        points.value = results[2] as List<PointsTable>;
      }
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('RepositoryException: ', '');
      state.value = ViewState.error;
    }
  }
}
