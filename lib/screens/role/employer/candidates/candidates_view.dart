import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/chat/chat_rest_service.dart';
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/core/utils/debouncer.dart';
import 'package:jobber_city/models/chat_model.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/models/role/employer/applicant_status_summary_model.dart';
import 'package:jobber_city/models/role/employer/job_dropdown_item_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'widgets/bulk_action_bottom_sheet.dart';
import 'widgets/candidate_list.dart';
import 'widgets/candidate_search_bar.dart';
import 'widgets/job_filter_dropdown.dart';

part 'candidates_binding.dart';
part 'candidates_controller.dart';

class CandidatesView extends GetView<CandidatesViewController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Candidates'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.isSelectionMode) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    LucideIcons.x,
                    color: theme.textTheme.bodyLarge?.color,
                  ), // 🟢 Dynamic Icon
                  tooltip: "Cancel Selection".tr, // 🟢 Added .tr
                  onPressed: () {
                    controller.clearSelection();
                  },
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  LucideIcons.bell,
                  color: isDark ? AppColors.darkIconSecondary : Colors.black54,
                ), // 🟢 Dynamic Icon
                tooltip: "Notifications".tr, // 🟢 Added .tr
                onPressed: () {},
              ),
            );
          }),
        ],
      ),

      bottomNavigationBar: Obx(() {
        if (!controller.isSelectionMode) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : Colors.white, // 🟢 Dynamic BG
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.3 : 0.05,
                ), // 🟢 Dynamic Shadow
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton.icon(
              onPressed: () => _showBulkActionBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(LucideIcons.zap, color: Colors.white),
              label: Text(
                "Take Action (@count)".trParams({
                  'count': controller.selectedApplicantIds.length.toString(),
                }), // 🟢 Added .trParams
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      }),

      body: Column(
        children: [
          const JobFilterDropdown(),

          CandidateSearchBar(
            searchCtrl: controller.searchController,
            onChanged: (value) {
              controller.onSearchChanged(value);
            },
            onClear: () {
              controller.searchController.clear();
              controller.fetchApplicants();
            },
          ),

          Container(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : Colors.white, // 🟢 Dynamic TabBar Area BG
            child: Obx(() {
              final summary = controller.statusSummary.value;

              return TabBar(
                controller: controller.tabController,
                isScrollable: true,
                labelColor: isDark
                    ? Colors.blueAccent
                    : AppColors.primary, // 🟢 Dynamic Active Label
                unselectedLabelColor: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey, // 🟢 Dynamic Inactive Label
                indicatorColor: isDark
                    ? Colors.blueAccent
                    : AppColors.primary, // 🟢 Dynamic Indicator
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                dividerColor: isDark
                    ? AppColors.darkDivider
                    : Colors.grey.shade200, // 🟢 Dynamic Divider
                tabAlignment: TabAlignment.start,
                tabs: controller.tabs.map((tabStatus) {
                  final displayName = _getTabDisplayName(
                    tabStatus,
                  ).tr; // 🟢 Translation fallback

                  int count = 0;
                  switch (tabStatus) {
                    case 'all':
                      count = summary.all;
                      break;
                    case 'pending':
                      count = summary.pending;
                      break;
                    case 'shortlisted':
                      count = summary.shortlisted;
                      break;
                    case 'interview':
                      count = summary.interview;
                      break;
                    case 'hired':
                      count = summary.hired;
                      break;
                    case 'rejected':
                      count = summary.rejected;
                      break;
                  }

                  return Tab(
                    text: count > 0 ? '$displayName ($count)' : displayName,
                  );
                }).toList(),
              );
            }),
          ),

          const Expanded(child: CandidateList()),
        ],
      ),
    );
  }

  String _getTabDisplayName(String status) {
    switch (status) {
      case 'all':
        return 'All';
      case 'pending':
        return 'New';
      case 'shortlisted':
        return 'Shortlisted';
      case 'interview':
        return 'Interviewed';
      case 'rejected':
        return 'Rejected';
      case 'hired':
        return 'Hired';
      default:
        return status.capitalizeFirst ?? status;
    }
  }

  void _showBulkActionBottomSheet(BuildContext context) {
    Get.bottomSheet(
      const BulkActionBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
