import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusPill = 999;

  static const double maxContentWidth = 1120;

  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  static const List<BoxShadow> cardShadows = [
    BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
  ];
}
