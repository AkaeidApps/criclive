import '../../../core/enums/app_enums.dart';
import '../../models/ball_event.dart';
import '../../models/innings.dart';
import '../../models/match.dart';
import '../../models/team.dart';
import 'demo_teams.dart';

/// BUNDLED DEMO DATA — fictional scores, players and commentary.
/// No value in this file came from a live provider. Never label it as real.
final DateTime demoReferenceTime = DateTime.now();

DateTime _ago(Duration duration) => demoReferenceTime.subtract(duration);

DateTime _ahead(Duration duration) => demoReferenceTime.add(duration);

BattingFigure _bat(
  String playerId,
  int runs,
  int balls,
  int fours,
  int sixes,
  String dismissal, [
  bool notOut = false,
  bool onStrike = false,
]) =>
    BattingFigure(
      playerId: playerId,
      runs: runs,
      balls: balls,
      fours: fours,
      sixes: sixes,
      dismissal: dismissal,
      notOut: notOut,
      onStrike: onStrike,
    );

BowlingFigure _bowl(
  String playerId,
  int balls,
  int runs,
  int wickets, [
  int maidens = 0,
  bool bowling = false,
]) =>
    BowlingFigure(
      playerId: playerId,
      balls: balls,
      maidens: maidens,
      runs: runs,
      wickets: wickets,
      bowling: bowling,
    );

typedef _BallSpec = ({int runs, bool wicket, ExtraType extra, String text});

List<BallEvent> _makeBalls({
  required String inningsId,
  required List<String> batters,
  required List<String> bowlers,
  required List<_BallSpec> specs,
  required DateTime startTime,
  int startOver = 0,
  int startBall = 1,
}) {
  var total = 0;
  var wickets = 0;
  final balls = <BallEvent>[];
  for (var i = 0; i < specs.length; i++) {
    final spec = specs[i];
    final rawOver = startOver + ((startBall - 1 + i) ~/ 6);
    final rawBall = ((startBall - 1 + i) % 6) + 1;
    total += spec.runs;
    if (spec.wicket) wickets++;
    balls.add(
      BallEvent(
        id: '${inningsId}_b${i + 1}',
        inningsId: inningsId,
        over: rawOver,
        ballInOver: rawBall,
        runs: spec.runs,
        batterId: batters[i % batters.length],
        bowlerId: bowlers[(rawOver ~/ 3) % bowlers.length],
        extra: spec.extra,
        isWicket: spec.wicket,
        wicketType: spec.wicket ? 'c & b' : null,
        dismissedPlayerId: spec.wicket ? batters[i % batters.length] : null,
        commentary: spec.text,
        timestamp: startTime.add(Duration(minutes: i * 2)),
        totalAfterBall: total,
        wicketsAfterBall: wickets,
      ),
    );
  }
  return balls;
}

List<OverSummary> _makeOvers(String teamId, List<BallEvent> balls) {
  final grouped = <int, List<BallEvent>>{};
  for (final ball in balls) {
    grouped.putIfAbsent(ball.over, () => []).add(ball);
  }
  return grouped.entries
      .map(
        (entry) => OverSummary(
          number: entry.key,
          teamId: teamId,
          runs: entry.value.fold(0, (sum, ball) => sum + ball.runs),
          wickets: entry.value.where((ball) => ball.isWicket).length,
          balls: entry.value,
        ),
      )
      .toList();
}

const _b1 = (
  runs: 1,
  wicket: false,
  extra: ExtraType.none,
  text: 'Pushed to long-on for a single.'
);
const _dot = (
  runs: 0,
  wicket: false,
  extra: ExtraType.none,
  text: 'Dot ball. Good length, beaten the bat.'
);
const _four = (
  runs: 4,
  wicket: false,
  extra: ExtraType.none,
  text: 'FOUR! Leaned into it and found the gap at point.'
);
const _six = (
  runs: 6,
  wicket: false,
  extra: ExtraType.none,
  text: 'SIX! Picked up the length and launched it over deep midwicket.'
);
const _two = (
  runs: 2,
  wicket: false,
  extra: ExtraType.none,
  text: 'Worked into the gap, comfortable two.'
);
const _wd = (
  runs: 1,
  wicket: false,
  extra: ExtraType.wide,
  text: 'Wide down leg side. Extra run added.'
);
_BallSpec _wicket(String name) => (
      runs: 0,
      wicket: true,
      extra: ExtraType.none,
      text: 'WICKET! $name is caught in the deep. Big moment in the game.'
    );

