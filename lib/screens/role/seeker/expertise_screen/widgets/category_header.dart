import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Your Expertise'.tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Select up to 5 fields that match your skills'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
