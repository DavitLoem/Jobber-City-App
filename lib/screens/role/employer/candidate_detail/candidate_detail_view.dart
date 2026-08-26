import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/applicant_employer_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
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
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF8F9FA), // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : Colors.white, // 🟢 Dynamic AppBar BG
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Applicant Details'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title Text
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ), // 🟢 Dynamic Back Icon
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final applicant = controller.applicant.value;

            if (controller.isLoadingData.value || applicant == null) {
              return const SizedBox.shrink();
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    LucideIcons.messageSquare,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    final candidatesController =
                        Get.find<CandidatesViewController>();
                    candidatesController.startChatWithSeeker(applicant);
                  },
                ),
                IconButton(
                  icon: const Icon(LucideIcons.video, color: AppColors.success),
                  onPressed: () {
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
                        existingDate: oldDate,
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
      body: Obx(() {
        if (controller.isLoadingData.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final applicant = controller.applicant.value;

        if (applicant == null) {
          return Center(
            child: Text(
              "Candidate details not found.".tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textTertiary,
              ), // 🟢 Dynamic Subtext
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? AppColors.darkDivider
                        : const Color(0xFFEEEEEE), // 🟢 Dynamic Divider
                  ),
                ),
                CandidateInterview(applicant: applicant),
                CandidateCoverLetter(
                  coverLetterText: controller.applicant.value?.coverLetter,
                  coverLetterUrl: controller.applicant.value?.coverLetterUrl,
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