List<_BallSpec> _repeat(int count, _BallSpec spec) =>
    List<_BallSpec>.generate(count, (_) => spec);

// ---------------------------------------------------------------------------
// Featured live match: India vs Australia, 2nd T20I
// ---------------------------------------------------------------------------

final List<BallEvent> _liveIndiaBalls = _makeBalls(
  inningsId: 'm_live_ind_aus_i2',
  batters: const [
    'p_aarav_mehta',
    'p_rohan_kapoor',
    'p_devansh_sharma',
    'p_ishaan_verma',
    'p_kabir_patel',
  ],
  bowlers: const [
    'p_nathan_brooks',
    'p_harry_miller',
    'p_cooper_hayes',
    'p_mitchell_reid',
  ],
  startTime: _ago(const Duration(minutes: 112)),
  specs: [
    _dot, _b1, _four, _dot, _b1, _two, // over 1 - 9 runs
    _b1, _dot, _six, _b1, _dot, _b1, // over 2 - 9 runs
    _four, _b1, _two, _dot, _four, _b1, // over 3 - 12 runs
    _wicket('Devansh Sharma'), _b1, _four, _dot, _b1, _two, // over 4 - 8 runs, 1w
    _wd, _b1, _b1, _dot, _b1, _four, // over 5 - 8 runs
    _dot, _b1, _wicket('Ishaan Verma'), _two, _b1, _dot, // over 6 - 4 runs, 1w
    _b1, _four, _b1, _six, _dot, _b1, // over 7 - 13 runs
    _two, _b1, _dot, _four, _b1, _two, // over 8 - 10 runs
    _wicket('Kabir Patel'), _b1, _dot, _b1, _four, _dot, // over 9 - 6 runs, 1w
    _b1, _six, _dot, _b1, _two, _b1, // over 10 - 11 runs
    _four, _b1, _dot, _b1, _six, _dot, // over 11 - 12 runs
    _b1, _two, _b1, _four, _dot, _b1, // over 12 - 9 runs
    _dot, _b1, _six, _b1, _dot, _two, // over 13 - 10 runs
    _b1, _dot, _b1, _dot, _b1, _b1, // over 14 - 4 runs
    _two, _dot, _four, _b1, _six, _dot, // over 15 - 13 runs
    _b1, _b1, _four, _dot, _two, _b1, // over 16 - 9 runs
    _six, _dot, _b1, _four, _b1, _b1, // over 17 - 13 runs
    ..._repeat(6, _dot), // over 18 - maiden
    _b1, _four, _dot, // over 19 (3 balls) - 5 runs
  ],
);

final List<BallEvent> _liveAustraliaBalls = _makeBalls(
  inningsId: 'm_live_ind_aus_i1',
  batters: const [
    'p_jack_wilson',
    'p_mitchell_reid',
    'p_liam_foster',
    'p_owen_clarke',
    'p_cooper_hayes',
  ],
  bowlers: const [
    'p_arjun_rao',
    'p_nikhil_chaturvedi',
    'p_siddharth_jain',
    'p_kabir_patel',
  ],
  startTime: _ago(const Duration(hours: 3)),
  specs: [
    ..._repeat(24, _b1),
    ..._repeat(12, _four),
    ..._repeat(18, _dot),
    ..._repeat(12, _six),
    ..._repeat(6, _two),
    ..._repeat(6, _wd),
    _wicket('Jack Wilson'),
    _wicket('Liam Foster'),
    _wicket('Owen Clarke'),
    _wicket('Mitchell Reid'),
    _wicket('Cooper Hayes'),
  ],
);

