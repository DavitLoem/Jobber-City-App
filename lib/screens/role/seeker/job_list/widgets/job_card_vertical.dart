import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for .tr
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/screens/role/seeker/home_seeker/widgets/job_ui_utils.dart';

class JobCardVertical extends StatelessWidget {
  final JobFeedModel job;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;
  final bool isDark; // 🟢 Added
  final ThemeData theme; // 🟢 Added

  const JobCardVertical({
    super.key,
    required this.job,
    required this.onTap,
    required this.onBookmarkTap,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor, // 🟢 Dynamic BG
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          ), // 🟢 Dynamic Border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04), // 🟢 Dynamic Shadow
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobUiUtils.buildCompanyLogo(
                  job.logoUrl,
                  job.companyName,
                  size: 46,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        job.companyName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                JobUiUtils.buildBookmarkButton(
                  isSaved: job.isSaved,
                  onTap: onBookmarkTap, 
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 13,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary, // 🟢 Dynamic Location Icon
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    job.location.tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary, // 🟢 Dynamic Location Text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.north_east_rounded,
                  size: 13,
                  color: isDark ? Colors.greenAccent : AppColors.success, // 🟢 Dynamic Tag Icon
                ),
                const SizedBox(width: 3),
                Text(
                  "\$${job.maxSalary.toInt()}/${JobUiUtils.periodShort(job.salaryPeriod).tr}", // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.greenAccent : AppColors.success, // 🟢 Dynamic Tag Text
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      JobUiUtils.buildTag(job.employmentType),
                      JobUiUtils.buildTag(job.workType),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Apply Now".tr, // 🟢 Added .tr
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}