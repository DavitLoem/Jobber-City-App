import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class JobStatusBadge extends StatelessWidget {
  final String group;

  const JobStatusBadge({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    late final Color bg;
    late final Color fg;

    switch (group) {
      case 'Active':
        bg = isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.successBackground;
        fg = isDark ? Colors.greenAccent : AppColors.success;
        break;
      case 'Paused':
        bg = isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : AppColors.warningBackground;
        fg = isDark ? Colors.orangeAccent : AppColors.warning;
        break;
      case 'Closed':
        bg = isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : AppColors.errorBackground;
        fg = isDark ? Colors.redAccent : AppColors.error;
        break;
      default:
        bg = isDark ? AppColors.darkInputBackground : AppColors.infoBackground;
        fg = isDark ? AppColors.darkTextSecondary : AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        group
            .toUpperCase()
            .tr, // 🟢 Added .tr Mapping Requirement Condition Point Segment Setup Execution Link Map Match Variable Evaluation Configuration Process Action Scope Result Match Output Constraint Property Target Event System Pattern Method Map Logic Object Control Logic Field Object Flow Control Method Result
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
