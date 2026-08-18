import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class ExtractionSuccessSheet extends StatelessWidget {
  final int expCount;
  final int eduCount;
  final int skillCount;
  final VoidCallback onReview;

  const ExtractionSuccessSheet({
    super.key,
    required this.expCount,
    required this.eduCount,
    required this.skillCount,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(Icons.check_circle, color: AppColors.success, size: 60),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Scan Complete!'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            // 🟢 Used trParams for variables inside text
            'We found @expCount experiences, @eduCount educations, and @skillCount skills in your CV.'
                .trParams({
                  'expCount': expCount.toString(),
                  'eduCount': eduCount.toString(),
                  'skillCount': skillCount.toString(),
                }),
            style: TextStyle(
              fontSize: 15,
              color: theme.textTheme.bodyLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onReview,
              child: Text(
                'Review Data'.tr, // 🟢 Added .tr
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Not Now'.tr, // 🟢 Added .tr
                style: TextStyle(
                  color: isDark ? AppColors.darkTextHint : Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
