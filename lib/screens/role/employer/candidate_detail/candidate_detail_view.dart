import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/widgets/cv_viewer_view.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'candidate_detail_binding.dart';
part 'candidate_detail_controller.dart';

class CandidateDetailView extends GetView<CandidateDetailViewController> {
  const CandidateDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final applicant = controller.applicant;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Applicant Details'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceElevated
                        : Colors.grey.shade200,
                    backgroundImage:
                        applicant.profileImageUrl != null &&
                            applicant.profileImageUrl!.isNotEmpty
                        ? NetworkImage(applicant.profileImageUrl!)
                        : null,
                    child:
                        applicant.profileImageUrl == null ||
                            applicant.profileImageUrl!.isEmpty
                        ? Icon(
                            LucideIcons.user,
                            size: 40,
                            color: isDark
                                ? AppColors.darkIconSecondary
                                : Colors.grey,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    applicant.fullName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Applied for: @job".trParams({
                      'job': applicant.jobTitle,
                    }), // 🟢 Added .trParams
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Skills & Experience".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (applicant.yearsOfExperience > 0)
                  _buildChip(
                    "@years Yrs Exp".trParams({
                      'years': applicant.yearsOfExperience.toString(),
                    }), // 🟢 Added .trParams
                    isHighlight: true,
                    isDark: isDark,
                  ),
                ...applicant.skills.map((s) => _buildChip(s, isDark: isDark)),
                if (applicant.skills.isEmpty &&
                    applicant.yearsOfExperience == 0)
                  Text(
                    "No specific skills provided.".tr, // 🟢 Added .tr
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                height: 1,
                thickness: 1,
                color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
              ),
            ),

            Text(
              "Cover Letter".tr, // 🟢 Added .tr
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200,
                ),
              ),
              child: Text(
                applicant.coverLetter != null &&
                        applicant.coverLetter!.isNotEmpty
                    ? applicant.coverLetter!
                    : "No cover letter provided.".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Resume / CV".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.redAccent.withValues(
                              alpha: 0.15,
                            ) // 🟢 Updated opacity
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.fileText,
                      color: isDark ? Colors.redAccent : Colors.red.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant.resumeFilename != null &&
                                  applicant.resumeFilename!.isNotEmpty
                              ? applicant.resumeFilename!
                              : "Applicant_Resume.pdf",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "PDF Document".tr, // 🟢 Added .tr
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed:
                        applicant.resumeUrl != null &&
                            applicant.resumeUrl!.isNotEmpty
                        ? () {
                            Get.to(
                              () => CvViewerView(
                                pdfUrl: applicant.resumeUrl!,
                                candidateName: applicant.fullName,
                              ),
                            );
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary.withValues(
                          alpha: 0.5,
                        ), // 🟢 Updated opacity
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("View".tr), // 🟢 Added .tr
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(context, isDark, theme),
    );
  }

  Widget _buildChip(
    String label, {
    bool isHighlight = false,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight
            ? (isDark
                  ? const Color(0xFFE0E7FF).withValues(
                      alpha: 0.1,
                    ) // 🟢 Updated opacity
                  : const Color(0xFFE0E7FF))
            : (isDark
                  ? AppColors.darkSurfaceElevated
                  : const Color(0xFFF0F4FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: isHighlight
              ? (isDark ? Colors.indigoAccent : const Color(0xFF3730A3))
              : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    bool isDark,
    ThemeData theme,
  ) {
    final status = controller.applicant.status.toLowerCase();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05, // 🟢 Updated opacity
            ),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isUpdating.value) {
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (status == 'pending') {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Reject".tr, // 🟢 Added .tr
                  isDark ? Colors.redAccent : Colors.red.shade600,
                  isDark
                      ? Colors.redAccent.withValues(
                          alpha: 0.1,
                        ) // 🟢 Updated opacity
                      : Colors.red.shade50,
                  () => _showRejectBottomSheet(context, isDark, theme),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Shortlist".tr, // 🟢 Added .tr
                  Colors.white,
                  AppColors.primary,
                  () => _showConfirmationDialog(
                    "Shortlist".tr, // 🟢 Added .tr
                    'shortlisted',
                    AppColors.primary,
                    theme,
                    isDark,
                  ),
                ),
              ),
            ],
          );
        } else if (status == 'shortlisted') {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Reject".tr, // 🟢 Added .tr
                  isDark ? Colors.redAccent : Colors.red.shade600,
                  isDark
                      ? Colors.redAccent.withValues(
                          alpha: 0.1,
                        ) // 🟢 Updated opacity
                      : Colors.red.shade50,
                  () => _showRejectBottomSheet(context, isDark, theme),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Interview".tr, // 🟢 Added .tr
                  Colors.white,
                  isDark ? Colors.greenAccent : const Color(0xFF10B981),
                  () => _showInterviewBottomSheet(context, isDark, theme),
                ),
              ),
            ],
          );
        } else if (status == 'interview') {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Reject".tr, // 🟢 Added .tr
                  isDark ? Colors.redAccent : Colors.red.shade600,
                  isDark
                      ? Colors.redAccent.withValues(
                          alpha: 0.1,
                        ) // 🟢 Updated opacity
                      : Colors.red.shade50,
                  () => _showRejectBottomSheet(context, isDark, theme),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Hire Candidate".tr, // 🟢 Added .tr
                  Colors.white,
                  isDark ? Colors.greenAccent : const Color(0xFF059669),
                  () => _showConfirmationDialog(
                    "Hire".tr, // 🟢 Added .tr
                    'hired',
                    isDark ? Colors.greenAccent : const Color(0xFF059669),
                    theme,
                    isDark,
                  ),
                ),
              ),
            ],
          );
        } else {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Application Closed".tr, // 🟢 Added .tr
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextDisabled
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  void _showRejectBottomSheet(
    BuildContext context,
    bool isDark,
    ThemeData theme,
  ) {
    controller.feedbackController.clear();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reject Candidate".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.redAccent : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Provide a reason or feedback (Optional):".tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.feedbackController,
              maxLines: 3,
              style: TextStyle(
                color: isDark ? AppColors.darkInputText : AppColors.inputText,
              ),
              decoration: InputDecoration(
                hintText: "E.g., Not enough experience in Flutter..."
                    .tr, // 🟢 Added .tr
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : Colors.grey,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : Colors.grey.shade200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel".tr, // 🟢 Added .tr
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.redAccent : Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      controller.changeApplicantStatus(
                        'rejected',
                        feedback: controller.feedbackController.text,
                      );
                    },
                    child: Text(
                      "Confirm Reject".tr, // 🟢 Added .tr
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showInterviewBottomSheet(
    BuildContext context,
    bool isDark,
    ThemeData theme,
  ) {
    controller.locationController.clear();
    controller.messageController.clear();
    controller.selectedInterviewDate.value = null;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Schedule Interview".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.greenAccent : const Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Interview Date & Time".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      controller.selectedInterviewDate.value = date;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedInterviewDate.value
                                  ?.toString()
                                  .split(' ')[0] ??
                              "Select Date".tr, // 🟢 Added .tr
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkInputText
                                : AppColors.inputText,
                          ),
                        ),
                        Icon(
                          LucideIcons.calendar,
                          color: isDark
                              ? AppColors.darkIconSecondary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                "Location / Link".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.locationController,
                style: TextStyle(
                  color: isDark ? AppColors.darkInputText : AppColors.inputText,
                ),
                decoration: InputDecoration(
                  hintText: "E.g., Floor 5, Jobber City HQ or Zoom Link"
                      .tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.darkTextHint : Colors.grey,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkInputBackground
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                "Message to Candidate (Optional)".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.messageController,
                maxLines: 2,
                style: TextStyle(
                  color: isDark ? AppColors.darkInputText : AppColors.inputText,
                ),
                decoration: InputDecoration(
                  hintText: "E.g., Please prepare a small presentation."
                      .tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.darkTextHint : Colors.grey,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkInputBackground
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancel".tr, // 🟢 Added .tr
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.greenAccent
                            : const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (controller.selectedInterviewDate.value == null ||
                            controller.locationController.text.isEmpty) {
                          Get.snackbar(
                            "Required".tr, // 🟢 Added .tr
                            "Please select a date and enter a location."
                                .tr, // 🟢 Added .tr
                            backgroundColor: AppColors.warning,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        Get.back();
                        controller.changeApplicantStatus(
                          'interview',
                          interviewSchedule: {
                            "date": controller.selectedInterviewDate.value!
                                .toIso8601String(),
                            "location": controller.locationController.text,
                            "message": controller.messageController.text,
                          },
                        );
                      },
                      child: Text(
                        "Schedule".tr, // 🟢 Added .tr
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildActionBtn(
    String title,
    Color textColor,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
    String actionName,
    String newStatus,
    Color actionColor,
    ThemeData theme,
    bool isDark,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(LucideIcons.alertCircle, color: actionColor),
            const SizedBox(width: 10),
            Text(
              "Confirm Action".tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to @action this candidate?".trParams({
            'action': actionName,
          }), // 🟢 Added .trParams
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel".tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark ? AppColors.darkTextHint : Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.changeApplicantStatus(newStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: actionColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Yes, @action".trParams({
                'action': actionName,
              }), // 🟢 Added .trParams
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
