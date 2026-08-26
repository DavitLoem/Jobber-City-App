import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/core/api/services/role/employer/job_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/job_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/my_job/widgets/job_card_item.dart';
import 'package:jobber_city/screens/role/employer/my_job/widgets/job_search_bar.dart';
import 'package:jobber_city/screens/role/employer/my_job/widgets/job_status_tabs.dart';
import 'package:jobber_city/widgets/confirm_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/utils/debouncer.dart';
import '../candidates/candidates_view.dart';
import '../employer_profile/employer_profile_view.dart';
import '../main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'widgets/job_action_bottom_sheet.dart';
import 'widgets/job_card_skeleton.dart';

part 'my_job_binding.dart';
part 'my_job_controller.dart';

class MyJobView extends GetView<MyJobViewController> {
  const MyJobView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic Base BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        title: Text(
          'My Jobs'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title Text
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: _buildNewJobButton()),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => JobSearchBar(
              searchController: controller.searchController,
              onChanged: controller.onSearchChanged,
              currentSort: controller.currentSort.value,
              onSortChanged: controller.changeSortOption,
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            final summary = controller.statusSummary;
            final allCount = summary['all'] ?? 0;
            final activeCount = summary['active'] ?? 0;
            final pausedCount = summary['paused'] ?? 0;
            final closedCount = summary['closed'] ?? 0;
            final draftCount = summary['draft'] ?? 0;

            final tabList = [
              'All (@count)'.trParams({
                'count': allCount.toString(),
              }), // 🟢 Applied localized count
              'Active (@count)'.trParams({'count': activeCount.toString()}),
              'Paused (@count)'.trParams({'count': pausedCount.toString()}),
              'Closed (@count)'.trParams({'count': closedCount.toString()}),
              'Draft (@count)'.trParams({'count': draftCount.toString()}),
            ];

            // Map translated strings directly
            final selectedStr = tabList.firstWhere(
              (t) =>
                  t.contains(controller.seletedTab.value.tr) ||
                  t.contains(controller.seletedTab.value),
              orElse: () => tabList[0],
            );

            return JobStatusTabs(
              tabs: tabList,
              selectedTab: selectedStr,
              onTabChanged: controller.changeTab,
            );
          }),
          const SizedBox(height: 20),

          Expanded(
            child: _buildJobList(context, isDark),
          ), // 🟢 Passed Theme State
        ],
      ),
    );
  }

  // ==========================================
  // ── 1. Function សម្រាប់សាងសង់បញ្ជីការងារ (List View)
  // ==========================================
  Widget _buildJobList(BuildContext context, bool isDark) {
    return Obx(() {
      final currentList = controller.displayJobs;

      final profileCtrl = Get.find<EmployerProfileViewController>();
      final profile = profileCtrl.companyProfile.value;

      final hasLogo =
          profile != null &&
          profile.logoUrl != null &&
          profile.logoUrl!.isNotEmpty;

      final logoUrl = hasLogo ? profile.logoUrl! : null;

      if (controller.isLoading.value) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: 5,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, _) => const JobCardSkeleton(),
        );
      }

      if (currentList.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async => await controller.fetchJobs(isRefresh: true),
          color: AppColors.primary,
          backgroundColor: isDark
              ? AppColors.darkSurfaceElevated
              : Colors.white, // 🟢 Dynamic Component BG
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.inbox,
                    size: 48,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : Colors.grey.shade300, // 🟢 Dynamic Empty Icon
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No jobs found in this status".tr, // 🟢 Added .tr
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade500,
                      fontSize: 16,
                    ), // 🟢 Dynamic Empty Text
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => await controller.fetchJobs(isRefresh: true),
        color: AppColors.primary,
        backgroundColor: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Component BG
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount:
              currentList.length + (controller.isLoadingMore.value ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == currentList.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            final job = currentList[index];

            return JobCardItem(
              title: job.title,
              logoUrl: logoUrl,
              department: _getDepartmentName(job.categoryId),
              location: _getLocationName(job.provinceId),
              timeAgo: _getTimeAgo(job.createdAt),
              status: job.status.isEmpty ? 'draft' : job.status,
              isUrgent: false,
              candidatesCount: job.applicantCount,
              avatars: job.applicantAvatars,
              onTap: () {
                Get.toNamed(AppRoutes.myJobDetail, arguments: job.id);
              },
              onCandidatesTap: () {
                if (Get.isRegistered<MainScreenEmloyerController>()) {
                  final mainCtrl = Get.find<MainScreenEmloyerController>();
                  mainCtrl.changeTab(2);
                }

                if (Get.isRegistered<CandidatesViewController>()) {
                  final candidateCtrl = Get.find<CandidatesViewController>();
                  candidateCtrl.selectedJobId.value = job.id;
                  candidateCtrl.fetchApplicants(isRefresh: true);
                  candidateCtrl.fetchStatusSummary();
                } else {
                  Get.put(CandidatesViewController());
                  final candidateCtrl = Get.find<CandidatesViewController>();
                  candidateCtrl.selectedJobId.value = job.id;
                }
              },
              onMoreTap: () => _showJobActionSheet(context, job.id),
            );
          },
        ),
      );
    });
  }

  // ==========================================
  // ── 2. Function សម្រាប់បង្ហាញ Job Action Bottom Sheet
  // ==========================================
  void _showJobActionSheet(BuildContext context, String targetJobId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Obx(() {
          final actualJob = controller.jobs.firstWhere(
            (j) => j.id == targetJobId,
            orElse: () => throw Exception('Job not found'),
          );

          final statusLower = actualJob.status.trim().toLowerCase();
          final isCurrentlyInactive =
              statusLower == 'inactive' || statusLower == 'paused';
          final isCurrentlyClosed = statusLower == 'closed';
          final isDraft = statusLower == 'draft';

          return JobActionBottomSheet(
            pauseLabel: isCurrentlyInactive
                ? "Resume Job".tr
                : "Pause Job".tr, // 🟢 Added .tr
            pauseIcon: isCurrentlyInactive
                ? LucideIcons.play
                : LucideIcons.pause,

            onEdit: () {
              Get.back();
              Get.toNamed(AppRoutes.newJob, arguments: actualJob);
            },

            onShare: () {},

            onPause: (isCurrentlyClosed || isDraft)
                ? () {}
                : () {
                    Get.back();

                    final newStatus = isCurrentlyInactive
                        ? 'active'
                        : 'inactive';
                    final titleText = isCurrentlyInactive
                        ? "Resume Job?"
                              .tr // 🟢 Added .tr
                        : "Pause Job?".tr; // 🟢 Added .tr
                    final messageText = isCurrentlyInactive
                        ? "Are you sure you want to resume this job? It will be visible to candidates again."
                              .tr // 🟢 Added .tr
                        : "Are you sure you want to pause this job? It will be temporarily hidden from candidates."
                              .tr; // 🟢 Added .tr

                    Get.dialog(
                      ConfirmDialog(
                        title: titleText,
                        message: messageText,
                        confirmText: isCurrentlyInactive
                            ? "Resume".tr
                            : "Pause".tr, // 🟢 Added .tr
                        cancelText: "Cancel".tr, // 🟢 Added .tr
                        isDestructive: !isCurrentlyInactive,
                        onConfirm: () {
                          controller.changeJobStatus(actualJob.id, newStatus);
                        },
                      ),
                    );
                  },

            onDuplicate: () {},

            onCloseJob: (isCurrentlyClosed || isDraft)
                ? () {}
                : () {
                    Get.back();
                    Get.dialog(
                      ConfirmDialog(
                        title: "Close Job?".tr, // 🟢 Added .tr
                        message:
                            "Are you sure you want to close this job? Candidates will no longer be able to apply."
                                .tr, // 🟢 Added .tr
                        confirmText: "Close Job".tr, // 🟢 Added .tr
                        cancelText: "Cancel".tr, // 🟢 Added .tr
                        onConfirm: () {
                          controller.changeJobStatus(actualJob.id, 'closed');
                        },
                      ),
                    );
                  },

            onDelete: () {
              Get.back();
              Get.dialog(
                ConfirmDialog(
                  title: "Delete Job?".tr, // 🟢 Added .tr
                  message:
                      "Are you sure you want to delete this job? This action cannot be undone."
                          .tr, // 🟢 Added .tr
                  confirmText: "Delete".tr, // 🟢 Added .tr
                  cancelText: "Cancel".tr, // 🟢 Added .tr
                  isDestructive: true,
                  onConfirm: () {
                    controller.deleteJob(actualJob.id);
                  },
                ),
              );
            },
          );
        });
      },
    );
  }

  // ==========================================
  // ── 3. Helper Functions (សម្រាប់បំប្លែងទិន្នន័យ)
  // ==========================================

  String _getLocationName(String provinceId) {
    if (Get.isRegistered<LocationController>()) {
      try {
        final locCtrl = Get.find<LocationController>();
        return locCtrl.provinces.firstWhere((p) => p.id == provinceId).nameEn;
      } catch (_) {}
    }
    return "Unknown Location".tr; // 🟢 Added .tr
  }

  String _getDepartmentName(String categoryId) {
    if (Get.isRegistered<CategoryController>()) {
      try {
        final catCtrl = Get.find<CategoryController>();
        return catCtrl.categories.firstWhere((c) => c.id == categoryId).name;
      } catch (_) {}
    }
    return "General".tr; // 🟢 Added .tr
  }

  String _getTimeAgo(String createdAt) {
    try {
      String dateStr = createdAt;
      if (!dateStr.endsWith('Z')) {
        dateStr += 'Z';
      }

      final createdDate = DateTime.parse(dateStr).toLocal();
      final difference = DateTime.now().difference(createdDate);

      if (difference.inDays > 0)
        return "@daysd ago".trParams({
          'days': difference.inDays.toString(),
        }); // 🟢 Added .trParams
      if (difference.inHours > 0)
        return "@hoursh ago".trParams({
          'hours': difference.inHours.toString(),
        }); // 🟢 Added .trParams
      if (difference.inMinutes > 0)
        return "@minsm ago".trParams({
          'mins': difference.inMinutes.toString(),
        }); // 🟢 Added .trParams
    } catch (_) {}
    return "Just now".tr; // 🟢 Added .tr
  }

  // ── ប៊ូតុង + New Job ──
  Widget _buildNewJobButton() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E8AFF), Color(0xFF3F6CF5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F6CF5).withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Get.toNamed(AppRoutes.newJob),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.plus, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'New Job'.tr, // 🟢 Added .tr
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
