import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart';

class JobStatusBadge extends StatelessWidget {
  final String group;

  const JobStatusBadge({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    late final Color bg;
    late final Color fg;

    switch (group) {
      case 'Active':
        bg = isDark
            ? Colors.greenAccent.withValues(
                alpha: 0.15,
              ) // 🟢 Updated to withValues
            : AppColors.successBackground;
        fg = isDark ? Colors.greenAccent : AppColors.success;
        break;
      case 'Paused':
        bg = isDark
            ? Colors.orangeAccent.withValues(
                alpha: 0.15,
              ) // 🟢 Updated to withValues
            : AppColors.warningBackground;
        fg = isDark ? Colors.orangeAccent : AppColors.warning;
        break;
      case 'Closed':
        bg = isDark
            ? Colors.redAccent.withValues(
                alpha: 0.15,
              ) // 🟢 Updated to withValues
            : AppColors.errorBackground;
        fg = isDark ? Colors.redAccent : AppColors.error;
        break;
      default:
        bg = isDark ? AppColors.darkSurfaceElevated : AppColors.infoBackground;
        fg = isDark ? AppColors.darkTextHint : AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        group.tr, // 🟢 Added .tr for localized group label
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
