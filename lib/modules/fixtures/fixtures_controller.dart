import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/match.dart';
import '../../data/repositories/match_repository.dart';

class FixturesController extends GetxController {
  final MatchRepository _repository;

  FixturesController({MatchRepository? repository})
      : _repository = repository ?? Get.find<MatchRepository>();

  final state = ViewState.initial.obs;
  final matches = <CricketMatch>[].obs;
  final filter = 'All'.obs;
  final errorMessage = ''.obs;

  static const filters = ['All', 'International', 'Domestic', 'T20', 'ODI', 'Test'];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      matches.value = await _repository.allMatches();
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString();
      state.value = ViewState.error;
    }
  }

  List<CricketMatch> get filtered {
    final all = matches;
    if (filter.value == 'All') return all;
    return all.where((match) {
      return switch (filter.value) {
        'T20' => match.format == MatchFormat.t20,
        'ODI' => match.format == MatchFormat.odi,
        'Test' => match.format == MatchFormat.test,
        'Domestic' => match.teamIds.any((id) => id == 'blz' ||
            id == 'chn' || id == 'mum' || id == 'del' || id == 'kol' || id == 'hyd'),
        'International' => !['blz', 'chn', 'mum', 'del', 'kol', 'hyd']
            .any((id) => match.teamIds.contains(id)),
        _ => true,
      };
    }).toList();
  }

  Map<DateTime, List<CricketMatch>> get grouped {
    final result = <DateTime, List<CricketMatch>>{};
    for (final match in filtered) {
      final key = DateTime(match.startTime.year, match.startTime.month, match.startTime.day);
      result.putIfAbsent(key, () => []).add(match);
    }
    return result;
  }
}
