import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'widgets/candidate_action_bar.dart';
import 'widgets/candidate_cover_letter.dart';
// ហៅ Widgets ដែលយើងនឹងបង្កើតនៅខាងក្រោម
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
    final applicant = controller.applicant;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ១. ផ្នែក Header (រូបថត និង ឈ្មោះ) ──
            CandidateHeader(applicant: applicant),

            const SizedBox(height: 24),

            // ── ២. ផ្នែកព័ត៌មានទូទៅ (Experience & Skills) ──
            CandidateSkills(applicant: applicant),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            ),

            CandidateInterview(applicant: applicant),

            // ── ៣. ផ្នែក Cover Letter ──
            CandidateCoverLetter(coverLetter: applicant.coverLetter),

            const SizedBox(height: 24),

            // ── ៤. ផ្នែក Resume/CV ──
            CandidateResume(applicant: applicant),
          ],
        ),
      ),
      // ── ៥. ប៊ូតុង Action ផ្នែកខាងក្រោម (Bottom Navigation Bar) ──
      bottomNavigationBar: CandidateActionBar(controller: controller),
    );
  }
}
