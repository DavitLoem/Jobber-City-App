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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors
            .transparent, // 🟢 ការពារកុំឱ្យប្តូរពណ៌ប្រផេះពេល Scroll (Material 3)
        elevation: 0,
        scrolledUnderElevation: 2, // 🟢 លោតស្រមោលតិចៗនៅពេលអ្នកអូសបញ្ជីឡើងលើ
        shadowColor: Colors.black.withValues(alpha: 0.1),
        title: const Text(
          'My Jobs',
          style: TextStyle(
            color: Color(
              0xFF111827,
            ), // 🟢 ពណ៌ខ្មៅបែប Slate (Premium ជាងខ្មៅសុទ្ធ)
            fontSize: 26, // 🟢 ធំជាងមុនបន្តិច
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5, // 🟢 បង្រួមចន្លោះអក្សរឱ្យមើលទៅទំនើប
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
              currentSort:
                  controller.currentSort.value, // 🟢 បញ្ជូនតម្លៃបច្ចុប្បន្ន
              onSortChanged: controller.changeSortOption, // 🟢 បញ្ជូនអនុគមន៍ទៅ
            ),
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
          Expanded(child: _buildJobList(context)),
        ],
      ),
    );
  }

  // ==========================================
  // ── 1. Function សម្រាប់សាងសង់បញ្ជីការងារ (List View)
  // ==========================================
  Widget _buildJobList(BuildContext context) {
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
        // 🟢 ដាក់ក្នុង SingleChildScrollView ដើម្បីឱ្យទំព័រទទេក៏អាចអូស Refresh បានដែរ
        return RefreshIndicator(
          onRefresh: () async => await controller.fetchJobs(isRefresh: true),
          color: const Color(0xFF4f7df7),
          backgroundColor: Colors.white,
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
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No jobs found in this status",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // 🟢 រុំ ListView ជាមួយនឹង RefreshIndicator
      return RefreshIndicator(
        onRefresh: () async => await controller.fetchJobs(isRefresh: true),
        color: const Color(0xFF4f7df7),
        backgroundColor: Colors.white,
        child: ListView.separated(
          physics:
              const AlwaysScrollableScrollPhysics(), // ធានាថាអាចអូសចុះក្រោមបានជានិច្ច
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
              logoUrl: logoUrl,
              department: _getDepartmentName(job.categoryId),
              location: _getLocationName(job.provinceId),
              timeAgo: _getTimeAgo(job.createdAt),
              status: job.status.isEmpty ? 'draft' : job.status,
              isUrgent: false,

              candidatesCount: job.applicantCount,
              avatars: job.applicantAvatars,

              // 🟢 គោលដៅទី១៖ ចុចកាតខាងលើ ទៅ Job Detail
              onTap: () {
                Get.toNamed(AppRoutes.myJobDetail, arguments: job.id);
              },

              // 🟢 គោលដៅទី២៖ ចុចកាតខាងក្រោម ទៅ Candidates
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
  Widget _buildNewJobButton() {
    return Container(
      height: 42, // កំណត់កម្ពស់ឱ្យសមមាត្រ
      decoration: BoxDecoration(
        // 🟢 ១. បន្ថែម Gradient ពណ៌ខៀវស្រាលទៅខៀវចាស់
        gradient: const LinearGradient(
          colors: [Color(0xFF5E8AFF), Color(0xFF3F6CF5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        // 🟢 ២. បន្ថែមស្រមោលពណ៌ខៀវ (Glow Effect) ឱ្យប៊ូតុងលេចធ្លោ
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F6CF5).withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // 🟢 ៣. ប្រើ Material ដើម្បីឱ្យពេលចុច (Ripple) មិនបាំង Gradient
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Get.toNamed(AppRoutes.newJob),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.plus, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'New Job',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2, // ឱ្យអក្សរមានខ្យល់ចេញចូលបន្តិច
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