final CricketMatch liveIndiaAustralia = CricketMatch(
  id: 'm_live_ind_aus',
  seriesId: 's_t20_world_cup',
  seriesName: 'ICC Men’s T20 World Cup 2026',
  title: 'India vs Australia',
  round: 'Super 8 · Match 28',
  teamIds: const ['ind', 'aus'],
  status: MatchStatus.live,
  format: MatchFormat.t20,
  venue: 'Wankhede Stadium',
  city: 'Mumbai',
  startTime: _ago(const Duration(hours: 3, minutes: 10)),
  lastUpdated: _ago(const Duration(minutes: 2)),
  statusText: 'India need 3 runs from 9 balls',
  toss: 'Australia won the toss and elected to bat',
  currentInningsIndex: 1,
  innings: [
    Innings(
      id: 'm_live_ind_aus_i1',
      number: 1,
      battingTeamId: 'aus',
      bowlingTeamId: 'ind',
      runs: 167,
      wickets: 5,
      balls: 120,
      batting: [
        _bat('p_jack_wilson', 62, 41, 5, 3, 'c Aarav Mehta b Arjun Rao'),
        _bat('p_mitchell_reid', 38, 28, 3, 2, 'b Siddharth Jain'),
        _bat('p_liam_foster', 21, 14, 1, 2, 'c Ishaan Verma b Kabir Patel'),
        _bat('p_owen_clarke', 14, 10, 2, 0, 'c Rohan Kapoor b Arjun Rao'),
        _bat('p_cooper_hayes', 18, 11, 1, 1, '', true),
        _bat('p_nathan_brooks', 6, 8, 0, 0, '', true),
      ],
      bowling: [
        _bowl('p_arjun_rao', 24, 34, 2),
        _bowl('p_nikhil_chaturvedi', 24, 28, 1),
        _bowl('p_siddharth_jain', 24, 32, 1),
        _bowl('p_kabir_patel', 24, 35, 1),
        _bowl('p_devansh_sharma', 24, 38, 0),
      ],
      extras: const ExtrasFigure(wides: 6, noBalls: 1, byes: 3, legByes: 1),
      fallOfWickets: const [
        FallOfWicket(wicket: 1, score: 78, over: 8, playerId: 'p_jack_wilson'),
        FallOfWicket(wicket: 2, score: 112, over: 12, playerId: 'p_liam_foster'),
        FallOfWicket(wicket: 3, score: 131, over: 15, playerId: 'p_owen_clarke'),
        FallOfWicket(wicket: 4, score: 149, over: 17, playerId: 'p_mitchell_reid'),
        FallOfWicket(wicket: 5, score: 167, over: 20, playerId: 'p_cooper_hayes'),
      ],
      partnerships: const [
        Partnership(
            playerAId: 'p_jack_wilson', playerBId: 'p_mitchell_reid', runs: 78, balls: 48),
        Partnership(
            playerAId: 'p_mitchell_reid', playerBId: 'p_liam_foster', runs: 34, balls: 24),
        Partnership(
            playerAId: 'p_cooper_hayes', playerBId: 'p_nathan_brooks', runs: 18, balls: 11),
      ],
    ),
    Innings(
      id: 'm_live_ind_aus_i2',
      number: 2,
      battingTeamId: 'ind',
      bowlingTeamId: 'aus',
      runs: 165,
      wickets: 3,
      balls: 111,
      target: 168,
      batting: [
        _bat('p_aarav_mehta', 74, 42, 7, 4, '', true, true),
        _bat('p_rohan_kapoor', 38, 31, 3, 1, '', true),
        _bat('p_devansh_sharma', 21, 12, 2, 1, 'c Owen Clarke b Nathan Brooks'),
        _bat('p_ishaan_verma', 8, 6, 1, 0, 'b Nathan Brooks'),
        _bat('p_kabir_patel', 12, 8, 1, 0, '', true),
      ],
      bowling: [
        _bowl('p_nathan_brooks', 24, 31, 2, 0, true),
        _bowl('p_harry_miller', 24, 28, 1),
        _bowl('p_cooper_hayes', 24, 34, 0),
        _bowl('p_mitchell_reid', 21, 29, 0),
        _bowl('p_jack_wilson', 18, 18, 0),
      ],
      extras: const ExtrasFigure(wides: 5, noBalls: 2, byes: 2, legByes: 3),
      fallOfWickets: const [
        FallOfWicket(wicket: 1, score: 52, over: 6, playerId: 'p_devansh_sharma'),
        FallOfWicket(wicket: 2, score: 71, over: 8, playerId: 'p_ishaan_verma'),
      ],
      partnerships: const [
        Partnership(
            playerAId: 'p_aarav_mehta', playerBId: 'p_rohan_kapoor', runs: 112, balls: 71),
      ],
    ),
  ],
  commentary: [
    ..._liveAustraliaBalls.reversed,
    ..._liveIndiaBalls.reversed,
  ],
  overs: _makeOvers('ind', _liveIndiaBalls),
  playingXIs: const {
    'ind': [
      'p_aarav_mehta',
      'p_rohan_kapoor',
      'p_devansh_sharma',
      'p_ishaan_verma',
      'p_kabir_patel',
      'p_arjun_rao',
      'p_nikhil_chaturvedi',
      'p_siddharth_jain',
    ],
    'aus': [
      'p_jack_wilson',
      'p_mitchell_reid',
      'p_liam_foster',
      'p_owen_clarke',
      'p_cooper_hayes',
      'p_nathan_brooks',
      'p_harry_miller',
    ],
  },
  umpires: const ['A. Fernando (DEMO)', 'R. D’Silva (DEMO)'],
  note: 'Illustrative demo score. Not a real live match.',
);

