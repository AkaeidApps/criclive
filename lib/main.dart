import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'core/storage/key_value_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = GetStorageStore();
  await store.init();
  Get.put<KeyValueStore>(store, permanent: true);

  runApp(const CricLiveApp());
}
