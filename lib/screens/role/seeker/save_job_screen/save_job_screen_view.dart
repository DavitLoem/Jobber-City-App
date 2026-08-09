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
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: RefreshIndicator(
          // 🎯 បន្ថែមមុខងារ Pull-to-Refresh
          color: AppColors.primary,
          onRefresh: () => controller.fetchSavedJobs(isRefresh: true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              // const SizedBox(height: 18),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Obx(() => _buildFilterChips()),
              // ),
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
                        child: _buildEmptyState(),
                      ),
                    );
                  }

                  // ── ៣. បង្ហាញបញ្ជីការងារ និងភ្ជាប់ NotificationListener សម្រាប់ Pagination ──
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      // 🎯 អូសសល់ 150px ដល់ក្រោម ឱ្យវាទាញយកទំព័របន្ទាប់
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
                        // 🎯 បង្ហាញរង្វង់ Loading នៅចុងបញ្ជី
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

                        // 🎯 ប្រើប្រាស់ Shared Widget ជំនួសការសរសេរកាតថ្មី
                        return JobCardVertical(
                          job: job,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.jobDetail,
                              arguments: job,
                            )?.then((updatedJob) {
                              // បើគាត់ចូលទៅ Unsave ក្នុង Job Detail ពេលថយក្រោយវិញ ឱ្យលុបចេញពីបញ្ជី
                              if (updatedJob != null &&
                                  updatedJob.isSaved == false) {
                                controller.savedJobs.removeWhere(
                                  (j) => j.id == job.id,
                                );
                              }
                            });
                          },
                          onBookmarkTap: () =>
                              controller.removeJob(job.id), // ហៅមុខងារ Unsave
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

  // ── Header: back button + title + saved count ──
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Saved Jobs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    '${controller.savedJobs.length} job${controller.savedJobs.length == 1 ? '' : 's'} saved',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
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

  // ── Filter chips (All / Remote / Onsite / Hybrid — derived from data) ──
  // Widget _buildFilterChips() {
  //   final options = controller.filterOptions;
  //   if (controller.savedJobs.isEmpty) return const SizedBox.shrink();
  //   return SizedBox(
  //     height: 38,
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: options.length,
  //       separatorBuilder: (_, __) => const SizedBox(width: 10),
  //       itemBuilder: (context, index) {
  //         final isSelected = controller.selectedFilterIndex.value == index;
  //         return GestureDetector(
  //           onTap: () => controller.selectedFilterIndex.value = index,
  //           child: AnimatedContainer(
  //             duration: const Duration(milliseconds: 200),
  //             padding: const EdgeInsets.symmetric(horizontal: 18),
  //             decoration: BoxDecoration(
  //               color: isSelected ? AppColors.primary : Colors.white,
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(
  //                 color: isSelected ? AppColors.primary : AppColors.cardBorder,
  //               ),
  //               boxShadow: isSelected
  //                   ? [
  //                       BoxShadow(
  //                         color: AppColors.primary.withValues(alpha: 0.25),
  //                         blurRadius: 10,
  //                         offset: const Offset(0, 4),
  //                       ),
  //                     ]
  //                   : [],
  //             ),
  //             alignment: Alignment.center,
  //             child: Text(
  //               options[index],
  //               style: TextStyle(
  //                 color: isSelected ? Colors.white : AppColors.primary,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 13.5,
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // ── Empty state ──
  Widget _buildEmptyState() {
    final hasAnySaved = controller.savedJobs.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
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
          hasAnySaved ? 'No jobs match this filter' : 'No Saved Jobs Yet',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hasAnySaved
              ? 'Try a different filter, or clear it to see everything you\'ve saved.'
              : 'Tap the bookmark icon on any job to save it here for later.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13.5,
            color: AppColors.textTertiary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),
        if (!hasAnySaved)
          GestureDetector(
            onTap: () {
              Get.back(); // ឬ Get.offNamed(AppRoutes.home);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                'Browse Jobs',
                style: TextStyle(
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
