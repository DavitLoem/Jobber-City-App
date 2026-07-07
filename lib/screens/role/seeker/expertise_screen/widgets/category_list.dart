import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/category_screen_view.dart';

class CategoryList extends StatelessWidget {
  final CategoryScreenViewController controller;
  const CategoryList({super.key, required this.controller});

  // 🎯 មុខងារត្រៀមសម្រាប់ Dynamic Icon និង Static Icon
  Widget _buildCategoryIcon(String? iconUrl, bool isSelected, bool maxReached) {
    // កំណត់ពណ៌ Icon ទៅតាមស្ថានភាព
    final Color iconColor = isSelected
        ? Colors.white
        : maxReached
        ? const Color(0xFFCCCCCC)
        : Colors.grey[600]!;

    // លក្ខខណ្ឌត្រៀម៖ បើមាន URL ត្រឹមត្រូវ (មិនមែន example) អាចបង្ហាញជារូបភាពបាន
    final bool hasValidDynamicIcon =
        iconUrl != null &&
        iconUrl.isNotEmpty &&
        !iconUrl.contains('example.com');

    if (hasValidDynamicIcon) {
      // ទៅថ្ងៃមុខ ពេលមានផ្ទាំង Admin អាចបើកកូដនេះ ដើម្បីបង្ហាញរូបភាពពិតពី Network
      /*
      return Image.network(
        iconUrl,
        width: 20,
        height: 20,
        color: iconColor, // ប្តូរពណ៌រូបភាពឱ្យស៊ីនឹងផ្ទៃខាងក្រោយ
        errorBuilder: (context, error, stackTrace) => Icon(Icons.work_outline_rounded, size: 20, color: iconColor),
      );
      */

      return Icon(Icons.work_outline_rounded, size: 20, color: iconColor);
    } else {
      return Icon(Icons.work_outline_rounded, size: 20, color: iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.categoriesList.isEmpty) {
        return const Center(child: Text("No expertise found."));
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
            // 🎯 បិទមិនឱ្យចុចបើវាលើសពី ៥
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
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : maxReached
                      ? const Color(0xFFFAFAFA)
                      : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : maxReached
                        ? const Color(0xFFEEEEEE)
                        : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon Box
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : maxReached
                            ? const Color(0xFFF0F0F0)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // 🎯 ហៅមុខងារ _buildCategoryIcon មកប្រើនៅទីនេះ
                      child: Center(
                        child: _buildCategoryIcon(
                          cat.iconUrl,
                          isSelected,
                          maxReached,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Label Text
                    Expanded(
                      child: Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: maxReached
                              ? const Color(0xFFCCCCCC)
                              : isSelected
                              ? AppColors.textPrimary
                              : Colors.grey[800],
                        ),
                      ),
                    ),

                    // Radio Check
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
                                      ? const Color(0xFFEEEEEE)
                                      : const Color(0xFFCCCCCC),
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
