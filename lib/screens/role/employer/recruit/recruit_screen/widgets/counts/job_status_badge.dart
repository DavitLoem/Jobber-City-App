import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// Small colored pill showing the normalized status group
/// (Active / Paused / Draft / Closed).
class JobStatusBadge extends StatelessWidget {
  final String group;

  const JobStatusBadge({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;

    switch (group) {
      case 'Active':
        bg = AppColors.successBackground;
        fg = AppColors.success;
        break;
      case 'Paused':
        bg = AppColors.warningBackground;
        fg = AppColors.warning;
        break;
      case 'Closed':
        bg = AppColors.errorBackground;
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.infoBackground;
        fg = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        group.toUpperCase(),
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
