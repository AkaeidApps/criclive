import '../../../core/enums/app_enums.dart';
import '../../models/news.dart';

/// BUNDLED DEMO DATA — fictional editorial content for UI demonstration.
final List<NewsArticle> demoNews = [
  NewsArticle(
    id: 'n_1',
    title: 'Mehta and Kapoor steer India to a thrilling chase in Mumbai',
    summary:
        'A calculated chase in the final overs kept the hosts in contention in the Super 8 stage.',
    category: NewsCategory.international,
    publishedAt: DateTime.now().subtract(const Duration(minutes: 38)),
    source: 'CRICLIVE Demo Desk',
    author: 'Demo Sports Desk',
    readMinutes: 4,
    featured: true,
    body: const [
      'In a demonstration of controlled aggression, India chased down a competitive total with nine balls to spare in this fictional match report.',
      'The opening pair added 52 runs inside six overs before the middle order steadied the innings with a 112-run partnership. The required rate stayed close to ten an over throughout the chase.',
      'The bowlers earlier had restricted the opposition to 167 despite a strong finish. This article is bundled demo content written solely to exercise the news interface.',
    ],
  ),
  NewsArticle(
    id: 'n_2',
    title: 'Tactical preview: the middle-overs battle that could decide the Super 8',
    summary:
        'Spin versus power hitting is set to be the defining contest in the next round of fixtures.',
    category: NewsCategory.analysis,
    publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
    source: 'CRICLIVE Demo Desk',
    author: 'Demo Analyst',
    readMinutes: 6,
    body: const [
      'The middle ten overs have decided the majority of fictional matches in this demo tournament.',
      'Teams with two quality spinners have consistently kept run rates below eight, forcing batters to take risks against the new ball later on.',
      'This is illustrative analysis for the UI and is not based on real match data.',
    ],
  ),
  NewsArticle(
    id: 'n_3',
    title: 'Continental Premier League: Blazers hold top spot after late surge',
    summary:
        'A strong run with the bat has pushed the Blazers clear at the top of the demo league table.',
    category: NewsCategory.domestic,
    publishedAt: DateTime.now().subtract(const Duration(hours: 7)),
    source: 'CRICLIVE Demo Desk',
    author: 'Demo League Desk',
    readMinutes: 3,
    body: const [
      'The Bengaluru Blazers have won nine of their twelve fictional league matches.',
      'Their bowlers have defended totals with discipline, recording the best net run rate in the table.',
      'All franchises and results in this article are entirely fictional demo content.',
    ],
  ),
  NewsArticle(
    id: 'n_4',
    title: 'Five rising players to watch in the second half of the season',
    summary:
        'A look at the young batters and bowlers who have impressed in the bundled demo fixtures.',
    category: NewsCategory.awards,
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    source: 'CRICLIVE Demo Desk',
    author: 'Demo Features',
    readMinutes: 5,
    body: const [
      'A number of emerging names have made an impact in the fictional fixtures bundled with this app.',
      'Siddharth Jain has taken wickets at an excellent economy while Devansh Sharma has provided quick runs in the middle order.',
      'This is demo editorial content and does not represent real player achievements.',
    ],
  ),
  NewsArticle(
    id: 'n_5',
    title: 'Test championship race tightens after Cape Town draw',
    summary:
        'Points remain finely balanced in the demo World Test Championship standings.',
    category: NewsCategory.international,
    publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    source: 'CRICLIVE Demo Desk',
    author: 'Demo Sports Desk',
    readMinutes: 4,
    body: const [
      'A rain-affected fictional Test in Cape Town ended in a draw, leaving both sides level on points.',
      'The championship table remains one of the closest in this demo season.',
      'No real match is referenced in this article.',
    ],
  ),
  NewsArticle(
    id: 'n_6',
    title: 'Why the death overs have become the most valuable phase',
    summary:
        'Data from the demo fixtures shows how the final four overs swing outcomes.',
    category: NewsCategory.analysis,
    publishedAt: DateTime.now().subtract(const Duration(days: 3)),
    source: 'CRICLIVE Demo Desk',
    author: 'Demo Analyst',
    readMinutes: 7,
    body: const [
      'In the bundled demo dataset, teams that scored above 45 runs in the final four overs won a large share of matches.',
      'Bowlers with a reliable yorker conceded fewer boundaries and regularly dismissed set batters.',
      'The numbers are illustrative and were created for interface demonstration only.',
    ],
  ),
];

NewsArticle? findDemoArticle(String id) {
  for (final article in demoNews) {
    if (article.id == id) return article;
  }
  return null;
}
