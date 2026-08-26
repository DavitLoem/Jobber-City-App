import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart';

class ScanningOverlay extends StatelessWidget {
  final VoidCallback onCancel;

  const ScanningOverlay({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.black.withValues(
            alpha: 0.3,
          ), // 🟢 Uses modern withValues
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.white, // 🟢 Dynamic Modal BG
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 24),
                  Text(
                    'AI is analyzing your CV...'.tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This might take a few seconds.'.tr, // 🟢 Added .tr
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade600, // 🟢 Dynamic Subtext
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🎯 ២. ប៊ូតុង Cancel សម្រាប់កាត់ផ្តាច់
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel'.tr, // 🟢 Added .tr
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
