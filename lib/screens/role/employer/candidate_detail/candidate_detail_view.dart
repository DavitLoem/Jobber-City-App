import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 🟢 Import Service មកទីនេះ ដើម្បីឱ្យ Controller ស្គាល់វា
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'widgets/candidate_action_bar.dart';
import 'widgets/candidate_cover_letter.dart';
import 'widgets/candidate_header.dart';
import 'widgets/candidate_interview.dart';
import 'widgets/candidate_resume.dart';
import 'widgets/candidate_skills.dart';

part 'candidate_detail_binding.dart';
part 'candidate_detail_controller.dart';

class CandidateDetailView extends GetView<CandidateDetailViewController> {
  const CandidateDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Applicant Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      // 🟢 រុំ Body ជាមួយ Obx ដើម្បីរង់ចាំការទាញយកទិន្នន័យ
      body: Obx(() {
        if (controller.isLoadingData.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4F7DF7)),
          );
        }

        final applicant = controller.applicant.value;

        // បើអត់មានទិន្នន័យបង្ហាញ Error State
        if (applicant == null) {
          return const Center(child: Text("Candidate details not found."));
        }

        return RefreshIndicator(
          color: const Color(0xFF4F7DF7),
          onRefresh: controller.refreshDetail,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CandidateHeader(applicant: applicant),
                const SizedBox(height: 24),
                CandidateSkills(applicant: applicant),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                CandidateInterview(applicant: applicant),
                CandidateCoverLetter(coverLetter: applicant.coverLetter),
                const SizedBox(height: 24),
                CandidateResume(applicant: applicant),
              ],
            ),
          ),
        );
      }),
      // 🟢 ការពារកុំឱ្យ Error ពេលអត់ទាន់មានទិន្នន័យនៅ Action Bar ខាងក្រោម
      bottomNavigationBar: Obx(() {
        if (controller.isLoadingData.value ||
            controller.applicant.value == null) {
          return const SizedBox.shrink();
        }
        return CandidateActionBar(controller: controller);
      }),
    );
  }
}