// ---------------------------------------------------------------------------
// Other matches
// ---------------------------------------------------------------------------

final List<BallEvent> _engWiBalls = _makeBalls(
  inningsId: 'm_live_eng_wi_i2',
  batters: const ['p_oliver_bennett', 'p_george_hall', 'p_sam_wright', 'p_henry_ellis'],
  bowlers: const ['p_kemar_johnson', 'p_dwayne_carter'],
  startTime: _ago(const Duration(minutes: 180)),
  specs: [
    ..._repeat(18, _b1),
    ..._repeat(8, _four),
    ..._repeat(6, _dot),
    ..._repeat(3, _two),
    ..._repeat(3, _six),
    _wicket('George Hall'),
  ],
);

final CricketMatch liveEnglandWestIndies = CricketMatch(
  id: 'm_live_eng_wi',
  seriesId: 's_eng_wi_odi',
  seriesName: 'England vs West Indies ODI Series 2026',
  title: 'England vs West Indies',
  round: '3rd ODI',
  teamIds: const ['eng', 'wi'],
  status: MatchStatus.live,
  format: MatchFormat.odi,
  venue: 'Lord’s',
  city: 'London',
  startTime: _ago(const Duration(hours: 5)),
  lastUpdated: _ago(const Duration(minutes: 4)),
  statusText: 'England 178/3 (32.1 overs), need 118 from 107 balls',
  toss: 'West Indies won the toss and elected to bat',
  currentInningsIndex: 1,
  innings: [
    Innings(
      id: 'm_live_eng_wi_i1',
      number: 1,
      battingTeamId: 'wi',
      bowlingTeamId: 'eng',
      runs: 295,
      wickets: 7,
      balls: 300,
      batting: [
        _bat('p_dwayne_carter', 104, 112, 9, 4, 'b James Atkinson'),
        _bat('p_kemar_johnson', 38, 29, 3, 2, 'c Henry Ellis b Tom Osborne'),
        _bat('p_owen_clarke', 42, 55, 4, 0, 'b Sam Wright'),
      ],
      bowling: [
        _bowl('p_james_atkinson', 60, 58, 2),
        _bowl('p_tom_osborne', 60, 62, 1),
        _bowl('p_sam_wright', 60, 55, 2),
      ],
      extras: const ExtrasFigure(wides: 12, noBalls: 2, legByes: 5),
      fallOfWickets: const [
        FallOfWicket(wicket: 1, score: 88, over: 16, playerId: 'p_kemar_johnson'),
        FallOfWicket(wicket: 2, score: 182, over: 34, playerId: 'p_owen_clarke'),
      ],
      partnerships: const [
        Partnership(
            playerAId: 'p_dwayne_carter', playerBId: 'p_kemar_johnson', runs: 88, balls: 96),
      ],
    ),
    Innings(
      id: 'm_live_eng_wi_i2',
      number: 2,
      battingTeamId: 'eng',
      bowlingTeamId: 'wi',
      runs: 178,
      wickets: 3,
      balls: 193,
      target: 296,
      batting: [
        _bat('p_oliver_bennett', 82, 92, 8, 2, '', true, true),
        _bat('p_george_hall', 34, 41, 3, 1, 'c & b Kemar Johnson'),
        _bat('p_sam_wright', 41, 45, 4, 1, '', true),
      ],
      bowling: [
        _bowl('p_kemar_johnson', 60, 55, 2, 0, true),
        _bowl('p_dwayne_carter', 48, 42, 1),
      ],
      extras: const ExtrasFigure(wides: 8, legByes: 3),
      partnerships: const [
        Partnership(
            playerAId: 'p_oliver_bennett', playerBId: 'p_sam_wright', runs: 72, balls: 61),
      ],
    ),
  ],
  commentary: _engWiBalls.reversed.toList(),
  overs: _makeOvers('eng', _engWiBalls),
  playingXIs: const {
    'eng': [
      'p_oliver_bennett',
      'p_george_hall',
      'p_sam_wright',
      'p_henry_ellis',
      'p_james_atkinson',
      'p_tom_osborne',
    ],
    'wi': ['p_dwayne_carter', 'p_kemar_johnson'],
  },
  umpires: const ['M. Collins (DEMO)', 'S. Ali (DEMO)'],
  note: 'Illustrative demo score. Not a real live match.',
);

