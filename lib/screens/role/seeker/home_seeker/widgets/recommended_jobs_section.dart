import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart'; // 🎯 ប្រើប្រាស់ Model ថ្មី
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
        if (controller.isRecommendedLoading.value) {
          return _buildRecommendedSkeleton();
        }
        if (controller.recommendedJobs.isEmpty) {
          return JobUiUtils.buildInlineEmptyState('No recommended jobs found');
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.recommendedJobs.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            if (index == controller.recommendedJobs.length) {
              return _buildSeeMoreRecommendedCard();
            }
            final job = controller.recommendedJobs[index];
            return _buildRecommendedJobCard(job, index, index);
          },
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
  ) {
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
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
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
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
                  const Icon(
                    Icons.location_on_rounded,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      job.location,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textTertiary,
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
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

  Widget _buildSeeMoreRecommendedCard() {
    return GestureDetector(
      onTap: () => Get.snackbar(
        'Recommended Jobs',
        'See all recommended jobs',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryLight,
        colorText: AppColors.primary,
      ),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "See More",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "Explore all jobs",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
