import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../modules/about/about_view.dart';
import '../../modules/commentary/commentary_view.dart';
import '../../modules/favorites/favorites_view.dart';
import '../../modules/fixtures/fixtures_view.dart';
import '../../modules/match_info/match_info_view.dart';
import '../../modules/match_center/match_center_view.dart';
import '../../modules/matches/matches_view.dart';
import '../../modules/more/more_view.dart';
import '../../modules/news/news_view.dart';
import '../../modules/overs/overs_view.dart';
import '../../modules/players/players_view.dart';
import '../../modules/points_table/points_table_view.dart';
import '../../modules/rankings/rankings_view.dart';
import '../../modules/scorecard/scorecard_view.dart';
import '../../modules/search/search_view.dart';
import '../../modules/series/series_view.dart';
import '../../modules/settings/settings_view.dart';
import '../../modules/shell/main_shell.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/statistics/statistics_view.dart';
import '../../modules/teams/teams_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static String param(String key) => Get.parameters[key] ?? '';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.home, page: () => const MainShell()),
    GetPage(
      name: AppRoutes.live,
      page: () => const MatchesView(category: MatchCategory.live),
    ),
    GetPage(
      name: AppRoutes.upcoming,
      page: () => const MatchesView(category: MatchCategory.upcoming),
    ),
    GetPage(
      name: AppRoutes.results,
      page: () => const MatchesView(category: MatchCategory.results),
    ),
    GetPage(name: AppRoutes.fixtures, page: () => const FixturesView()),
    GetPage(name: AppRoutes.points, page: () => const PointsTableView()),
    GetPage(name: '${AppRoutes.matchCenter}/:id', page: () => MatchCenterView(matchId: param('id'))),
    GetPage(name: '${AppRoutes.scorecard}/:id', page: () => ScorecardView(matchId: param('id'))),
    GetPage(name: '${AppRoutes.commentary}/:id', page: () => CommentaryView(matchId: param('id'))),
    GetPage(name: '${AppRoutes.overs}/:id', page: () => OversView(matchId: param('id'))),
    GetPage(name: '${AppRoutes.matchInfo}/:id', page: () => MatchInfoView(matchId: param('id'))),
    GetPage(name: AppRoutes.seriesHub, page: () => const SeriesView()),
    GetPage(name: '${AppRoutes.seriesDetail}/:id', page: () => SeriesView(seriesId: param('id'))),
    GetPage(name: AppRoutes.teams, page: () => const TeamsView()),
    GetPage(name: '${AppRoutes.teamDetail}/:id', page: () => TeamsView(teamId: param('id'))),
    GetPage(name: AppRoutes.players, page: () => const PlayersView()),
    GetPage(name: '${AppRoutes.playerDetail}/:id', page: () => PlayersView(playerId: param('id'))),
    GetPage(name: AppRoutes.statistics, page: () => const StatisticsView()),
    GetPage(name: AppRoutes.rankings, page: () => const RankingsView()),
    GetPage(name: AppRoutes.news, page: () => const NewsView()),
    GetPage(name: '${AppRoutes.newsDetail}/:id', page: () => NewsView(articleId: param('id'))),
    GetPage(name: AppRoutes.search, page: () => const SearchView()),
    GetPage(name: AppRoutes.favorites, page: () => const FavoritesView()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsView()),
    GetPage(
      name: AppRoutes.notificationSettings,
      page: () => const SettingsView(showNotifications: true),
    ),
    GetPage(name: AppRoutes.about, page: () => const AboutView()),
    GetPage(name: AppRoutes.more, page: () => const MoreView()),
  ];
}
