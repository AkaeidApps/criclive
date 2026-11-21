import 'package:get/get.dart';

/// Returns an existing controller when present, otherwise registers a new one.
/// Keeps deep links and nested navigation shareable without duplicate state.
T provide<T extends GetxController>(T Function() factory, {String? tag}) {
  if (Get.isRegistered<T>(tag: tag)) {
    return Get.find<T>(tag: tag);
  }
  return Get.put<T>(factory(), tag: tag);
}
