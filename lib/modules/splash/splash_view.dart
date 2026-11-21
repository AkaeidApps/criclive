import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/demo_banner.dart';
import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.green, AppColors.darkGreen],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sports_cricket_rounded,
                          size: 84, color: AppColors.accent),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        'CRICLIVE',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'Every ball. Every moment.',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 0.6),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Obx(() => ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      child: LinearProgressIndicator(
                        value: controller.progress.value,
                        minHeight: 4,
                        backgroundColor: Colors.white24,
                        color: AppColors.accent,
                      ),
                    )),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: DemoBanner(compact: true),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