final CricketMatch _domesticLive = CricketMatch(
  id: 'm_live_blz_chn',
  seriesId: 's_continental_league',
  seriesName: 'Continental Premier League 2026',
  title: 'Bengaluru Blazers vs Chennai Chargers',
  round: 'League Stage · Match 34',
  teamIds: const ['blz', 'chn'],
  status: MatchStatus.live,
  format: MatchFormat.t20,
  venue: 'M. Chinnaswamy Stadium',
  city: 'Bengaluru',
  startTime: _ago(const Duration(hours: 2)),
  lastUpdated: _ago(const Duration(minutes: 1)),
  statusText: 'Blazers 148/4 (14.2 overs)',
  toss: 'Bengaluru Blazers won the toss and elected to bat',
  currentInningsIndex: 0,
  innings: [
    Innings(
      id: 'm_live_blz_chn_i1',
      number: 1,
      battingTeamId: 'blz',
      bowlingTeamId: 'chn',
      runs: 148,
      wickets: 4,
      balls: 86,
      batting: [
        _bat('p_aarav_mehta', 58, 32, 5, 3, 'c Arjun Rao b Siddharth Jain'),
        _bat('p_rohan_kapoor', 39, 27, 3, 1, '', true, true),
        _bat('p_devansh_sharma', 26, 14, 2, 2, '', true),
        _bat('p_kabir_patel', 11, 8, 1, 0, 'b Nikhil Chaturvedi'),
      ],
      bowling: [
        _bowl('p_arjun_rao', 24, 38, 1, 0, true),
        _bowl('p_nikhil_chaturvedi', 24, 29, 1),
        _bowl('p_siddharth_jain', 24, 41, 1),
        _bowl('p_kabir_patel', 14, 28, 0),
      ],
      extras: const ExtrasFigure(wides: 7, noBalls: 3),
      fallOfWickets: const [
        FallOfWicket(wicket: 1, score: 82, over: 9, playerId: 'p_aarav_mehta'),
        FallOfWicket(wicket: 2, score: 112, over: 12, playerId: 'p_kabir_patel'),
      ],
      partnerships: const [
        Partnership(
            playerAId: 'p_rohan_kapoor', playerBId: 'p_devansh_sharma', runs: 36, balls: 22),
      ],
    ),
  ],
  commentary: _liveIndiaBalls.take(30).toList().reversed.toList(),
  overs: _makeOvers('blz', _liveIndiaBalls.take(30).toList()),
  playingXIs: const {
    'blz': ['p_aarav_mehta', 'p_rohan_kapoor', 'p_devansh_sharma', 'p_kabir_patel'],
    'chn': ['p_arjun_rao', 'p_nikhil_chaturvedi', 'p_siddharth_jain'],
  },
  umpires: const ['K. Bharat (DEMO)', 'P. Menon (DEMO)'],
  note: 'Illustrative demo score. Not a real live match.',
);

