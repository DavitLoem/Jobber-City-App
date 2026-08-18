import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/models/role/employer/job_dropdown_item_model.dart';

import 'widgets/candidate_list.dart';
import 'widgets/job_filter_dropdown.dart';

part 'candidates_binding.dart';
part 'candidates_controller.dart';

class CandidatesView extends GetView<CandidatesViewController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Candidates'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          const JobFilterDropdown(),
          Container(
            color: theme.scaffoldBackgroundColor,
            child: TabBar(
              controller: controller.tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              dividerColor: isDark
                  ? AppColors.darkDivider
                  : Colors.grey.shade200,
              tabAlignment: TabAlignment.start,
              tabs: controller.tabs.map((tabStatus) {
                return Tab(text: _getTabDisplayName(tabStatus));
              }).toList(),
            ),
          ),
          const Expanded(child: CandidateList()),
        ],
      ),
    );
  }

  String _getTabDisplayName(String status) {
    switch (status) {
      case 'pending':
        return 'New'.tr; // 🟢 Added .tr
      case 'shortlisted':
        return 'Shortlisted'.tr; // 🟢 Added .tr
      case 'interview':
        return 'Interviewed'.tr; // 🟢 Added .tr
      case 'rejected':
        return 'Rejected'.tr; // 🟢 Added .tr
      case 'hired':
        return 'Hired'.tr; // 🟢 Added .tr
      default:
        return status.capitalizeFirst?.tr ??
            status.tr; // 🟢 Added fallback translation
    }
  }
}
