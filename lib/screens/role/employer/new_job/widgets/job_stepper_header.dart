import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobStepperHeader extends StatelessWidget {
  final int currentStep;

  const JobStepperHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> steps = [
      {'title': 'Basic Info'.tr, 'icon': LucideIcons.info}, // 🟢 Added .tr
      {'title': 'Salary'.tr, 'icon': LucideIcons.banknote}, // 🟢 Added .tr
      {'title': 'Details'.tr, 'icon': LucideIcons.fileText}, // 🟢 Added .tr
      {'title': 'Schedule'.tr, 'icon': LucideIcons.calendar}, // 🟢 Added .tr
    ];

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20, right: 20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : Colors.white, // 🟢 Dynamic Header BG
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
            width: 1,
          ),
        ), // 🟢 Dynamic Bottom Border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index % 2 != 0) {
            final stepIndex = index ~/ 2;
            final isLineCompleted = currentStep > stepIndex;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 18),
                height: 2,
                color: isLineCompleted
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkDivider
                          : Colors.grey.shade200), // 🟢 Dynamic Inactive Line
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isActive = currentStep == stepIndex;
          final isCompleted = currentStep > stepIndex;

          Color iconColor;
          Color circleColor;
          Color borderColor;

          if (isCompleted) {
            iconColor = Colors.white;
            circleColor = AppColors.primary;
            borderColor = AppColors.primary;
          } else if (isActive) {
            iconColor = isDark
                ? Colors.blueAccent
                : AppColors.primary; // 🟢 Dynamic Active Icon Color
            circleColor = AppColors.primary.withValues(
              alpha: isDark ? 0.2 : 0.1,
            ); // 🟢 Dynamic Active Outline Tint
            borderColor = isDark
                ? Colors.blueAccent
                : AppColors.primary; // 🟢 Dynamic Active Border
          } else {
            iconColor = isDark
                ? AppColors.darkIconSecondary
                : Colors.grey.shade400; // 🟢 Dynamic Inactive Icon Color
            circleColor = isDark
                ? AppColors.darkInputBackground
                : Colors.white; // 🟢 Dynamic Inactive Circle BG
            borderColor = isDark
                ? AppColors.darkCardBorder
                : Colors.grey.shade300; // 🟢 Dynamic Inactive Border
          }

          return SizedBox(
            width: 65,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: isActive ? 2 : 1.5,
                    ),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_rounded
                        : steps[stepIndex]['icon'],
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    steps[stepIndex]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive || isCompleted
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isActive || isCompleted
                          ? (isDark
                                ? Colors.blueAccent
                                : AppColors
                                      .primary) // 🟢 Dynamic Active Text Label
                          : (isDark
                                ? AppColors.darkTextSecondary
                                : Colors
                                      .grey
                                      .shade400), // 🟢 Dynamic Inactive Text Label
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
