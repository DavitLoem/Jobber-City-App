import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobActionBottomSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onPause;
  final VoidCallback onDuplicate;
  final VoidCallback onCloseJob;
  final VoidCallback onDelete;

  final String pauseLabel;
  final IconData pauseIcon;

  const JobActionBottomSheet({
    super.key,
    required this.onEdit,
    required this.onShare,
    required this.onPause,
    required this.onDuplicate,
    required this.onCloseJob,
    required this.onDelete,
    this.pauseLabel = "Pause Job",
    this.pauseIcon = LucideIcons.pause,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 30),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : Colors.white, // 🟢 Dynamic Sheet BG
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkDivider
                    : Colors.grey.shade300, // 🟢 Dynamic Handle
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Job Actions".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Title
              ),
            ),
          ),
          const SizedBox(height: 10),

          _buildActionItem(
            icon: LucideIcons.pencil,
            label: "Edit Job".tr, // 🟢 Added .tr
            onTap: onEdit,
            isDark: isDark,
          ),
          _buildActionItem(
            icon: LucideIcons.upload,
            label: "Share".tr, // 🟢 Added .tr
            onTap: onShare,
            isDark: isDark,
          ),
          _buildActionItem(
            icon: pauseIcon,
            label: pauseLabel.tr, // 🟢 Passed translated label
            onTap: onPause,
            isDark: isDark,
          ),
          _buildActionItem(
            icon: LucideIcons.copy,
            label: "Duplicate Job".tr, // 🟢 Added .tr
            onTap: onDuplicate,
            isDark: isDark,
          ),
          _buildActionItem(
            icon: LucideIcons.archive,
            label: "Close Job".tr, // 🟢 Added .tr
            onTap: onCloseJob,
            isDark: isDark,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(
              color: isDark ? AppColors.darkDivider : const Color(0xFFF3F4F6),
              height: 1,
            ), // 🟢 Dynamic Divider
          ),

          _buildActionItem(
            icon: LucideIcons.trash2,
            label: "Delete Job".tr, // 🟢 Added .tr
            isDestructive: true,
            onTap: onDelete,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
    required bool isDark,
  }) {
    final color = isDestructive
        ? (isDark ? Colors.redAccent : Colors.red)
        : (isDark ? Colors.white : Colors.black87);
    final bgColor = isDestructive
        ? (isDark
              ? AppColors.error.withValues(alpha: 0.15)
              : Colors.red.shade50)
        : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50);
    final iconColor = isDestructive
        ? (isDark ? Colors.redAccent : Colors.red)
        : (isDark ? AppColors.darkIconSecondary : Colors.grey.shade700);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
