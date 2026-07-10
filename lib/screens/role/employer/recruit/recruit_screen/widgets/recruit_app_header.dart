import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/widgets/arrow_key_back.dart';

/// Top header for the "My Jobs" screen.
///
/// Shows the back arrow, screen title, a live post count, and the primary
/// "New Job" action. Kept dumb/presentational — all data comes in as
/// plain params so it never needs to know about GetX or the controller.
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: AppColors.white,
      child: Row(
        children: [
          const ArrowKeyBack(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Jobs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalJobs total post${totalJobs == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          _NewJobButton(onTap: onNewJob),
        ],
      ),
    );
  }
}

class _NewJobButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NewJobButton({required this.onTap});

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
              color: AppColors.shadowBlue,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 18, color: AppColors.white),
            SizedBox(width: 6),
            Text(
              'New Job',
              style: TextStyle(
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
