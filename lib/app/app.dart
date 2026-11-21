import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/enums/app_enums.dart';
import '../modules/settings/settings_controller.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

class CricLiveApp extends StatelessWidget {
  const CricLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure dependencies exist before reading the theme preference.
    // GetMaterialApp also applies this binding in initState; it is idempotent.
    InitialBinding().dependencies();
    final settings = Get.find<SettingsController>();
    return Obx(() {
      final preference = settings.themePreference.value;
      return GetMaterialApp(
        title: 'CRICLIVE',
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppPages.initial,
        getPages: AppPages.pages,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: switch (preference) {
          ThemePreference.light => ThemeMode.light,
          ThemePreference.dark => ThemeMode.dark,
          ThemePreference.system => ThemeMode.system,
        },
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 220),
        builder: (context, child) => MediaQuery(
          // Keeps text scale sane on large desktop displays.
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.85,
                  maxScaleFactor: 1.3,
                ),
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      );
    });
  }
}
