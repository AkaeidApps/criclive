# CRICLIVE — Phase 1 Integration Report

Date: 2026-11-21. Scope: inspection only. No UI, model, controller or repository file was modified.

## 1. Project snapshot

- Flutter 3.47.7 / Dart 3.13.5, GetX 4.7.3, GetStorage 2.1.1, intl 0.20.3. No HTTP, connectivity or serialization package is present in `pubspec.yaml`.
- Entry point: `lib/main.dart` → `lib/app/app.dart` (`GetMaterialApp`, `InitialBinding`, routes in `lib/app/routes/app_pages.dart`).
- Local storage: `lib/core/storage/key_value_store.dart` (`GetStorageStore`, `InMemoryStore` for tests).
- Backend directory, `lib/core/network`, remote data sources, API configuration and environment files do not exist yet.
- Node v26.13.0 / npm 11.20.0 available. PostgreSQL and Redis binaries are not installed in this environment (development can run with an in-memory cache until a database is provisioned).
- Existing tests: `test/widget_test.dart`, `test/navigation_smoke_test.dart`.

## 2. Existing screens and controllers

| Route | Screen file | Controller | Current data source |
|---|---|---|---|
| `/splash` | `modules/splash/splash_view.dart` | `SplashController` | local timer/preferences |
| `/home` | `modules/shell/main_shell.dart` + `modules/home/home_view.dart` | `ShellController`, `HomeController` | 4 demo repositories via `Future.wait` |
| `/matches/live`, `/matches/upcoming`, `/matches/results` | `modules/matches/matches_view.dart` | `MatchListController` (tag = category) | `MatchRepository` demo lists |
| `/fixtures` | `modules/fixtures/fixtures_view.dart` | `FixturesController` | `MatchRepository.allMatches()` |
| `/points` | `modules/points_table/points_table_view.dart` | `PointsTableController` | `SeriesRepository.pointsTables()` demo |
| `/match/:id` | `modules/match_center/match_center_view.dart` | `MatchCenterController` (tag = id) | `MatchRepository.match(id)` |
| `/scorecard/:id` | `modules/scorecard/scorecard_view.dart` | `MatchCenterController` (tag = id) | same match object (no separate controller) |
| `/commentary/:id` | `modules/commentary/commentary_view.dart` | `MatchCenterController` + `CommentaryViewController` (filter only) | `match.commentary` |
| `/overs/:id` | `modules/overs/overs_view.dart` | `MatchCenterController` | `match.overs` derived from commentary |
| `/info/:id` | `modules/match_info/match_info_view.dart` | `MatchCenterController` | match metadata |
| `/series`, `/series-detail/:id` | `modules/series/series_view.dart` | `SeriesController` | `SeriesRepository`, `MatchRepository` demo |
| `/teams`, `/team-detail/:id` | `modules/teams/teams_view.dart` | `TeamsController` | `TeamRepository`, `PlayerRepository`, `MatchRepository` demo |
| `/players`, `/player-detail/:id` | `modules/players/players_view.dart` | `PlayersController` | `PlayerRepository` demo |
| `/statistics` | `modules/statistics/statistics_view.dart` | `StatisticsController` | `StatsRepository` demo |
| `/rankings` | `modules/rankings/rankings_view.dart` | `RankingsController` | `RankingRepository` demo |
| `/news`, `/news-detail/:id` | `modules/news/news_view.dart` | `NewsController` | `NewsRepository` demo |
| `/search` | `modules/search/search_view.dart` | `SearchController` | **direct imports** of 5 demo fixture files |
| `/favorites` | `modules/favorites/favorites_view.dart` | `FavoritesController` | local `FavoritesRepository` |
| `/settings`, `/settings/notifications` | `modules/settings/settings_view.dart` | `SettingsController` | local `SettingsRepository` |
| `/about`, `/more` | `modules/about/about_view.dart`, `modules/more/more_view.dart` | none | static text / hardcoded demo match IDs |

Shell navigation has 5 tabs (Home, Matches, Search, Favorites, More) implemented in `modules/shell/main_shell.dart`.

## 3. Models (existing contracts to preserve)

- `CricketMatch`: id, seriesId/Name, title, round, teamIds, `MatchStatus`, `MatchFormat`, venue/city, startTime, lastUpdated, statusText, resultText, toss, innings, commentary, overs, playingXIs, umpires, note, currentInningsIndex, `isDemo => true`.
- `Innings`: id, number, batting/bowling team IDs, runs/wickets/balls, target, declared, batting/bowling figures, extras, fall of wickets, partnerships.
- `BallEvent`: over/ballInOver (0-based), runs, batter/bowler IDs, extra, wicket data, commentary text, timestamp, cumulative total/wickets. `OverSummary` is derived per over.
- `Player`: id, name, teamId, role, styles, age, bio, batting/bowling career maps, recentScores.
- `Team`: id, name, shortName, abbreviation, flag, two hex colors, international, city, founded.
- `Series`, `PointsTable`, `RankingBoard`, `BattingStatRow`, `BowlingStatRow`, `RecordRow`, `NewsArticle`.
- Enums in `core/enums/app_enums.dart`: `ViewState`, `MatchStatus` (live/upcoming/completed/delayed/dataUnavailable), `MatchFormat`, `PlayerRole`, plus UI category enums.

## 4. Existing hardcoded/demo data

