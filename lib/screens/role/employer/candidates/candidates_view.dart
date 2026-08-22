import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/chat/chat_rest_service.dart';
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false, // រុញទៅឆ្វេងបែប Modern Dashboard
        title: const Text(
          'Candidates',
          style: TextStyle(
            color: Color(0xFF1A1D1E), // ពណ៌ខ្មៅដិតបែប Premium
            fontWeight: FontWeight.w900, // អក្សរក្រាស់
            fontSize: 24, // ទំហំធំជាងមុន
            letterSpacing: -0.5, // បង្រួមចន្លោះអក្សរបន្តិចឱ្យមើលទៅរលោង
          ),
        ),
        actions: [
          Obx(() {
            // ករណីកំពុង Select បង្ហាញប៊ូតុង Cancel
            if (controller.isSelectionMode) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.black87),
                  tooltip: "Cancel Selection",
                  onPressed: () {
                    controller.clearSelection();
                  },
                ),
              );
            }
            // 🟢 ករណីធម្មតា បង្ហាញ Icon ផ្សេងៗ (ឧទាហរណ៍: Notification) ដើម្បីឱ្យមានតុល្យភាព
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(LucideIcons.bell, color: Colors.black54),
                tooltip: "Notifications",
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
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton.icon(
              onPressed: () => _showBulkActionBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4f7df7),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(LucideIcons.zap, color: Colors.white),
              label: Text(
                "Take Action (${controller.selectedApplicantIds.length})",
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
            color: Colors.white,
            child: Obx(() {
              final summary = controller.statusSummary.value;

              return TabBar(
                controller: controller.tabController,
                isScrollable: true,
                labelColor: const Color(0xFF4f7df7),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF4f7df7),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                dividerColor: Colors.grey.shade200,
                tabAlignment: TabAlignment.start,
                tabs: controller.tabs.map((tabStatus) {
                  final displayName = _getTabDisplayName(tabStatus);

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
