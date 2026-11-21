/// Application-wide enums used by models, controllers and widgets.
library;

enum ViewState { initial, loading, success, error, empty }

enum MatchStatus { live, upcoming, completed, delayed, dataUnavailable }

enum MatchFormat { test, odi, t20, firstClass, listA, other }

enum PlayerRole { batter, bowler, allRounder, wicketKeeper }

enum MatchCategory { live, upcoming, results }

enum RankingCategory { batting, bowling, allRounder, teams }

enum StatsCategory { batting, bowling, records }

enum NewsCategory { all, international, domestic, analysis, awards }

enum ThemePreference { light, dark, system }

extension ViewStateX on ViewState {
  bool get isLoading => this == ViewState.loading;
  bool get hasError => this == ViewState.error;
  bool get hasData => this == ViewState.success;
}

extension MatchStatusX on MatchStatus {
  String get label => switch (this) {
        MatchStatus.live => 'LIVE',
        MatchStatus.upcoming => 'UPCOMING',
        MatchStatus.completed => 'COMPLETED',
        MatchStatus.delayed => 'DELAYED',
        MatchStatus.dataUnavailable => 'DATA UNAVAILABLE',
      };

  bool get isLive => this == MatchStatus.live;
  bool get isCompleted => this == MatchStatus.completed;
}

extension MatchFormatX on MatchFormat {
  String get label => switch (this) {
        MatchFormat.test => 'TEST',
        MatchFormat.odi => 'ODI',
        MatchFormat.t20 => 'T20I',
        MatchFormat.firstClass => 'FC',
        MatchFormat.listA => 'LIST A',
        MatchFormat.other => 'OTHER',
      };
}

extension PlayerRoleX on PlayerRole {
  String get label => switch (this) {
        PlayerRole.batter => 'Batter',
        PlayerRole.bowler => 'Bowler',
        PlayerRole.allRounder => 'All-rounder',
        PlayerRole.wicketKeeper => 'Wicketkeeper-batter',
      };
}

extension RankingCategoryX on RankingCategory {
  String get label => switch (this) {
        RankingCategory.batting => 'Batting',
        RankingCategory.bowling => 'Bowling',
        RankingCategory.allRounder => 'All-rounder',
        RankingCategory.teams => 'Teams',
      };
}

extension StatsCategoryX on StatsCategory {
  String get label => switch (this) {
        StatsCategory.batting => 'Batting',
        StatsCategory.bowling => 'Bowling',
        StatsCategory.records => 'Records',
      };
}

extension NewsCategoryX on NewsCategory {
  String get label => switch (this) {
        NewsCategory.all => 'All',
        NewsCategory.international => 'International',
        NewsCategory.domestic => 'Domestic',
        NewsCategory.analysis => 'Analysis',
        NewsCategory.awards => 'Awards',
      };
}

extension ThemePreferenceX on ThemePreference {
  String get label => switch (this) {
        ThemePreference.light => 'Light',
        ThemePreference.dark => 'Dark',
        ThemePreference.system => 'System',
      };
}
