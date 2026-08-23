import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 🟢 Import Service មកទីនេះ ដើម្បីឱ្យ Controller ស្គាល់វា
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
import 'package:jobber_city/models/interview_models.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../routes/app_routes.dart';
import 'widgets/candidate_action_bar.dart';
import 'widgets/candidate_cover_letter.dart';
import 'widgets/candidate_header.dart';
import 'widgets/candidate_interview.dart';
import 'widgets/candidate_resume.dart';
import 'widgets/candidate_skills.dart';
import 'widgets/document_viewer_screen.dart';

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
        actions: [
          Obx(() {
            final applicant = controller.applicant.value;

            // លាក់ប៊ូតុងបើមិនទាន់ទាញទិន្នន័យបាន ឬអត់មានទិន្នន័យ
            if (controller.isLoadingData.value || applicant == null) {
              return const SizedBox.shrink();
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎯 ១. ប៊ូតុង Chat (ជួសជុល Error រួចរាល់)
                IconButton(
                  icon: const Icon(
                    LucideIcons.messageSquare,
                    color: Color(0xFF4F7DF7),
                  ),
                  onPressed: () {
                    // ដោយសារ applicant យើងឆែក null រួចហើយ យើងអាចបោះវាបានដោយសុវត្ថិភាព
                    final candidatesController =
                        Get.find<CandidatesViewController>();
                    candidatesController.startChatWithSeeker(applicant);
                  },
                ),

                // 🎯 ២. ប៊ូតុង Interview ថ្មី
                IconButton(
                  icon: const Icon(LucideIcons.video, color: Color(0xFF10B981)),
                  onPressed: () {
                    // 🎯 ឆែកមើលថាតើគាត់មានម៉ោងសម្ភាសន៍ចាស់ឬអត់ (ឧទាហរណ៍ពី applicant.interviewSchedule)
                    DateTime? oldDate;
                    if (applicant.interviewSchedule != null &&
                        applicant.interviewSchedule!['date'] != null) {
                      oldDate = DateTime.tryParse(
                        applicant.interviewSchedule!['date'].toString(),
                      )?.toLocal();
                    }

                    Get.toNamed(
                      AppRoutes.scheduleInterview,
                      arguments: ScheduleInterviewArgs(
                        seekerUserId: applicant.seekerUserId,
                        seekerName: applicant.fullName,
                        seekerAvatarUrl: applicant.profileImageUrl,
                        applicationId: applicant.applicationId,
                        jobTitle: applicant.jobTitle,
                        existingDate: oldDate, // 🎯 បោះម៉ោងចាស់ទៅឱ្យ
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            );
          }),
        ],
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
                CandidateCoverLetter(
                  coverLetterText: controller.applicant.value?.coverLetter,
                  coverLetterUrl: controller
                      .applicant
                      .value
                      ?.coverLetterUrl, // ត្រូវប្រាកដថា ApplicantModel មាន Field នេះ
                  coverLetterFilename:
                      controller.applicant.value?.coverLetterFilename,
                  onTapFile: () => controller.openDocument(
                    controller.applicant.value?.coverLetterUrl,
                  ),
                ),
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
