import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../candidate_detail_view.dart'; // Import controller

class CandidateActionBar extends StatelessWidget {
  final CandidateDetailViewController controller;

  const CandidateActionBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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

        final status = controller.applicant.status.toLowerCase();

        if (status == 'pending') {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Reject",
                  Colors.red.shade600,
                  Colors.red.shade50,
                  () => _showRejectBottomSheet(context),
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
                  () => _showRejectBottomSheet(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Interview",
                  Colors.white,
                  const Color(0xFF10B981),
                  () => _showInterviewBottomSheet(context),
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
                  () => _showRejectBottomSheet(context),
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

  // ── Modals & Dialogs (ចម្លងពីឯកសារចាស់មកដាក់ទីនេះ) ──

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
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
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
              "Yes, $actionName",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
