import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 600;

bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= 600 &&
    MediaQuery.sizeOf(context).width < 1024;

bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 1024;

int gridColumns(BuildContext context, {int mobile = 1, int tablet = 2, int desktop = 3}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 1024) return desktop;
  if (width >= 600) return tablet;
  return mobile;
}

double horizontalPagePadding(BuildContext context) =>
    isMobile(context) ? AppSpacing.lg : AppSpacing.xxl;

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobile;
  final int tablet;
  final int desktop;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 3,
    this.spacing = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    final columns = gridColumns(context, mobile: mobile, tablet: tablet, desktop: desktop);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}
