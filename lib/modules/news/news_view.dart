import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_scaffold.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/getx_helpers.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/skeletons.dart';
import '../../core/widgets/state_widgets.dart';
import '../../data/models/news.dart';
import 'news_controller.dart';

class NewsView extends StatelessWidget {
  final String? articleId;

  const NewsView({super.key, this.articleId});

  @override
  Widget build(BuildContext context) {
    final controller = provide(
      () => NewsController(articleId: articleId),
      tag: articleId ?? 'news-hub',
    );
    return AppScaffold(
      title: articleId == null ? 'Cricket News' : 'Story',
      subtitle: articleId == null ? 'Demo editorial content' : null,
      body: Obx(() {
        if (controller.state.value.isLoading) return const ListSkeleton(count: 4);
        if (controller.state.value.hasError) {
          return ErrorView(
              message: controller.errorMessage.value, onRetry: controller.load);
        }
        return articleId == null
            ? _NewsList(controller: controller)
            : _ArticleDetail(controller: controller);
      }),
    );
  }
}

class _NewsList extends StatelessWidget {
  final NewsController controller;

  const _NewsList({required this.controller});

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: NewsCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: PillChip(
                          label: category.label,
                          selected: controller.category.value == category,
                          onTap: () => controller.category.value = category,
                        ),
                      );
                    }).toList(),
                  )),
            ),
            const SizedBox(height: AppSpacing.lg),
            Obx(() {
              final articles = controller.filtered;
              if (articles.isEmpty) {
                return const EmptyView(
                  icon: Icons.article_outlined,
                  title: 'No stories found',
                  message: 'Try another news category.',
                );
              }
              return Column(
                children: articles.asMap().entries.map((entry) {
                  final article = entry.value;
                  if (entry.key == 0 && controller.category.value == NewsCategory.all) {
                    return _FeaturedArticle(article: article);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _ArticleTile(article: article),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      );
}

class _FeaturedArticle extends StatelessWidget {
  final NewsArticle article;

  const _FeaturedArticle({required this.article});

  @override
  Widget build(BuildContext context) {
    final value = article;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.article(value.id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 106,
                color: AppColors.darkGreen,
                alignment: Alignment.center,
                child: const Icon(Icons.sports_cricket,
                    size: 46, color: AppColors.accent),
              ),
              Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FEATURED · ${value.categoryLabel}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.green)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(value.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(value.summary,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text('${value.timeLabel} · ${value.readMinutes} min read',
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  final NewsArticle article;

  const _ArticleTile({required this.article});

  @override
  Widget build(BuildContext context) {
    final value = article;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: const Icon(Icons.article_outlined,
              color: AppColors.green, size: 22),
        ),
        title: Text(value.title,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
        subtitle: Text('${value.categoryLabel} · ${value.timeLabel}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Get.toNamed(AppRoutes.article(value.id)),
      ),
    );
  }
}

class _ArticleDetail extends StatelessWidget {
  final NewsController controller;

  const _ArticleDetail({required this.controller});

  @override
  Widget build(BuildContext context) {
    final article = controller.article.value;
    if (article == null) {
      return const EmptyView(
        icon: Icons.article_outlined,
        title: 'Story unavailable',
        message: 'This demo article could not be found.',
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.categoryLabel,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green)),
                const SizedBox(height: AppSpacing.sm),
                Text(article.title,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.person_outline,
                        size: 14, color: AppColors.secondary),
                    Text(article.author,
                        style: Theme.of(context).textTheme.bodySmall),
                    Icon(Icons.schedule, size: 14, color: AppColors.secondary),
                    Text('${article.readMinutes} min read',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                Text(article.dateLabel,
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
                ...article.body.map(
                  (paragraph) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(paragraph,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            )),
                  ),
                ),
                const Divider(),
                Text(
                  'Source: ${article.source} · Bundled demo content. '
                  'This article does not report real cricket events.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
