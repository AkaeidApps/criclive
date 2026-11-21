import 'package:get/get.dart';

class ShellController extends GetxController {
  final index = 0.obs;

  static const tabs = ['Home', 'Matches', 'Search', 'Favorites', 'More'];

  void select(int value) => index.value = value;
}
