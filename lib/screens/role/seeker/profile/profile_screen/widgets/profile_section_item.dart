import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class ProfileSectionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isCompleted;
  final bool isResume;

  const ProfileSectionItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isCompleted = false,
    this.isResume = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    IconData rightIcon;
    Color rightIconColor;
    Color rightBgColor;

    if (!isCompleted) {
      rightIcon = Icons.add;
      rightIconColor = AppColors.primary;
      rightBgColor = isDark
          ? AppColors.primary.withValues(alpha: 0.2)
          : AppColors.primaryLight;
    } else if (isResume) {
      rightIcon = Icons.check_circle;
      rightIconColor = isDark ? Colors.greenAccent : Colors.green;
      rightBgColor = isDark
          ? Colors.green.withValues(alpha: 0.15)
          : Colors.green.shade50;
    } else {
      rightIcon = Icons.arrow_forward_ios_rounded;
      rightIconColor = isDark
          ? AppColors.darkTextSecondary
          : Colors.grey.shade400;
      rightBgColor = isDark
          ? AppColors.darkSurfaceElevated
          : Colors.grey.shade50;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : AppColors.cardBorder.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? (isDark
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.primaryLight.withValues(alpha: 0.5))
                        : (isDark
                              ? AppColors.darkSurfaceElevated
                              : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isCompleted
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey.shade600),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: rightBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(rightIcon, size: 15, color: rightIconColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