All data comes from `lib/data/sources/demo/*`: matches (3 fictional live, 3 upcoming, 3 completed, with full innings/ball data), players (~large fictional catalogue), teams, series + points tables, rankings, statistics, news. `MatchRepository` and `cricket_repositories.dart` call `loadDemo()` which adds an artificial 260 ms delay and can throw a simulated error. `DemoConfig.isDemoBuild = true`, and `DemoBanner` is shown by every `AppScaffold` (and on splash). Multiple views contain hard-coded "DEMO" wording and `MoreView` links to hard-coded demo match IDs.

## 5. Reusable UI components (must be preserved)

`AppScaffold`, `DemoBanner`, `MatchCard`, `StatusChip`, `PillChip`, `InfoRow`, `BattingCard`, `BowlingCard`, `FallOfWicketsCard`, `ScoreboardCard`, `MetricsRow`, `CommentaryTile`, `OverSummaryCard`, `InningsSelector`, `ResponsiveGrid`, skeletons, `LoadingView`, `ErrorView`, `EmptyView`, `TeamCrest`, `SectionHeader`, preference tiles, data tables.

## 6. Integration seams (no screen redesign required)

1. Keep all `GetX` controller field names and public methods (`load`, `state`, `matches`, `match`, etc.) unchanged; replace only the repository implementations behind them.
2. Add `lib/core/config/app_config.dart` (backend base URL via `--dart-define`, never an API key), `lib/core/network/*` (typed client, endpoints, exception mapping), `lib/data/sources/remote/*`, and remote repository implementations.
3. Register the new repositories in `InitialBinding`; controllers resolve them through `Get.find`, so view code is untouched.
4. Parse backend JSON into the *existing* domain models in a dedicated mapper layer, so widgets do not change.
5. Preserve synchronous cache helpers used by the UI (`cachedMatch`, `TeamRepository.cached`, `PlayerRepository.cached`, `SeriesRepository.cachedAll`).
6. Refactor `SearchController` to call a `SearchRepository` instead of importing demo files; `SearchResult` and the view stay the same.
7. Backend returns a stable application envelope. Flutter maps error codes to existing `errorMessage` + `ErrorView`, and empty lists to `ViewState.empty`.

## 7. Gaps and decisions required before implementation

1. **Provider documentation is not reachable from this environment.** `https://cricketdatabase.com/documentation` returns HTTP 403 (Cloudflare challenge), including through text proxies, and web search returned no usable results. The only provider paths supplied in the brief are the paid live endpoints (`/v1/live`, `/v1/live/{match}`, `/v1/live/{match}/balls`, `/v1/live/stream`). Free-plan paths, parameters and response schemas are unknown. Per the rules, they will **not** be guessed. I need either (a) a copy of the free-plan endpoint documentation with sample responses, or (b) confirmation to build the provider adapter behind a configuration-driven endpoint registry that stays disabled until the verified paths are supplied.
2. **No API key present.** A key must never be placed in Flutter or committed. It will be read from backend `CDB_KEY` only. Real end-to-end verification cannot run until a key is supplied in a local `.env`.
3. **Static "DEMO" text in existing views and the persistent `DemoBanner`.** To meet the "never claim false live data" rule after real data is connected, these text strings must be replaced with a data-source-aware disclosure. The layout, widgets and navigation remain unchanged, but this is a small, deliberate text-level UI edit. I need confirmation that this is acceptable, or confirmation to leave the app permanently in demo-disclosure mode while real data is fetched (not recommended because it mislabels real data).
4. **Unsupported screens.** News, rankings, statistics, points tables and ICC-style boards are not in the requested provider interface. They should show an explicit "unavailable from the current provider/plan" empty state rather than bundled fictional data. This requires small message-string changes only.
5. **Match statuses.** `MatchStatus` needs `abandoned` and `unknown` values to faithfully map provider statuses; this is a model/enum addition, not a UI redesign. All switch sites will be updated for exhaustive mapping.
6. **`more_view.dart` hard-codes demo IDs** (`m_live_ind_aus`) for deep links. These must be replaced by IDs available from the backend (or the links must degrade to a clear "unavailable" state) without changing the screen layout.
7. Backend base URL for Flutter: confirm the intended deployment origin (for example `http://10.0.2.2:3000` for Android emulator, `http://localhost:3000` for Linux, or a production HTTPS host). It will be injected at build time; default to `http://localhost:3000` for development.

## 8. Phase 2 design (provider-independent backend)

- `CricketDataProvider` interface with the requested methods. `CricketDatabaseProvider` is the only concrete adapter; a `StubProvider` is used only in automated tests.
- `CDB_PLAN` capability matrix (`free`, `match_week`, `archive`, `pro`, `analyst_pro`). With `free`: historical/recent/player/team/scorecard capabilities are enabled only if a verified free endpoint exists; live capabilities are always false. `UPGRADE_REQUIRED` is distinct from provider/network errors.
- Provider client: Bearer auth header, timeout,Retry-After handling, bounded exponential backoff, request logging with secrets redacted, daily/minute budget tracking.
- Endpoint registry: verified provider path+query+schema per capability; an unverified capability fails closed with `PROVIDER_UNCONFIGURED` rather than calling a guessed URL.
- App API: the 15 routes from the brief, returning `{success,data,meta}` / `{success,error}`.
- Caching: in-memory TTL + optional Redis + optionally Prisma/PostgreSQL snapshot persistence; in-flight request deduplication; per-route TTL; manual refresh bypasses cache but still obeys provider budgets.
- Flutter: remote repositories replace demo implementations; GetStorage caches responses with a `source` marker and `updatedAt`; stale data is only labelled historical, never live.

## 9. Baseline verification

Run before changes and record results:

```bash
flutter analyze
flutter test
```
