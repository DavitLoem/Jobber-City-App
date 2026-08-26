import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../search_button_controller.dart';

class SearchSuggestions extends GetView<SearchButtonViewController> {
  const SearchSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (controller.recentSearches.isEmpty &&
          controller.popularSearches.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primaryLight, // 🟢 Dynamic Empty BG
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.travel_explore_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'What are you looking for?'.tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Search for jobs, companies, or specific skills to discover your next opportunity.'
                      .tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary, // 🟢 Dynamic Subtext
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.recentSearches.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.primaryLight, // 🟢 Dynamic BG
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.history_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Recent Searches'.tr, // 🟢 Added .tr
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme
                                .textTheme
                                .bodyLarge
                                ?.color, // 🟢 Dynamic Text
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => controller.clearAllRecentSearches(),
                      child: Text(
                        'Clear'.tr, // 🟢 Added .tr
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.recentSearches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final search = controller.recentSearches[index];
                    return _buildRecentSearchItem(search, isDark, theme);
                  },
                ),
                const SizedBox(height: 32),
              ],
              if (controller.popularSearches.isNotEmpty) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.primaryLight, // 🟢 Dynamic BG
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Popular Searches'.tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: controller.popularSearches.map((search) {
                    return _buildPopularSearchChip(search, isDark);
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRecentSearchItem(String search, bool isDark, ThemeData theme) {
    return GestureDetector(
      onTap: () => controller.selectSearchQuery(search),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardColor, // 🟢 Dynamic Button BG
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 1,
          ), // 🟢 Dynamic Border
        ),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.textTertiary, // 🟢 Dynamic Icon
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                search,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme
                      .textTheme
                      .bodyLarge
                      ?.color, // 🟢 Dynamic Search Text
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.north_west_rounded,
              color: isDark
                  ? AppColors.darkTextHint
                  : AppColors.textHint, // 🟢 Dynamic Icon
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSearchChip(String search, bool isDark) {
    return GestureDetector(
      onTap: () => controller.selectSearchQuery(search),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.05),
                  ]
                : [
                    AppColors.primaryLight,
                    AppColors.primaryLight.withValues(alpha: 0.5),
                  ],
          ), // 🟢 Dynamic Gradient
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(
              alpha: 0.2,
            ), // 🟢 Updated to withValues
            width: 1,
          ),
        ),
        child: Text(
          search,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark
                ? Colors.blueAccent
                : AppColors.primary, // 🟢 Dynamic Chip Text
          ),
        ),
      ),
    );
  }
}
