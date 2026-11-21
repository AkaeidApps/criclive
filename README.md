# CRICLIVE

A premium Flutter cricket live-score UI inspired by Cricbuzz.

> **Phase 1 — UI only.** Every score, player, fixture, ranking, news story and
> statistic in this build is **bundled fictional demo data**. Nothing here is a
> real live score. A persistent banner on every screen makes this explicit.
> Phase 2 (licensed data provider + backend) has **not** been started.

## Architecture

```
lib/
├── app/                    # App root, GetMaterialApp, theme, named routes, bindings
│   ├── bindings/           # InitialBinding — local-only dependency registration
│   ├── routes/             # Route names + GetPage table
│   └── theme/              # Colors, spacing, light/dark ThemeData
├── core/
│   ├── constants/          # DemoConfig (disclosure, simulated delay, error toggle)
│   ├── enums/              # Shared enums + labels
│   ├── storage/            # KeyValueStore abstraction (GetStorage / in-memory)
│   ├── utils/              # Formatters, GetX helpers
│   └── widgets/            # AppScaffold, cards, chips, tables, skeletons, states
├── data/
│   ├── models/             # Immutable domain models
│   ├── repositories/       # Demo-backed repositories + local favorites/settings
│   └── sources/demo/       # Fictional fixture files (single source of demo data)
└── modules/                # One folder per screen/feature
    ├── splash/ home/ shell/ matches/ match_center/ scorecard/ commentary/
    ├── overs/ match_info/ fixtures/ points_table/ series/ teams/ players/
    ├── statistics/ rankings/ news/ search/ favorites/ settings/ about/ more/
test/
├── widget_test.dart        # Splash, home tabs, error/retry behavior
└── navigation_smoke_test.dart  # Every route at mobile / tablet / desktop widths
```

## Design system

- Primary `#009270`, dark green `#006B53`, accent yellow `#F7D154`
- Background `#F5F6F7`, white cards, text `#202124`, secondary `#777777`, live `#E53935`
- Light theme first, optional dark theme, Material 3, compact scorecards
- `NavigationBar` on mobile/tablet, `NavigationRail` on desktop
- Skeleton loading, empty states, error/retry states and pull-to-refresh throughout

## Run & verify

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d linux       # or -d chrome / an Android device
```

Builds verified in this environment: Linux debug and Android debug APK.
iOS requires macOS/Xcode and was not built here.

## Phase 2 boundary (not implemented)

No network score fetch, API key, backend, database, cache server, SSE/WebSocket or
push delivery exists in the Flutter app. Licensed-provider integration, a
Node.js/TypeScript + Express backend, PostgreSQL, Redis, secure environment
configuration, provider adapters, rate limiting and synchronization are planned
only after Phase 1 UI approval.
