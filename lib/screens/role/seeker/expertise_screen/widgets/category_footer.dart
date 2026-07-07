import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/category_screen_view.dart';

class CategoryFooter extends StatefulWidget {
  final CategoryScreenViewController controller;
  const CategoryFooter({super.key, required this.controller});

  @override
  State<CategoryFooter> createState() => _CategoryFooterState();
}

class _CategoryFooterState extends State<CategoryFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(_pressCtrl);
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = widget.controller.selectedCategoryIds.length;
      final hasSelection = count > 0;
      final isSubmitting = widget.controller.isSubmitting.value;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            // ── Counter Chips ──
            if (hasSelection) ...[
              CategorySelectionCounter(count: count),
              const SizedBox(height: 14),
            ],

            // ── Continue Button ──
            GestureDetector(
              onTapDown: (hasSelection && !isSubmitting)
                  ? (_) => _pressCtrl.forward()
                  : null,
              onTapUp: (hasSelection && !isSubmitting)
                  ? (_) {
                      _pressCtrl.reverse();
                      widget.controller.continueToNextScreen();
                    }
                  : null,
              onTapCancel: () => _pressCtrl.reverse(),
              child: ScaleTransition(
                scale: _scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: hasSelection
                        ? const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                            ], // កែឱ្យត្រូវនឹង AppColors របស់អ្នក
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : const LinearGradient(
                            colors: [Color(0xFFCCCCCC), Color(0xFFDDDDDD)],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: hasSelection
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.38),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                hasSelection
                                    ? 'Continue'
                                    : 'Select at least 1 field',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: hasSelection
                                      ? Colors.white
                                      : const Color(0xFFAAAAAA),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              if (hasSelection) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CategorySelectionCounter extends StatelessWidget {
  final int count;
  const CategorySelectionCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(5, (i) {
          final filled = i < count;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: filled ? 28 : 10,
            height: 8,
            decoration: BoxDecoration(
              color: filled ? AppColors.primary : const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
        const SizedBox(width: 10),
        Text(
          '$count / 5 selected',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
