import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/bookmark_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/job_list/widgets/job_card_vertical.dart';

part 'save_job_screen_binding.dart';
part 'save_job_screen_controller.dart';

class SaveJobScreenView extends GetView<SaveJobScreenViewController> {
  const SaveJobScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.fetchSavedJobs(isRefresh: true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme, isDark),
              const SizedBox(height: 14),
              Expanded(
                child: Obx(() {
                  // ── ១. ពេលកំពុង Load លើកដំបូង ──
                  if (controller.isLoading.value &&
                      controller.savedJobs.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // ── ២. ពេលអត់មានការងារសោះ ──
                  final jobs = controller.filteredJobs;
                  if (jobs.isEmpty) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        alignment: Alignment.center,
                        child: _buildEmptyState(
                          theme,
                          isDark,
                        ), // 🟢 Passed Context Theme
                      ),
                    );
                  }

                  // ── ៣. បង្ហាញបញ្ជីការងារ និងភ្ជាប់ NotificationListener សម្រាប់ Pagination ──
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!controller.isLoadingMore.value &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 150) {
                        controller.fetchSavedJobs();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount:
                          jobs.length + (controller.hasMoreData.value ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == jobs.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        final job = jobs[index];

                        return JobCardVertical(
                          job: job,
                          theme:
                              theme, // 🟢 Passed Theme State for dynamic coloring in JobCard
                          isDark: isDark, // 🟢 Passed isDark State
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.jobDetail,
                              arguments: job,
                            )?.then((updatedJob) {
                              if (updatedJob != null &&
                                  updatedJob.isSaved == false) {
                                controller.savedJobs.removeWhere(
                                  (j) => j.id == job.id,
                                );
                              }
                            });
                          },
                          onBookmarkTap: () => controller.removeJob(job.id),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header: title + saved count ──
  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Saved Jobs'.tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    controller.savedJobs.length == 1
                        ? '@count job saved'.trParams({
                            'count': controller.savedJobs.length.toString(),
                          })
                        : '@count jobs saved'.trParams({
                            'count': controller.savedJobs.length.toString(),
                          }), // 🟢 Dynamic Translation Count
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textHint, // 🟢 Dynamic Subtext
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ──
  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    final hasAnySaved = controller.savedJobs.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.primaryLight, // 🟢 Dynamic Circle BG
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.bookmark_border_rounded,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          hasAnySaved
              ? 'No jobs match this filter'.tr
              : 'No Saved Jobs Yet'.tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hasAnySaved
              ? "Try a different filter, or clear it to see everything you've saved."
                    .tr // 🟢 Added .tr
              : "Tap the bookmark icon on any job to save it here for later."
                    .tr, // 🟢 Added .tr
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textTertiary, // 🟢 Dynamic Text
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),
        if (!hasAnySaved)
          GestureDetector(
            onTap: () {
              Get.back(); // Or Get.offNamed(AppRoutes.homeSeeker); depending on logic
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.28,
                    ), // 🟢 Updated to withValues
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                'Browse Jobs'.tr, // 🟢 Added .tr
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
