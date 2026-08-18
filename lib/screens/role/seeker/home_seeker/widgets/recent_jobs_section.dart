import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

import '../home_seeker_view.dart';
import 'job_ui_utils.dart';
import 'shimmer_box.dart';

class RecentJobsSection extends GetView<HomeSeekerViewController> {
  const RecentJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDynamicFilters(categoryController, context),
        const SizedBox(height: 16),
        _buildJobRecentList(context),
      ],
    );
  }

  Widget _buildDynamicFilters(
    CategoryController categoryCtrl,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: Obx(() {
        if (categoryCtrl.isLoading.value && categoryCtrl.categories.isEmpty) {
          return const ShimmerBox(
            width: double.infinity,
            height: 38,
            borderRadius: 20,
          );
        }

        final currentSelectedId = controller.selectedCategoryId.value;
        final allItem = {'id': '', 'name': 'All'};
        final items = [
          allItem,
          ...categoryCtrl.categories.map((c) => {'id': c.id, 'name': c.name}),
        ];

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = currentSelectedId == item['id'];

            return GestureDetector(
              onTap: () => controller.onCategorySelected(item['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.darkCardBorder
                              : AppColors.cardBorder),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: 0.25,
                            ), // 🟢 Updated Opacity
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  item['name']!
                      .tr, // 🟢 Added .tr (For "All" and potential category name translations)
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildJobRecentList(BuildContext context) {
    return Obx(() {
      if (controller.isRecentLoading.value && controller.recentJobs.isEmpty) {
        return Column(
          children: List.generate(
            3,
            (i) => const Padding(
              padding: EdgeInsets.only(bottom: 14, top: 24),
              child: ShimmerBox(
                width: double.infinity,
                height: 168,
                borderRadius: 20,
              ),
            ),
          ),
        );
      }

      final jobs = controller.recentJobs;

      if (jobs.isEmpty) {
        return JobUiUtils.buildInlineEmptyState(
          'No jobs found for this category'.tr, // 🟢 Added .tr
          topPadding: 20,
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: jobs.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == jobs.length) {
            if (controller.isRecentLoadingMore.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }
            return const SizedBox.shrink();
          }
          final job = jobs[index];
          return _buildRecentJobCard(job, index, index, context);
        },
      );
    });
  }

  Widget _buildRecentJobCard(
    JobFeedModel job,
    int index,
    int staggerIndex,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (staggerIndex * 60).clamp(0, 300)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 14 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.jobDetail, arguments: job)?.then((updatedJob) {
            if (updatedJob != null) {
              int i = controller.recentJobs.indexOf(job);
              if (i != -1) controller.recentJobs[i] = updatedJob;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
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
                      ],
                    ),
                  ),
                  JobUiUtils.buildBookmarkButton(
                    isSaved: job.isSaved,
                    onTap: () => controller.toggleSaveRecentJob(index),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                      job.location.tr, // 🟢 Translated Location if applicable
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
                  Icon(
                    Icons.north_east_rounded,
                    size: 13,
                    color: isDark ? Colors.greenAccent : AppColors.success,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "\$${job.maxSalary.toInt()}/${JobUiUtils.periodShort(job.salaryPeriod)}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.greenAccent : AppColors.success,
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
      ),
    );
  }
}
