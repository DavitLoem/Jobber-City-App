import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'change_password_binding.dart';
part 'change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordViewController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ), // 🟢 Dynamic Icon Color
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Change Password'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title Color
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── សារណែនាំ (Instruction) ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : const Color(0xFFF0F4FF), // 🟢 Dynamic Box BG
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : const Color(0xFFE8EEFF),
                ), // 🟢 Dynamic Border
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.info,
                    color: Color(0xFF4f7df7),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Your new password must be at least 8 characters long and include a mix of letters and numbers."
                          .tr, // 🟢 Added .tr
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey.shade700, // 🟢 Dynamic Subtext
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Form បញ្ចូលពាក្យសម្ងាត់ ──
            Obx(
              () => _buildPasswordField(
                label: "Current Password".tr, // 🟢 Added .tr
                hint: "Enter your current password".tr, // 🟢 Added .tr
                isObscured: controller.obscureCurrent.value,
                isDark: isDark,
                onToggleVisibility: controller.toggleCurrent,
              ),
            ),
            const SizedBox(height: 20),

            Divider(
              color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
              thickness: 1,
            ), // 🟢 Dynamic Divider
            const SizedBox(height: 20),

            Obx(
              () => _buildPasswordField(
                label: "New Password".tr, // 🟢 Added .tr
                hint: "Enter your new password".tr, // 🟢 Added .tr
                isObscured: controller.obscureNew.value,
                isDark: isDark,
                onToggleVisibility: controller.toggleNew,
              ),
            ),
            const SizedBox(height: 20),

            Obx(
              () => _buildPasswordField(
                label: "Confirm New Password".tr, // 🟢 Added .tr
                hint: "Re-enter your new password".tr, // 🟢 Added .tr
                isObscured: controller.obscureConfirm.value,
                isDark: isDark,
                onToggleVisibility: controller.toggleConfirm,
              ),
            ),

            const SizedBox(height: 40),

            // ── ប៊ូតុង Update Password ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // មុខងារហៅ API សម្រាប់ដូរ Password
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4f7df7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Update Password".tr, // 🟢 Added .tr
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ── មុខងារជំនួយ (Helper Widget) ──
  // ==========================================
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required bool isObscured,
    required bool isDark,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextSecondary
                : Colors.grey.shade700, // 🟢 Dynamic Label Color
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isObscured,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ), // 🟢 Dynamic Field Text
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
              fontSize: 15,
            ), // 🟢 Dynamic Hint Color
            prefixIcon: Icon(
              LucideIcons.lock,
              color: isDark
                  ? AppColors.darkIconSecondary
                  : Colors.grey.shade400, // 🟢 Dynamic Prefix Icon
              size: 20,
            ),
            // ប៊ូតុងភ្នែកសម្រាប់មើល/លាក់
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? LucideIcons.eyeOff : LucideIcons.eye,
                color: isDark
                    ? AppColors.darkIconSecondary
                    : Colors.grey.shade500, // 🟢 Dynamic Suffix Icon
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.darkInputBackground
                : Colors.grey.shade50, // 🟢 Dynamic Field BG
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ), // 🟢 Dynamic Border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ), // 🟢 Dynamic Border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4f7df7),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
