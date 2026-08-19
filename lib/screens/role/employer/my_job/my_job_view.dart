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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: _buildNewJobButton()),
          ),
        ],
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
            // 🟢 ៤. ប្រើប្រាស់ statusSummary ជំនួសឱ្យការរាប់ពី controller.jobs
            final summary = controller.statusSummary;
            final allCount = summary['all'] ?? 0;
            final activeCount = summary['active'] ?? 0;
            final pausedCount = summary['paused'] ?? 0;
            final closedCount = summary['closed'] ?? 0;
            final draftCount = summary['draft'] ?? 0;

            final tabList = [
              '${'All'.tr} ($allCount)', // 🟢 Translated dynamically
              '${'Active'.tr} ($activeCount)', // 🟢 Translated dynamically
              '${'Paused'.tr} ($pausedCount)', // 🟢 Translated dynamically
              '${'Closed'.tr} ($closedCount)', // 🟢 Translated dynamically
              '${'Draft'.tr} ($draftCount)', // 🟢 Translated dynamically
            ];

            final selectedStr = tabList.firstWhere(
              (t) =>
                  t.startsWith(controller.seletedTab.value.tr) ||
                  t.startsWith(controller.seletedTab.value),
              orElse: () => tabList[0],
            );

            return JobStatusTabs(
              tabs: tabList,
              selectedTab: selectedStr,
              onTabChanged: controller.changeTab,
              isDark: isDark,
            );
          }),
          const SizedBox(height: 20),

          // ── ប្រើប្រាស់ Function ដើម្បីបង្ហាញបញ្ជីការងារ ──
          Expanded(child: _buildJobList(context)),
        ],
      ),
    );
  }

  // ==========================================
  // ── 1. Function សម្រាប់សាងសង់បញ្ជីការងារ (List View)
  // ==========================================
  Widget _buildJobList(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          itemBuilder: (_, _) => JobCardSkeleton(isDark: isDark, theme: theme),
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
            onCandidatesTap: () {},
            onMoreTap: () =>
                _showJobActionSheet(context, job.id, isDark, theme),
            isDark: isDark,
            theme: theme,
          );
        },
      );
    });
  }

  void _showJobActionSheet(
    BuildContext context,
    String targetJobId,
    bool isDark,
    ThemeData theme,
  ) {
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
            isDark: isDark,
            theme: theme,
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

      if (difference.inDays > 0) {
        return "@daysd ago".trParams({
          'days': difference.inDays.toString(),
        }); // 🟢 Added .trParams
      }
      if (difference.inHours > 0) {
        return "@hoursh ago".trParams({
          'hours': difference.inHours.toString(),
        }); // 🟢 Added .trParams
      }
      if (difference.inMinutes > 0) {
        return "@minsm ago".trParams({
          'mins': difference.inMinutes.toString(),
        }); // 🟢 Added .trParams
      }
    } catch (_) {}
    return "Just now".tr; // 🟢 Added .tr
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
