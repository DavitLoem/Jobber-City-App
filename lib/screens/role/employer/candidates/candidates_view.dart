import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';

import 'widgets/candidate_list.dart';
import 'widgets/job_filter_dropdown.dart';

part 'candidates_binding.dart';
part 'candidates_controller.dart';

class CandidatesView extends GetView<CandidatesViewController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
              child: TabBar(
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
                onTap: (index) {
                  // 🎯 ប្រាប់ Controller ឱ្យទាញទិន្នន័យពេលចុចដូរ Tab
                  final statuses = [
                    'pending',
                    'shortlisted',
                    'interview',
                    'rejected',
                  ];
                  controller.changeTab(statuses[index]);
                },
                tabs: const [
                  Tab(text: "New"),
                  Tab(text: "Shortlisted"),
                  Tab(text: "Interviewed"),
                  Tab(text: "Rejected"),
                ],
              ),
            ),

            // ── ផ្នែកបញ្ជីបេក្ខជន ──
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CandidateList(status: 'pending'),
                  CandidateList(status: 'shortlisted'),
                  CandidateList(status: 'interview'),
                  CandidateList(status: 'rejected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
