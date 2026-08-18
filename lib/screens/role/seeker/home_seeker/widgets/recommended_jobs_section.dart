import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

import '../home_seeker_view.dart';
import 'job_ui_utils.dart';
import 'shimmer_box.dart';

class RecommendedJobsSection extends GetView<HomeSeekerViewController> {
  const RecommendedJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 226,
      child: Obx(() {
        if (controller.isRecommendedLoading.value &&
            controller.recommendedJobs.isEmpty) {
          return _buildRecommendedSkeleton();
        }
        if (controller.recommendedJobs.isEmpty) {
          return JobUiUtils.buildInlineEmptyState(
            'No recommended jobs found'.tr,
          ); // 🟢 Added .tr
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isRecommendedLoadingMore.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 50) {
              controller.fetchJobRecommended();
            }
            return false;
          },
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount:
                controller.recommendedJobs.length +
                (controller.hasMoreRecommended.value ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              if (index == controller.recommendedJobs.length) {
                return _buildLoadingIndicator();
              }
              final job = controller.recommendedJobs[index];
              return _buildRecommendedJobCard(job, index, index, context);
            },
          ),
        );
      }),
    );
  }

  Widget _buildRecommendedSkeleton() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: 14),
      itemBuilder: (context, index) =>
          const ShimmerBox(width: 250, height: 226, borderRadius: 20),
    );
  }

  Widget _buildRecommendedJobCard(
    JobFeedModel job,
    int index,
    int staggerIndex,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (staggerIndex * 80).clamp(0, 320)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.jobDetail, arguments: job)?.then((updatedJob) {
            if (updatedJob != null) {
              int i = controller.recommendedJobs.indexOf(job);
              if (i != -1) controller.recommendedJobs[i] = updatedJob;
            }
          });
        },
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.2 : 0.04, // 🟢 Updated opacity
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
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
                    size: 44,
                  ),
                  const Spacer(),
                  JobUiUtils.buildBookmarkButton(
                    isSaved: job.isSaved,
                    onTap: () => controller.toggleSaveRecommendedJob(index),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job.title,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 13,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      job.location.tr, // 🟢 Translated Location
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              JobUiUtils.buildTag(job.employmentType),
              const Spacer(),
              Text(
                "\$${job.minSalary.toInt()} - \$${job.maxSalary.toInt()}/${JobUiUtils.periodShort(job.salaryPeriod)}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 80,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
