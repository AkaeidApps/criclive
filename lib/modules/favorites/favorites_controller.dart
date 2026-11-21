import 'package:get/get.dart';

import '../../data/repositories/local_repositories.dart';

class FavoritesController extends GetxController {
  final FavoritesRepository _repository;

  FavoritesController({FavoritesRepository? repository})
      : _repository = repository ?? Get.find<FavoritesRepository>();

  final matches = <String>[].obs;
  final teams = <String>[].obs;
  final players = <String>[].obs;
  final series = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  void reload() {
    matches.value = _repository.read(FavoriteKind.match);
    teams.value = _repository.read(FavoriteKind.team);
    players.value = _repository.read(FavoriteKind.player);
    series.value = _repository.read(FavoriteKind.series);
  }

  RxList<String> listFor(FavoriteKind kind) => switch (kind) {
        FavoriteKind.match => matches,
        FavoriteKind.team => teams,
        FavoriteKind.player => players,
        FavoriteKind.series => series,
      };

  bool isFavorite(FavoriteKind kind, String id) => listFor(kind).contains(id);

  Future<void> toggle(FavoriteKind kind, String id) async {
    await _repository.toggle(kind, id);
    listFor(kind).value = _repository.read(kind);
  }

  Future<void> remove(FavoriteKind kind, String id) => toggle(kind, id);

  int get total =>
      matches.length + teams.length + players.length + series.length;
}
