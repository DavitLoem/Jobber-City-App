import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/category_screen_view.dart';

class CategoryList extends StatelessWidget {
  final CategoryScreenViewController controller;
  const CategoryList({super.key, required this.controller});

  Widget _buildCategoryIcon(
    String? iconUrl,
    bool isSelected,
    bool maxReached,
    bool isDark,
  ) {
    final Color iconColor = isSelected
        ? Colors.white
        : maxReached
        ? (isDark
              ? AppColors.darkIconSecondary
              : const Color(0xFFCCCCCC)) // 🟢 Dynamic Disabled Icon
        : (isDark
              ? AppColors.darkTextSecondary
              : Colors.grey[600]!); // 🟢 Dynamic Default Icon

    final bool hasValidDynamicIcon =
        iconUrl != null &&
        iconUrl.isNotEmpty &&
        !iconUrl.contains('example.com');

    if (hasValidDynamicIcon) {
      return Icon(Icons.work_outline_rounded, size: 20, color: iconColor);
    } else {
      return Icon(Icons.work_outline_rounded, size: 20, color: iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.categoriesList.isEmpty) {
        return Center(
          child: Text(
            "No expertise found.".tr, // 🟢 Added .tr
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textTertiary,
            ),
          ),
        );
      }

      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        itemCount: controller.categoriesList.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final cat = controller.categoriesList[index];

          return Obx(() {
            final isSelected = controller.selectedCategoryIds.contains(cat.id);
            final maxReached =
                controller.selectedCategoryIds.length >= 5 && !isSelected;

            return GestureDetector(
              onTap: maxReached
                  ? null
                  : () => controller.toggleSelection(cat.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(
                          alpha: 0.1,
                        ) // 🟢 Updated to withValues
                      : maxReached
                      ? (isDark
                            ? AppColors.darkBackground
                            : const Color(0xFFFAFAFA)) // 🟢 Dynamic Disabled BG
                      : theme.cardColor, // 🟢 Dynamic Default BG
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(
                            alpha: 0.5,
                          ) // 🟢 Updated to withValues
                        : maxReached
                        ? (isDark
                              ? AppColors.darkDivider
                              : const Color(
                                  0xFFEEEEEE,
                                )) // 🟢 Dynamic Disabled Border
                        : (isDark
                              ? AppColors.darkCardBorder
                              : AppColors
                                    .cardBorder), // 🟢 Dynamic Default Border
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : maxReached
                            ? (isDark
                                  ? AppColors.darkSurfaceElevated
                                  : const Color(
                                      0xFFF0F0F0,
                                    )) // 🟢 Dynamic Disabled Icon BG
                            : (isDark
                                  ? AppColors.darkSurfaceElevated
                                  : const Color(
                                      0xFFF5F5F5,
                                    )), // 🟢 Dynamic Default Icon BG
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _buildCategoryIcon(
                          cat.iconUrl,
                          isSelected,
                          maxReached,
                          isDark, // 🟢 Pass Theme State
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        cat
                            .name
                            .tr, // 🟢 Translatable categories (if mapped locally)
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: maxReached
                              ? (isDark
                                    ? AppColors.darkTextHint
                                    : const Color(
                                        0xFFCCCCCC,
                                      )) // 🟢 Dynamic Disabled Text
                              : isSelected
                              ? (isDark
                                    ? Colors.white
                                    : AppColors
                                          .textPrimary) // 🟢 Dynamic Active Text
                              : theme
                                    .textTheme
                                    .bodyLarge
                                    ?.color, // 🟢 Dynamic Default Text
                        ),
                      ),
                    ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isSelected
                          ? Container(
                              key: const ValueKey('checked'),
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              key: const ValueKey('unchecked'),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: maxReached
                                      ? (isDark
                                            ? AppColors.darkDivider
                                            : const Color(
                                                0xFFEEEEEE,
                                              )) // 🟢 Dynamic Disabled Radio
                                      : (isDark
                                            ? AppColors.darkCardBorder
                                            : const Color(
                                                0xFFCCCCCC,
                                              )), // 🟢 Dynamic Default Radio
                                  width: 1.5,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }
}
