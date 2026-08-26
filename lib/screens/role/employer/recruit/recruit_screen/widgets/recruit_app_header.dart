import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get to support .tr
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/widgets/arrow_key_back.dart';

class RecruitAppHeader extends StatelessWidget {
  final int totalJobs;
  final VoidCallback onNewJob;

  const RecruitAppHeader({
    super.key,
    required this.totalJobs,
    required this.onNewJob,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: isDark
          ? AppColors.darkBackground
          : AppColors.white, // 🟢 Dynamic Top Bar BG
      child: Row(
        children: [
          const ArrowKeyBack(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Jobs'.tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary, // 🟢 Dynamic Title
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@count total posts'.trParams({
                    'count': totalJobs.toString(),
                  }), // 🟢 Added .trParams mapping
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary, // 🟢 Dynamic Counter Style
                  ),
                ),
              ],
            ),
          ),
          _NewJobButton(
            onTap: onNewJob,
            isDark: isDark,
          ), // 🟢 Passed Theme Value
        ],
      ),
    );
  }
}

class _NewJobButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark; // 🟢 Added State Checker

  const _NewJobButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : AppColors
                        .shadowBlue, // 🟢 Drop outer shadow on dark themes to minimize bleed
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 18, color: AppColors.white),
            const SizedBox(width: 6),
            Text(
              'New Job'.tr, // 🟢 Added .tr
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
