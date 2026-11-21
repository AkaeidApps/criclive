import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/constants/demo_config.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
        title: 'About & Data Sources',
        subtitle: 'CRICLIVE · Phase 1 (UI only)',
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  children: [
                    Icon(Icons.sports_cricket_rounded,
                        size: 58, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: AppSpacing.md),
                    Text('CRICLIVE',
                        style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Every ball. Every moment.',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Version 1.0.0+1 · Phase 1 demo build',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 18, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Text('Important: demo data',
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(DemoConfig.dataDisclosure),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'All matches, scores, commentary, news, rankings and player profiles in this build '
                      'are fictional fixtures bundled in the app. Nothing is fetched from a live cricket provider.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Planned data sources (Phase 2)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.md),
                    _source('Cricket Database API', 'Primary candidate',
                        'cricketdatabase.com/documentation'),
                    _source('CricketData / CricAPI', 'Alternative',
                        'cricketdata.org'),
                    _source('Cricwix', 'Alternative', 'cricwix.com'),
                    _source('Sportradar Cricket', 'Enterprise alternative',
                        'developer.sportradar.com/cricket'),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Providers will be evaluated for live coverage, latency, ball-by-ball completeness, '
                      'commercial licensing and pricing before integration. API keys will live only on the backend.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Privacy & account',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'There is no login or signup. Favorites, searches and preferences are stored locally '
                      'on your device and never sent to a server in Phase 1.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Credits', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'CRICLIVE branding, icons and demo fixtures are original. '
                      'Flutter and GetX are used under their respective open-source licenses.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _source(String name, String role, String url) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cloud_outlined, size: 16, color: Color(0xFF009270)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$name · $role',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  Text(url,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF777777))),
                ],
              ),
            ),
          ],
        ),
      );
}
