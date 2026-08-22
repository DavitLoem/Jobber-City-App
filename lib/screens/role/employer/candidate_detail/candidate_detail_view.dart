import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/chat/chat_models.dart';
import 'package:jobber_city/models/interview/interview_models.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
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
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: AppColors.primary),
            tooltip: 'Schedule video interview with ${applicant.fullName}',
            onPressed: controller.scheduleVideoInterview,
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
            tooltip: 'Message ${applicant.fullName}',
            onPressed: controller.openChat,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ១. ផ្នែក Header (រូបថត និង ឈ្មោះ) ──
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        applicant.profileImageUrl != null &&
                            applicant.profileImageUrl!.isNotEmpty
                        ? NetworkImage(applicant.profileImageUrl!)
                        : null,
                    child:
                        applicant.profileImageUrl == null ||
                            applicant.profileImageUrl!.isEmpty
                        ? const Icon(
                            LucideIcons.user,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    applicant.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Applied for: ${applicant.jobTitle}",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── ២. ផ្នែកព័ត៌មានទូទៅ (Experience & Skills) ──
            const Text(
              "Skills & Experience",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (applicant.yearsOfExperience > 0)
                  _buildChip(
                    "${applicant.yearsOfExperience} Yrs Exp",
                    isHighlight: true,
                  ),
                ...applicant.skills.map((s) => _buildChip(s)),
                if (applicant.skills.isEmpty &&
                    applicant.yearsOfExperience == 0)
                  Text(
                    "No specific skills provided.",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            ),

            // ── ៣. ផ្នែក Cover Letter ──
            const Text(
              "Cover Letter",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                applicant.coverLetter != null &&
                        applicant.coverLetter!.isNotEmpty
                    ? applicant.coverLetter!
                    : "No cover letter provided.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── ៤. ផ្នែក Resume/CV ──
            const Text(
              "Resume / CV",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.fileText,
                      color: Colors.red.shade600,
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
                              : "Applicant_Resume.pdf", // Fallback បើគ្មានឈ្មោះ
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "PDF Document",
                          style: TextStyle(
                            color: Colors.grey.shade500,
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
                            // 🎯 លោតទៅកាន់ទំព័រមើល CV
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
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("View"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ── ៥. ប៊ូតុង Action ផ្នែកខាងក្រោម (Bottom Navigation Bar) ──
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  // 🎯 មុខងារជំនួយសម្រាប់គូរ UI
  Widget _buildChip(String label, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFE0E7FF) : const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: isHighlight ? const Color(0xFF3730A3) : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 🎯 មុខងារបង្កើត Bottom Action Bar ទៅតាម Status របស់បេក្ខជន
  Widget _buildBottomActionBar(BuildContext context) {
    final status = controller.applicant.status.toLowerCase();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                  "Reject",
                  Colors.red.shade600,
                  Colors.red.shade50,
                  () => _showRejectBottomSheet(context), // 🟢 ប្រើ Bottom Sheet
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Shortlist",
                  Colors.white,
                  AppColors.primary,
                  () => _showConfirmationDialog(
                    "Shortlist",
                    'shortlisted',
                    AppColors.primary,
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
                  "Reject",
                  Colors.red.shade600,
                  Colors.red.shade50,
                  () => _showRejectBottomSheet(context), // 🟢 ប្រើ Bottom Sheet
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Interview",
                  Colors.white,
                  const Color(0xFF10B981),
                  () => _showInterviewBottomSheet(
                    context,
                  ), // 🟢 ប្រើ Bottom Sheet សម្រាប់រៀបចំការសម្ភាសន៍
                ),
              ),
            ],
          );
        } else if (status == 'interview') {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Reject",
                  Colors.red.shade600,
                  Colors.red.shade50,
                  () => _showRejectBottomSheet(
                    context,
                  ), // 🟢 ដោះស្រាយ Bug: ឈប់ហៅផ្ទាល់
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Hire Candidate",
                  Colors.white,
                  const Color(0xFF059669),
                  () => _showConfirmationDialog(
                    "Hire",
                    'hired',
                    const Color(0xFF059669),
                  ), // 🟢 ដោះស្រាយ Bug
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
                disabledBackgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Application Closed",
                style: TextStyle(
                  color: Colors.grey.shade500,
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

  void _showRejectBottomSheet(BuildContext context) {
    controller.feedbackController.clear();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reject Candidate",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Provide a reason or feedback (Optional):",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "E.g., Not enough experience in Flutter...",
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
                    child: const Text(
                      "Confirm Reject",
                      style: TextStyle(color: Colors.white),
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

  void _showInterviewBottomSheet(BuildContext context) {
    controller.locationController.clear();
    controller.messageController.clear();
    controller.selectedInterviewDate.value = null;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              24, // ការពារ Keyboard បាំង
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Schedule Interview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 16),

              // Date Picker (សាមញ្ញ)
              const Text(
                "Interview Date & Time",
                style: TextStyle(fontWeight: FontWeight.w500),
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
                    if (date != null)
                      controller.selectedInterviewDate.value = date;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedInterviewDate.value
                                  ?.toString()
                                  .split(' ')[0] ??
                              "Select Date",
                        ),
                        const Icon(LucideIcons.calendar, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Location / Link",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.locationController,
                decoration: InputDecoration(
                  hintText: "E.g., Floor 5, Jobber City HQ or Zoom Link",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Message to Candidate (Optional)",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.messageController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "E.g., Please prepare a small presentation.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Validate Date & Location here...
                        if (controller.selectedInterviewDate.value == null ||
                            controller.locationController.text.isEmpty) {
                          Get.snackbar(
                            "Required",
                            "Please select a date and enter a location.",
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
                      child: const Text(
                        "Schedule",
                        style: TextStyle(color: Colors.white),
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

  // ជំនួយគូរប៊ូតុង
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

  // 🎯 អនុគមន៍សម្រាប់លោតផ្ទាំងសួរបញ្ជាក់
  void _showConfirmationDialog(
    String actionName,
    String newStatus,
    Color actionColor,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(LucideIcons.alertCircle, color: actionColor),
            const SizedBox(width: 10),
            const Text(
              "Confirm Action",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to $actionName this candidate?",
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // បិទ Dialog
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // បិទ Dialog មុនសិន
              controller.changeApplicantStatus(
                newStatus,
              ); // ដំណើរការផ្លាស់ប្តូរ Status
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: actionColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Yes, $actionName",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
