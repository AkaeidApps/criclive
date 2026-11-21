abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const live = '/matches/live';
  static const upcoming = '/matches/upcoming';
  static const results = '/matches/results';
  static const fixtures = '/fixtures';
  static const points = '/points';

  static const matchCenter = '/match';
  static const scorecard = '/scorecard';
  static const commentary = '/commentary';
  static const overs = '/overs';
  static const matchInfo = '/info';

  static const seriesHub = '/series';
  static const seriesDetail = '/series-detail';
  static const teams = '/teams';
  static const teamDetail = '/team-detail';
  static const players = '/players';
  static const playerDetail = '/player-detail';
  static const statistics = '/statistics';
  static const rankings = '/rankings';

  static const news = '/news';
  static const newsDetail = '/news-detail';
  static const search = '/search';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const notificationSettings = '/settings/notifications';
  static const about = '/about';
  static const more = '/more';

  static String match(String id) => '$matchCenter/$id';
  static String matchScorecard(String id) => '$scorecard/$id';
  static String matchCommentary(String id) => '$commentary/$id';
  static String matchOvers(String id) => '$overs/$id';
  static String matchInfoFor(String id) => '$matchInfo/$id';
  static String series(String id) => '$seriesDetail/$id';
  static String team(String id) => '$teamDetail/$id';
  static String player(String id) => '$playerDetail/$id';
  static String article(String id) => '$newsDetail/$id';
}
