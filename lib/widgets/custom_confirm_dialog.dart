import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final Color confirmColor;
  final IconData? icon;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
    this.confirmText,
    this.cancelText,
    this.confirmColor = Colors.redAccent,
    this.icon = LucideIcons.trash2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: isDark
          ? AppColors.darkSurfaceElevated
          : Colors.white, // 🟢 Dynamic BG
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: confirmColor.withValues(
                  alpha: isDark ? 0.2 : 0.1,
                ), // 🟢 Visibility bump for dark mode
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: confirmColor, size: 36),
            ),
            const SizedBox(height: 20),

            Text(
              title
                  .tr, // 🟢 Assume Passed Value is Translated OR add .tr here as fallback
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Title
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              description.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade600, // 🟢 Dynamic Subtext
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : Colors.grey.shade300,
                      ), // 🟢 Dynamic Border
                    ),
                    child: Text(
                      cancelText ?? 'Cancel'.tr, // 🟢 Added .tr
                      style: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : Colors.black87, // 🟢 Dynamic Text
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText ?? 'Delete'.tr, // 🟢 Added .tr
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
