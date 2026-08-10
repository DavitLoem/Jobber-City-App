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
import '../employer_profile/employer_profile_view.dart';
import 'widgets/job_action_bottom_sheet.dart';
import 'widgets/job_card_skeleton.dart';

part 'my_job_binding.dart';
part 'my_job_controller.dart';

class MyJobView extends GetView<MyJobViewController> {
  const MyJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Jobs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [_buildNewJobButton()],
      ),
      body: Column(
        children: [
          JobSearchBar(
            searchController: controller.searchController,
            onChanged: controller.onSearchChanged,
            onSortTap: () {},
          ),
          const SizedBox(height: 10),
          Obx(() {
            final allCount = controller.jobs.length;
            final activeCount = controller.jobs
                .where((j) => j.status.toLowerCase() == 'active')
                .length;
            final pausedCount = controller.jobs
                .where(
                  (j) =>
                      j.status.toLowerCase() == 'inactive' ||
                      j.status.toLowerCase() == 'paused',
                )
                .length;
            final draftCount = controller.jobs
                .where((j) => j.status.toLowerCase() == 'draft')
                .length;
            final closedCount = controller.jobs
                .where((j) => j.status.toLowerCase() == 'closed')
                .length;

            final tabList = [
              'All ($allCount)',
              'Active ($activeCount)',
              'Paused ($pausedCount)',
              'Closed ($closedCount)',
              'Draft ($draftCount)',
            ];

            final selectedStr = tabList.firstWhere(
              (t) => t.startsWith(controller.seletedTab.value),
              orElse: () => tabList[0],
            );

            return JobStatusTabs(
              tabs: tabList,
              selectedTab: selectedStr,
              onTabChanged: controller.changeTab,
            );
          }),
          const SizedBox(height: 20),

          // ── ប្រើប្រាស់ Function ដើម្បីបង្ហាញបញ្ជីការងារ ──
          Expanded(child: _buildJobList()),
        ],
      ),
    );
  }

  // ==========================================
  // ── 1. Function សម្រាប់សាងសង់បញ្ជីការងារ (List View)
  // ==========================================
  Widget _buildJobList() {
    return Obx(() {
      final currentList = controller.displayJobs;

      // 🎯 ដំណោះស្រាយ៖ ទាញយក Profile នៅទីនេះ (ក្រៅ ListView តែក្នុង Obx)
      // ធ្វើបែបនេះ GetX នឹងដឹងថាពេល Profile ដើរចប់ វាត្រូវ Rebuild UI បង្ហាញ Logo ភ្លាមៗ
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.inbox, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                "No jobs found in this status",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
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
                  color: Color(0xFF4f7df7),
                ),
              ),
            );
          }

          final job = currentList[index];

          return JobCardItem(
            title: job.title,
            logoUrl: logoUrl, // 🟢 ប្រើប្រាស់អថេរដែលបានទាញនៅខាងលើ
            department: _getDepartmentName(job.categoryId),
            location: _getLocationName(job.provinceId),
            timeAgo: _getTimeAgo(job.createdAt),
            status: job.status.isEmpty ? 'draft' : job.status,
            isUrgent: false,
            candidatesCount: 0,
            onTap: () {
              Get.toNamed(AppRoutes.myJobDetail, arguments: job.id);
            },
            onMoreTap: () => _showJobActionSheet(context, job.id),
          );
        },
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
        // ── 🎯 ដំណោះស្រាយ: រុំ Obx ខាងក្នុង builder ──
        // វានឹងបង្ខំឱ្យ Bottom Sheet គូរខ្លួនឯងឡើងវិញ រាល់ពេលទិន្នន័យ jobs ប្រែប្រួល
        return Obx(() {
          // 🎯 ទាញយក Object និងគណនា Status ត្រូវតែដាក់ក្នុង Obx នេះ
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
            pauseLabel: isCurrentlyInactive ? "Resume Job" : "Pause Job",
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
                    // បើអ្នកមិនចង់ឱ្យ Bottom Sheet បិទ ពេលចុច Pause ទេ សូមលុប Get.back() នេះចោល
                    Get.back();

                    final newStatus = isCurrentlyInactive
                        ? 'active'
                        : 'inactive';
                    final titleText = isCurrentlyInactive
                        ? "Resume Job?"
                        : "Pause Job?";
                    final messageText = isCurrentlyInactive
                        ? "Are you sure you want to resume this job? It will be visible to candidates again."
                        : "Are you sure you want to pause this job? It will be temporarily hidden from candidates.";

                    Get.dialog(
                      ConfirmDialog(
                        title: titleText,
                        message: messageText,
                        confirmText: isCurrentlyInactive ? "Resume" : "Pause",
                        cancelText: "Cancel",
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
                        title: "Close Job?",
                        message:
                            "Are you sure you want to close this job? Candidates will no longer be able to apply.",
                        confirmText: "Close Job",
                        cancelText: "Cancel",
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
                  title: "Delete Job?",
                  message:
                      "Are you sure you want to delete this job? This action cannot be undone.",
                  confirmText: "Delete",
                  cancelText: "Cancel",
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
    return "Unknown Location";
  }

  String _getDepartmentName(String categoryId) {
    if (Get.isRegistered<CategoryController>()) {
      try {
        final catCtrl = Get.find<CategoryController>();
        return catCtrl.categories.firstWhere((c) => c.id == categoryId).name;
      } catch (_) {}
    }
    return "General";
  }

  String _getTimeAgo(String createdAt) {
    try {
      // 🎯 ១. បង្ខំឱ្យ Flutter ដឹងថាវាជាម៉ោង UTC ដោយការថែមអក្សរ 'Z' ពីក្រោយ
      String dateStr = createdAt;
      if (!dateStr.endsWith('Z')) {
        dateStr += 'Z';
      }

      // 🎯 ២. ពេលមាន Z ហើយ ទើបការហៅ toLocal() អាចបូកថែម ៧ ម៉ោងបានត្រឹមត្រូវ
      final createdDate = DateTime.parse(dateStr).toLocal();
      final difference = DateTime.now().difference(createdDate);

      if (difference.inDays > 0) return "${difference.inDays}d ago";
      if (difference.inHours > 0) return "${difference.inHours}h ago";
      if (difference.inMinutes > 0) return "${difference.inMinutes}m ago";
    } catch (_) {}
    return "Just now";
  }

  // ── ប៊ូតុង + New Job ──
  InkWell _buildNewJobButton() {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.newJob),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4f7df7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.plus, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Text(
              'New Job',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
