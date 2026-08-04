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
                        const Text(
                          "Applicant_Resume.pdf",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
      bottomNavigationBar: _buildBottomActionBar(),
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
  Widget _buildBottomActionBar() {
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

        // រៀបចំប៊ូតុងទៅតាម Status
        if (status == 'pending') {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Reject",
                  Colors.red.shade600,
                  Colors.red.shade50,
                  () => _showConfirmationDialog(
                    "Reject",
                    'rejected',
                    Colors.red.shade600,
                  ),
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
                  () => _showConfirmationDialog(
                    "Reject",
                    'rejected',
                    Colors.red.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Interview",
                  Colors.white,
                  const Color(0xFF10B981),
                  () => _showConfirmationDialog(
                    "Interview",
                    'interview',
                    const Color(0xFF10B981),
                  ),
                ),
              ), // ពណ៌បៃតង
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
                  () => controller.changeApplicantStatus('rejected'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Hire Candidate",
                  Colors.white,
                  const Color(0xFF059669),
                  () => controller.changeApplicantStatus('hired'),
                ),
              ),
            ],
          );
        } else {
          // ករណី Rejected
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
                "Application Rejected",
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
