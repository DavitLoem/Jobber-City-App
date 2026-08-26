import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/category_screen_view.dart';

class CategorySearchBar extends StatelessWidget {
  final CategoryScreenViewController controller;

  const CategorySearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkInputBackground
            : AppColors.cardBackground, // 🟢 Dynamic Input BG
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
        ), // 🟢 Dynamic Border
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.filterCategories,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Input Text
        ),
        decoration: InputDecoration(
          hintText: 'Search expertise...'.tr, // 🟢 Added .tr
          hintStyle: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.darkTextHint
                : Colors.grey[400], // 🟢 Dynamic Hint Text
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark
                ? AppColors.darkIconSecondary
                : Colors.grey, // 🟢 Dynamic Icon
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