final List<CricketMatch> _upcomingMatches = [
  CricketMatch(
    id: 'm_up_sa_nz',
    seriesId: 's_test_championship',
    seriesName: 'World Test Championship 2026',
    title: 'South Africa vs New Zealand',
    round: '1st Test · Day 1',
    teamIds: const ['sa', 'nz'],
    status: MatchStatus.upcoming,
    format: MatchFormat.test,
    venue: 'Newlands',
    city: 'Cape Town',
    startTime: _ahead(const Duration(days: 1, hours: 3)),
    lastUpdated: _ago(const Duration(hours: 6)),
    statusText: 'Starts tomorrow, 10:00 local',
    toss: 'Toss yet to take place',
    innings: const [],
    commentary: const [],
    overs: const [],
    playingXIs: const {},
    umpires: const ['To be announced'],
    note: 'Demo fixture. Schedule is illustrative only.',
  ),
  CricketMatch(
    id: 'm_up_pak_sl',
    seriesId: 's_t20_world_cup',
    seriesName: 'ICC Men’s T20 World Cup 2026',
    title: 'Pakistan vs Sri Lanka',
    round: 'Super 8 · Match 31',
    teamIds: const ['pak', 'sl'],
    status: MatchStatus.upcoming,
    format: MatchFormat.t20,
    venue: 'Dubai International Stadium',
    city: 'Dubai',
    startTime: _ahead(const Duration(hours: 9)),
    lastUpdated: _ago(const Duration(hours: 2)),
    statusText: 'Starts today, 19:30 local',
    toss: 'Toss yet to take place',
    innings: const [],
    commentary: const [],
    overs: const [],
    playingXIs: const {},
    umpires: const ['To be announced'],
    note: 'Demo fixture. Schedule is illustrative only.',
  ),
  CricketMatch(
    id: 'm_up_mum_del',
    seriesId: 's_continental_league',
    seriesName: 'Continental Premier League 2026',
    title: 'Mumbai Mavericks vs Delhi Dynamos',
    round: 'League Stage · Match 35',
    teamIds: const ['mum', 'del'],
    status: MatchStatus.upcoming,
    format: MatchFormat.t20,
    venue: 'Wankhede Stadium',
    city: 'Mumbai',
    startTime: _ahead(const Duration(days: 2)),
    lastUpdated: _ago(const Duration(hours: 8)),
    statusText: 'Starts in 2 days, 19:30 local',
    toss: 'Toss yet to take place',
    innings: const [],
    commentary: const [],
    overs: const [],
    playingXIs: const {},
    umpires: const ['To be announced'],
    note: 'Demo fixture. Schedule is illustrative only.',
  ),
];

