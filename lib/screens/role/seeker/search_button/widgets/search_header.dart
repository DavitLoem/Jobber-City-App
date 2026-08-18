import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../search_button_controller.dart';
import 'job_filter_bottom_sheet.dart';

class SearchHeader extends GetView<SearchButtonViewController> {
  final double topInset;

  const SearchHeader({super.key, required this.topInset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topInset > 0 ? 12 : 20, 20, 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.cardBorder,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: theme.textTheme.bodyLarge?.color,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Hero(
              tag: 'search_bar_hero',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInputBackground
                        : AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  child: Obx(
                    () => TextField(
                      controller: controller.searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        controller.performSearch(isRefresh: true);
                      },
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkInputText
                            : AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText:
                            'Search jobs, companies...'.tr, // 🟢 Added .tr
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.darkTextHint
                              : AppColors.textHint,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: Icon(
                            Icons.search_rounded,
                            color: isDark
                                ? AppColors.darkIconSecondary
                                : AppColors.textTertiary,
                            size: 22,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 44,
                        ),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? GestureDetector(
                                onTap: () => controller.clearSearch(),
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.primary.withValues(
                                            alpha: 0.2,
                                          ) // 🟢 Updated opacity
                                        : AppColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.clear_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              )
                            : null,
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 44,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          GestureDetector(
            onTap: () => Get.bottomSheet(
              const JobFilterBottomSheet(),
              isScrollControlled: true,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowBlue,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: AppColors.white,
                    size: 22,
                  ),
                ),
                Obx(() {
                  if (controller.activeFiltersCount.value > 0) {
                    return Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '${controller.activeFiltersCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
