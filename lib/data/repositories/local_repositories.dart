import '../../../core/enums/app_enums.dart';
import '../../core/storage/key_value_store.dart';

/// Local favorites. No login, no account, no server synchronization.
class FavoritesRepository {
  final KeyValueStore _store;

  FavoritesRepository(this._store);

  static const String _matchesKey = 'favorites.matches';
  static const String _teamsKey = 'favorites.teams';
  static const String _playersKey = 'favorites.players';
  static const String _seriesKey = 'favorites.series';

  String _keyFor(FavoriteKind kind) => switch (kind) {
        FavoriteKind.match => _matchesKey,
        FavoriteKind.team => _teamsKey,
        FavoriteKind.player => _playersKey,
        FavoriteKind.series => _seriesKey,
      };

  List<String> read(FavoriteKind kind) {
    final raw = _store.read(_keyFor(kind));
    if (raw is List) {
      return raw.map((item) => item.toString()).toList();
    }
    return <String>[];
  }

  Future<void> save(FavoriteKind kind, List<String> ids) =>
      _store.write(_keyFor(kind), ids);

  Future<void> toggle(FavoriteKind kind, String id) async {
    final ids = read(kind);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await save(kind, ids);
  }
}

enum FavoriteKind { match, team, player, series }

/// Locally persisted app + notification preferences.
class SettingsRepository {
  final KeyValueStore _store;

  SettingsRepository(this._store);

  Future<void> init() => _store.init();

  bool readBool(String key, {bool fallback = false}) {
    final value = _store.read(key);
    return value is bool ? value : fallback;
  }

  Future<void> writeBool(String key, bool value) => _store.write(key, value);

  int readInt(String key, {int fallback = 30}) {
    final value = _store.read(key);
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  Future<void> writeInt(String key, int value) => _store.write(key, value);

  String readString(String key, {String fallback = ''}) {
    final value = _store.read(key);
    return value is String ? value : fallback;
  }

  Future<void> writeString(String key, String value) =>
      _store.write(key, value);

  List<String> readList(String key) {
    final raw = _store.read(key);
    if (raw is List) return raw.map((item) => item.toString()).toList();
    return <String>[];
  }

  Future<void> writeList(String key, List<String> values) =>
      _store.write(key, values);

  ThemePreference get themePreference => ThemePreference.values.firstWhere(
        (value) => value.name == readString('settings.theme'),
        orElse: () => ThemePreference.light,
      );

  Future<void> setThemePreference(ThemePreference preference) =>
      writeString('settings.theme', preference.name);

  Future<void> clearPreferences() async {
    for (final key in _allPreferenceKeys) {
      await _store.remove(key);
    }
  }

  static const List<String> _allPreferenceKeys = [
    'settings.theme',
    'notifications.live_scores',
    'notifications.wickets',
    'notifications.boundaries',
    'notifications.results',
    'notifications.news',
    'notifications.daily_digest',
    'notifications.quiet_hours',
    'settings.refresh_interval',
    'settings.data_saver',
    'settings.simulate_errors',
    'search.recent',
  ];
}

abstract final class SettingsKeys {
  static const liveScores = 'notifications.live_scores';
  static const wickets = 'notifications.wickets';
  static const boundaries = 'notifications.boundaries';
  static const results = 'notifications.results';
  static const news = 'notifications.news';
  static const dailyDigest = 'notifications.daily_digest';
  static const quietHours = 'notifications.quiet_hours';
  static const refreshInterval = 'settings.refresh_interval';
  static const dataSaver = 'settings.data_saver';
  static const simulateErrors = 'settings.simulate_errors';
  static const recentSearches = 'search.recent';
}
