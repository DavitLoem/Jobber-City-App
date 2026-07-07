import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/category_screen_view.dart';

class CategorySearchBar extends StatelessWidget {
  final CategoryScreenViewController controller;

  const CategorySearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.filterCategories,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Search expertise...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.grey,
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
