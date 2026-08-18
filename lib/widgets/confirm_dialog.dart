import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: theme.cardColor, // 🟢 Dynamic Dialog BG
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // 🟢 Dynamic Icon BG
                color: isDestructive
                    ? (isDark
                          ? Colors.redAccent.withOpacity(0.15)
                          : Colors.red.shade50)
                    : (isDark
                          ? AppColors.primary.withOpacity(0.15)
                          : const Color(0xFFEEF2FF)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDestructive ? LucideIcons.trash2 : LucideIcons.info,
                color: isDestructive
                    ? (isDark ? Colors.redAccent : Colors.red)
                    : AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade600, // 🟢 Dynamic Message
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : Colors.grey.shade300,
                      ), // 🟢 Dynamic Border
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        color: theme
                            .textTheme
                            .bodyLarge
                            ?.color, // 🟢 Dynamic Button Text
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isDestructive
                          ? (isDark ? Colors.redAccent : Colors.red)
                          : AppColors.primary, // 🟢 Dynamic Primary Button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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
