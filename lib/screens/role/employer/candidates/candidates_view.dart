import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Candidates',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          const JobFilterDropdown(), // 🎯 ហៅ Widget ជ្រើសរើស Job

          Container(
            color: Colors.white,
            // 🎯 ប្រើប្រាស់ TabBar ដោយភ្ជាប់ជាមួយ tabController ពី GetX
            child: TabBar(
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
              // 🎯 ប្រើ List ពី Controller ដើម្បីគូរ Tab បូកជាមួយចំនួន (Count)
              tabs: controller.tabs.map((tabStatus) {
                return Tab(
                  // ឧ. ប្រែពាក្យ 'pending' ទៅជា 'New'
                  text: _getTabDisplayName(tabStatus),
                );
              }).toList(),
            ),
          ),

          // ── ផ្នែកបញ្ជីបេក្ខជន ──
          // 🎯 ហៅ CandidateList តែមួយគត់! វានឹង Refresh ខ្លួនឯងពេល controller.applicants ប្រែប្រួល
          const Expanded(child: CandidateList()),
        ],
      ),
    );
  }

  // អនុគមន៍ជំនួយសម្រាប់ប្តូរឈ្មោះ Status ទៅជាពាក្យបង្ហាញលើ UI
  String _getTabDisplayName(String status) {
    switch (status) {
      case 'pending':
        return 'New';
      case 'shortlisted':
        return 'Shortlisted';
      case 'interview':
        return 'Interviewed';
      case 'rejected':
        return 'Rejected';
      case 'hired':
        return 'Hired'; // 🟢 បន្ថែម Hired
      default:
        return status.capitalizeFirst ?? status;
    }
  }
}
