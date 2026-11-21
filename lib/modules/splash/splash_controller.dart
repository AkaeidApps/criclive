import 'dart:async';

import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;
  Timer? _timer;
  int _ticks = 0;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      _ticks++;
      progress.value = (_ticks / 38).clamp(0.0, 1.0).toDouble();
      if (_ticks >= 38) {
        _timer?.cancel();
        Get.offNamed(AppRoutes.home);
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