final CricketMatch _completedIndiaAustralia = CricketMatch(
  id: 'm_res_ind_aus',
  seriesId: 's_t20_world_cup',
  seriesName: 'ICC Men’s T20 World Cup 2026',
  title: 'India vs Australia',
  round: '1st T20I · Match 22',
  teamIds: const ['ind', 'aus'],
  status: MatchStatus.completed,
  format: MatchFormat.t20,
  venue: 'Eden Gardens',
  city: 'Kolkata',
  startTime: _ago(const Duration(days: 2)),
  lastUpdated: _ago(const Duration(days: 2)),
  statusText: 'India won by 7 wickets',
  resultText: 'India won by 7 wickets with 11 balls remaining',
  toss: 'India won the toss and elected to field',
  currentInningsIndex: 1,
  innings: [
    Innings(
      id: 'm_res_ind_aus_i1',
      number: 1,
      battingTeamId: 'aus',
      bowlingTeamId: 'ind',
      runs: 152,
      wickets: 6,
      balls: 120,
      batting: [
        _bat('p_jack_wilson', 48, 36, 4, 2, 'b Arjun Rao'),
        _bat('p_mitchell_reid', 34, 26, 3, 1, 'c Rohan Kapoor b Nikhil Chaturvedi'),
      ],
      bowling: [
        _bowl('p_arjun_rao', 24, 32, 3),
        _bowl('p_nikhil_chaturvedi', 24, 28, 2),
      ],
      fallOfWickets: const [
        FallOfWicket(wicket: 1, score: 72, over: 9, playerId: 'p_jack_wilson'),
      ],
    ),
    Innings(
      id: 'm_res_ind_aus_i2',
      number: 2,
      battingTeamId: 'ind',
      bowlingTeamId: 'aus',
      runs: 156,
      wickets: 3,
      balls: 109,
      target: 153,
      batting: [
        _bat('p_aarav_mehta', 64, 38, 6, 3, 'c Owen Clarke b Harry Miller'),
        _bat('p_rohan_kapoor', 45, 35, 4, 1, '', true, true),
        _bat('p_devansh_sharma', 22, 16, 2, 1, '', true),
      ],
      bowling: [
        _bowl('p_nathan_brooks', 24, 31, 1),
        _bowl('p_harry_miller', 24, 36, 1),
      ],
    ),
  ],
  commentary: _liveIndiaBalls.take(18).toList().reversed.toList(),
  overs: _makeOvers('ind', _liveIndiaBalls.take(18).toList()),
  playingXIs: const {
    'ind': ['p_aarav_mehta', 'p_rohan_kapoor', 'p_devansh_sharma'],
    'aus': ['p_jack_wilson', 'p_mitchell_reid'],
  },
  umpires: const ['A. Fernando (DEMO)', 'R. D’Silva (DEMO)'],
  note: 'Illustrative demo result. Not a real match.',
);

final CricketMatch _completedEngWi = CricketMatch(
  id: 'm_res_eng_wi',
  seriesId: 's_eng_wi_odi',
  seriesName: 'England vs West Indies ODI Series 2026',
  title: 'England vs West Indies',
  round: '2nd ODI',
  teamIds: const ['eng', 'wi'],
  status: MatchStatus.completed,
  format: MatchFormat.odi,
  venue: 'The Oval',
  city: 'London',
  startTime: _ago(const Duration(days: 3)),
  lastUpdated: _ago(const Duration(days: 3)),
  statusText: 'England won by 82 runs',
  resultText: 'England won by 82 runs',
  toss: 'England won the toss and elected to bat',
  currentInningsIndex: 1,
  innings: [
    Innings(
      id: 'm_res_eng_wi_i1',
      number: 1,
      battingTeamId: 'eng',
      bowlingTeamId: 'wi',
      runs: 284,
      wickets: 8,
      balls: 300,
      batting: [
        _bat('p_oliver_bennett', 112, 124, 10, 3, 'b Kemar Johnson'),
        _bat('p_sam_wright', 61, 72, 5, 2, 'c & b Dwayne Carter'),
      ],
      bowling: [
        _bowl('p_kemar_johnson', 60, 62, 3),
        _bowl('p_dwayne_carter', 60, 55, 2),
      ],
    ),
    Innings(
      id: 'm_res_eng_wi_i2',
      number: 2,
      battingTeamId: 'wi',
      bowlingTeamId: 'eng',
      runs: 202,
      wickets: 9,
      balls: 300,
      target: 285,
      batting: [
        _bat('p_dwayne_carter', 68, 81, 6, 2, 'b James Atkinson'),
      ],
      bowling: [
        _bowl('p_james_atkinson', 60, 48, 3),
        _bowl('p_tom_osborne', 60, 52, 2),
      ],
    ),
  ],
  commentary: _engWiBalls.take(14).toList().reversed.toList(),
  overs: _makeOvers('wi', _engWiBalls.take(14).toList()),
  playingXIs: const {
    'eng': ['p_oliver_bennett', 'p_sam_wright', 'p_henry_ellis'],
    'wi': ['p_dwayne_carter', 'p_kemar_johnson'],
  },
  umpires: const ['M. Collins (DEMO)', 'S. Ali (DEMO)'],
  note: 'Illustrative demo result. Not a real match.',
);

