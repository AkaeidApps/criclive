import 'package:flutter/material.dart';

import 'demo_banner.dart';
import 'responsive.dart';

/// Common page chrome: app bar, persistent demo-data disclosure and content.
class AppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool showBanner;
  final bool automaticallyImplyLeading;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.actions,
    this.showBanner = true,
    this.automaticallyImplyLeading = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.centerTitle = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        centerTitle: centerTitle,
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: actions,
        bottom: bottom,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Column(
        children: [
          if (showBanner) const DemoBanner(),
          Expanded(
            child: SafeArea(
              top: false,
              child: ResponsiveContainer(child: body),
            ),
          ),
        ],
      ),
    );
  }
}
