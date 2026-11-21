import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final base = Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : const Color(0xFFE9ECEE);
        final highlight = Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBorder
            : const Color(0xFFF7F9FA);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [base, highlight, base],
              stops: [
                (t - 0.35).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.35).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MatchCardSkeleton extends StatelessWidget {
  const MatchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: 130, height: 12),
              const SizedBox(height: AppSpacing.md),
              const ShimmerBox(width: double.infinity, height: 20),
              const SizedBox(height: AppSpacing.sm),
              const ShimmerBox(width: 180, height: 14),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  ShimmerBox(
                      width: MediaQuery.sizeOf(context).width * 0.28,
                      height: 10),
                  const Spacer(),
                  const ShimmerBox(width: 70, height: 10),
                ],
              ),
            ],
          ),
        ),
      );
}

class ListSkeleton extends StatelessWidget {
  final int count;

  const ListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(count, (_) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Row(
                  children: [
                    const ShimmerBox(width: 40, height: 40,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ShimmerBox(width: 160, height: 14),
                          SizedBox(height: AppSpacing.sm),
                          ShimmerBox(width: 100, height: 11),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
}

class TableSkeleton extends StatelessWidget {
  final int rows;

  const TableSkeleton({super.key, this.rows = 6});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            children: List.generate(rows, (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      ShimmerBox(width: MediaQuery.sizeOf(context).width * 0.3, height: 12),
                      const Spacer(),
                      const ShimmerBox(width: 48, height: 12),
                      const SizedBox(width: AppSpacing.md),
                      const ShimmerBox(width: 36, height: 12),
                    ],
                  ),
                )),
          ),
        ),
      );
}
