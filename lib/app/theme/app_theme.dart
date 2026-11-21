import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Light-first theme with an optional dark theme exposed in App Settings.
abstract final class AppTheme {
  static ThemeData get light => _build(isDark: false);
  static ThemeData get dark => _build(isDark: true);

  static ThemeData _build({required bool isDark}) {
    final colors = isDark
        ? const ColorScheme.dark(
            primary: AppColors.green,
            onPrimary: Colors.white,
            secondary: AppColors.accent,
            onSecondary: AppColors.text,
            surface: AppColors.darkSurface,
            onSurface: AppColors.darkText,
            error: AppColors.live,
            onError: Colors.white,
          )
        : const ColorScheme.light(
            primary: AppColors.green,
            onPrimary: Colors.white,
            primaryContainer: AppColors.softGreen,
            onPrimaryContainer: AppColors.darkGreen,
            secondary: AppColors.darkGreen,
            onSecondary: Colors.white,
            surface: AppColors.white,
            onSurface: AppColors.text,
            error: AppColors.live,
            onError: Colors.white,
          );

    final background = isDark ? AppColors.darkBackground : AppColors.background;
    final textColor = isDark ? AppColors.darkText : AppColors.text;
    final secondaryColor =
        isDark ? AppColors.darkSecondary : AppColors.secondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: borderColor,
      textTheme: TextTheme(
        displaySmall: TextStyle(
            fontSize: 30, height: 1.15, fontWeight: FontWeight.w800, color: textColor),
        headlineSmall: TextStyle(
            fontSize: 22, height: 1.2, fontWeight: FontWeight.w700, color: textColor),
        titleLarge: TextStyle(
            fontSize: 19, height: 1.25, fontWeight: FontWeight.w700, color: textColor),
        titleMedium: TextStyle(
            fontSize: 16, height: 1.3, fontWeight: FontWeight.w700, color: textColor),
        titleSmall: TextStyle(
            fontSize: 14, height: 1.3, fontWeight: FontWeight.w600, color: textColor),
        bodyLarge: TextStyle(fontSize: 15, height: 1.45, color: textColor),
        bodyMedium: TextStyle(fontSize: 13.5, height: 1.4, color: textColor),
        bodySmall: TextStyle(fontSize: 12, height: 1.35, color: secondaryColor),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: textColor),
        labelMedium: TextStyle(
            fontSize: 12.5, fontWeight: FontWeight.w600, color: secondaryColor),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.shadow,
        titleTextStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
        iconTheme: IconThemeData(color: textColor, size: 22),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.green,
          side: const BorderSide(color: AppColors.green),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        selectedColor: AppColors.softGreen,
        disabledColor: Colors.transparent,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill)),
        labelStyle: TextStyle(fontSize: 12.5, color: textColor),
        secondaryLabelStyle:
            const TextStyle(fontSize: 12.5, color: AppColors.darkGreen),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.green,
        unselectedLabelColor: secondaryColor,
        labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.green, width: 2.5),
          insets: EdgeInsets.symmetric(horizontal: 12),
        ),
        dividerColor: borderColor,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        indicatorColor: AppColors.softGreen,
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? AppColors.green
                  : secondaryColor,
              size: 23,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontSize: 11,
              fontWeight:
                  states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? AppColors.green
                  : secondaryColor,
            )),
        height: 68,
        elevation: 0,
        shadowColor: AppColors.shadow,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        selectedIconTheme: const IconThemeData(color: AppColors.green),
        unselectedIconTheme: IconThemeData(color: secondaryColor),
        selectedLabelTextStyle: const TextStyle(
            color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelTextStyle:
            TextStyle(color: secondaryColor, fontSize: 12),
        indicatorColor: AppColors.softGreen,
        minWidth: 76,
        useIndicator: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(color: secondaryColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
          borderSide: BorderSide(color: AppColors.green, width: 1.6),
        ),
        prefixIconColor: secondaryColor,
        suffixIconColor: secondaryColor,
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.green),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkText : AppColors.text,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        textStyle: TextStyle(
            color: isDark ? AppColors.text : Colors.white, fontSize: 12),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
