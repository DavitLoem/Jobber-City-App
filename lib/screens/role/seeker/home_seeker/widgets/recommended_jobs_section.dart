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
      height: 235,
      child: Obx(() {
        if (controller.isRecommendedLoading.value &&
            controller.recommendedJobs.isEmpty) {
          return _buildRecommendedSkeleton();
        }
        if (controller.recommendedJobs.isEmpty) {
          return JobUiUtils.buildInlineEmptyState(
            'No recommended jobs found'.tr, // 🟢 Added .tr
          );
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
            clipBehavior: Clip.none,
            itemCount:
                controller.recommendedJobs.length +
                (controller.hasMoreRecommended.value ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(width: 16),
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
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (context, index) =>
          const ShimmerBox(width: 240, height: 235, borderRadius: 24),
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

    final Color cardBackground = isDark
        ? AppColors.darkSurfaceElevated
        : const Color(0xFF141226);
    const Color textWhite = Colors.white;
    final Color textSubtitle = Colors.grey.shade400;

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
          width: 240,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : const Color(0xFF141226).withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: job.logoUrl != null && job.logoUrl!.isNotEmpty
                          ? Image.network(job.logoUrl!, fit: BoxFit.cover)
                          : const Icon(
                              Icons.business_rounded,
                              color: Colors.white,
                            ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => controller.toggleSaveRecommendedJob(index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        job.isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: job.isSaved
                            ? const Color(0xFF4F7DF7)
                            : Colors.grey.shade400,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                job.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textWhite,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              Text(
                job.companyName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4F7DF7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: textSubtitle,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.location.tr,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: textSubtitle,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F9D58).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job.employmentType.tr,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4ADE80),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "\$${job.minSalary.toInt()} - \$${job.maxSalary.toInt()}/${JobUiUtils.periodShort(job.salaryPeriod).tr}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textWhite,
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
