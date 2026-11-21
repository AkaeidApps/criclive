import 'package:get_storage/get_storage.dart';

/// Local-only key/value abstraction. No account, no cloud sync.
abstract class KeyValueStore {
  Future<void> init();
  Object? read(String key);
  Future<void> write(String key, Object? value);
  Future<void> remove(String key);
  Map<String, dynamic> readAll();
}

/// Device-backed implementation using GetStorage (works on mobile + Linux).
class GetStorageStore implements KeyValueStore {
  GetStorage? _box;

  @override
  Future<void> init() async {
    if (_box != null) return;
    await GetStorage.init();
    _box = GetStorage();
  }

  @override
  Object? read(String key) => _box?.read(key);

  @override
  Future<void> write(String key, Object? value) async {
    await _box?.write(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _box?.remove(key);
  }

  @override
  Map<String, dynamic> readAll() {
    final box = _box;
    if (box == null) return <String, dynamic>{};
    final keys = box.getKeys<Iterable<String>>();
    return <String, dynamic>{
      for (final key in keys) key: box.read(key),
    };
  }
}

/// In-memory implementation used by tests and as a safe fallback.
class InMemoryStore implements KeyValueStore {
  final Map<String, dynamic> _values = <String, dynamic>{};

  @override
  Future<void> init() async {}

  @override
  Object? read(String key) => _values[key];

  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<void> remove(String key) async => _values.remove(key);

  @override
  Map<String, dynamic> readAll() => Map<String, dynamic>.from(_values);
}
