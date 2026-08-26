import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/auth/create_acc_screen/create_acc_screen_view.dart';

class AnimatedTabBar extends StatelessWidget {
  final CreateAccScreenViewController controller;

  const AnimatedTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkInputBackground
            : AppColors.inputBackground, // 🟢 Dynamic Track BG
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // The Sliding White Indicator
          Obx(
            () => AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              alignment: controller.selectedIndex.value == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceElevated
                        : Colors.white, // 🟢 Dynamic Active Indicator BG
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.3 : 0.05,
                        ), // 🟢 Dynamic Shadow
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // The Text Labels
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.changeTab(0),
                  child: Obx(
                    () => Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: controller.selectedIndex.value == 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: controller.selectedIndex.value == 0
                              ? (isDark
                                    ? Colors.white
                                    : AppColors
                                          .textPrimary) // 🟢 Dynamic Selected Text
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors
                                          .textSecondary), // 🟢 Dynamic Unselected Text
                        ),
                        child: Text('Seeker'.tr), // 🟢 Added .tr
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.changeTab(1),
                  child: Obx(
                    () => Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: controller.selectedIndex.value == 1
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: controller.selectedIndex.value == 1
                              ? (isDark
                                    ? Colors.white
                                    : AppColors
                                          .textPrimary) // 🟢 Dynamic Selected Text
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors
                                          .textSecondary), // 🟢 Dynamic Unselected Text
                        ),
                        child: Text('Employer'.tr), // 🟢 Added .tr
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