final CricketMatch _completedNzBan = CricketMatch(
  id: 'm_res_nz_ban',
  seriesId: 's_odi_series',
  seriesName: 'Tri-Nation ODI Series 2026',
  title: 'New Zealand vs Bangladesh',
  round: 'Final',
  teamIds: const ['nz', 'ban'],
  status: MatchStatus.completed,
  format: MatchFormat.odi,
  venue: 'Eden Park',
  city: 'Auckland',
  startTime: _ago(const Duration(days: 5)),
  lastUpdated: _ago(const Duration(days: 5)),
  statusText: 'New Zealand won by 5 wickets',
  resultText: 'New Zealand won by 5 wickets',
  toss: 'Bangladesh won the toss and elected to bat',
  currentInningsIndex: 1,
  innings: [
    Innings(
      id: 'm_res_nz_ban_i1',
      number: 1,
      battingTeamId: 'ban',
      bowlingTeamId: 'nz',
      runs: 241,
      wickets: 9,
      balls: 300,
      batting: [
        _bat('p_tanvir_ahmed', 44, 52, 4, 1, 'b Finn Harris'),
      ],
      bowling: [
        _bowl('p_finn_harris', 60, 45, 3),
      ],
    ),
    Innings(
      id: 'm_res_nz_ban_i2',
      number: 2,
      battingTeamId: 'nz',
      bowlingTeamId: 'ban',
      runs: 245,
      wickets: 5,
      balls: 282,
      target: 242,
      batting: [
        _bat('p_finn_harris', 88, 102, 8, 2, '', true, true),
      ],
      bowling: [
        _bowl('p_tanvir_ahmed', 60, 58, 2),
      ],
    ),
  ],
  commentary: _engWiBalls.take(12).toList().reversed.toList(),
  overs: _makeOvers('nz', _engWiBalls.take(12).toList()),
  playingXIs: const {
    'nz': ['p_finn_harris'],
    'ban': ['p_tanvir_ahmed'],
  },
  umpires: const ['D. Wilson (DEMO)', 'A. Rahman (DEMO)'],
  note: 'Illustrative demo result. Not a real match.',
);

final List<CricketMatch> demoMatches = [
  liveIndiaAustralia,
  liveEnglandWestIndies,
  _domesticLive,
  ..._upcomingMatches,
  _completedIndiaAustralia,
  _completedEngWi,
  _completedNzBan,
];

List<CricketMatch> demoMatchesByStatus(MatchStatus status) =>
    demoMatches.where((match) => match.status == status).toList();

CricketMatch? findDemoMatch(String id) {
  for (final match in demoMatches) {
    if (match.id == id) return match;
  }
  return null;
}

List<CricketMatch> demoMatchesForSeries(String seriesId) =>
    demoMatches.where((match) => match.seriesId == seriesId).toList();

Team? findTeamForMatch(CricketMatch match, String id) => findDemoTeam(id);
