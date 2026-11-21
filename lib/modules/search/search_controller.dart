import 'dart:async';

import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/repositories/local_repositories.dart';
import '../../data/sources/demo/demo_matches.dart';
import '../../data/sources/demo/demo_news.dart';
import '../../data/sources/demo/demo_players.dart';
import '../../data/sources/demo/demo_series.dart';
import '../../data/sources/demo/demo_teams.dart';

enum SearchResultKind { match, team, player, series, news }

class SearchResult {
  final SearchResultKind kind;
  final String id;
  final String title;
  final String subtitle;

  const SearchResult({
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
  });
}

class SearchController extends GetxController {
  final SettingsRepository _settings;
  Timer? _debounce;

  SearchController({SettingsRepository? settings})
      : _settings = settings ?? Get.find<SettingsRepository>();

  final query = ''.obs;
  final results = <SearchResult>[].obs;
  final recent = <String>[].obs;
  final state = ViewState.initial.obs;

  @override
  void onInit() {
    super.onInit();
    recent.value = _settings.readList(SettingsKeys.recentSearches).take(8).toList();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void onQueryChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      results.clear();
      state.value = ViewState.initial;
      return;
    }
    state.value = ViewState.loading;
    _debounce = Timer(const Duration(milliseconds: 180), () => _performSearch(value.trim()));
  }

  void _performSearch(String term) {
    final lower = term.toLowerCase();
    final found = <SearchResult>[];

    for (final match in demoMatches) {
      if ('${match.title} ${match.round} ${match.seriesName} ${match.venue}'
          .toLowerCase()
          .contains(lower)) {
        found.add(SearchResult(
          kind: SearchResultKind.match,
          id: match.id,
          title: match.title,
          subtitle: '${match.round} · ${match.status.label}',
        ));
      }
    }
    for (final team in demoTeams) {
      if ('${team.name} ${team.abbreviation} ${team.city}'.toLowerCase().contains(lower)) {
        found.add(SearchResult(
          kind: SearchResultKind.team,
          id: team.id,
          title: team.name,
          subtitle: team.international ? 'International team' : 'Domestic franchise',
        ));
      }
    }
    for (final player in demoPlayers) {
      if ('${player.name} ${player.role.label} ${player.teamId}'
          .toLowerCase()
          .contains(lower)) {
        found.add(SearchResult(
          kind: SearchResultKind.player,
          id: player.id,
          title: player.name,
          subtitle: '${player.role.label} · ${player.teamId.toUpperCase()}',
        ));
      }
    }
    for (final series in demoSeries) {
      if ('${series.name} ${series.shortName} ${series.host}'
          .toLowerCase()
          .contains(lower)) {
        found.add(SearchResult(
          kind: SearchResultKind.series,
          id: series.id,
          title: series.name,
          subtitle: '${series.format.label} · ${series.host}',
        ));
      }
    }
    for (final article in demoNews) {
      if ('${article.title} ${article.summary}'.toLowerCase().contains(lower)) {
        found.add(SearchResult(
          kind: SearchResultKind.news,
          id: article.id,
          title: article.title,
          subtitle: '${article.categoryLabel} · ${article.timeLabel}',
        ));
      }
    }

    results.value = found.take(30).toList();
    state.value = found.isEmpty ? ViewState.empty : ViewState.success;
    if (found.isNotEmpty) _saveRecent(term);
  }

  Future<void> _saveRecent(String term) async {
    if (recent.contains(term)) recent.remove(term);
    recent.insert(0, term);
    recent.value = recent.take(8).toList();
    await _settings.writeList(SettingsKeys.recentSearches, recent);
  }

  Future<void> clearRecent() async {
    recent.clear();
    await _settings.writeList(SettingsKeys.recentSearches, const []);
  }

  void useRecent(String value) {
    query.value = value;
    _performSearch(value.toLowerCase());
  }
}
