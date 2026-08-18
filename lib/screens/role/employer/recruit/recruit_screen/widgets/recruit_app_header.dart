import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: Colors.transparent,
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
                    color: theme.textTheme.bodyLarge?.color,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  totalJobs == 1
                      ? '@total total post'.trParams({
                          'total': totalJobs.toString(),
                        })
                      : '@total total posts'.trParams({
                          'total': totalJobs.toString(),
                        }), // 🟢 Added .trParams
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          _NewJobButton(onTap: onNewJob, isDark: isDark),
        ],
      ),
    );
  }
}

class _NewJobButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _NewJobButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.primary.withValues(
                      alpha: 0.8,
                    ), // 🟢 Updated to withValues
                    AppColors.secondary.withValues(
                      alpha: 0.8,
                    ), // 🟢 Updated to withValues
                  ]
                : [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlue.withValues(
                alpha: isDark ? 0.3 : 0.5, // 🟢 Updated to withValues
              ),
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
