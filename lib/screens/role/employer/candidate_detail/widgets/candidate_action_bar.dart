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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
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

        final status = controller.applicant.value!.status.toLowerCase();

        if (status == 'pending') {
          return Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Reject".tr,
                  isDark ? Colors.redAccent : Colors.red.shade600,
                  isDark
                      ? AppColors.error.withValues(alpha: 0.15)
                      : Colors.red.shade50,
                  () => _showRejectBottomSheet(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Shortlist".tr,
                  Colors.white,
                  AppColors.primary,
                  () => _showConfirmationDialog(
                    "Shortlist".tr,
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
                  "Reject".tr,
                  isDark ? Colors.redAccent : Colors.red.shade600,
                  isDark
                      ? AppColors.error.withValues(alpha: 0.15)
                      : Colors.red.shade50,
                  () => _showRejectBottomSheet(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Interview".tr,
                  Colors.white,
                  AppColors.success,
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
                  "Reject".tr,
                  isDark ? Colors.redAccent : Colors.red.shade600,
                  isDark
                      ? AppColors.error.withValues(alpha: 0.15)
                      : Colors.red.shade50,
                  () => _showRejectBottomSheet(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  "Hire Candidate".tr,
                  Colors.white,
                  const Color(0xFF059669),
                  () => _showConfirmationDialog(
                    "Hire".tr,
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
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Application Closed".tr,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
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

  void _showRejectBottomSheet(BuildContext context) {
    final isDark = Get.isDarkMode;
    controller.feedbackController.clear();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reject Candidate".tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.redAccent : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Provide a reason or feedback (Optional):".tr,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.feedbackController,
              maxLines: 3,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: "E.g., Not enough experience in Flutter...".tr,
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
                      "Cancel".tr,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
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
                      "Confirm Reject".tr,
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

  void _showInterviewBottomSheet(BuildContext context) {
    final isDark = Get.isDarkMode;
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
          color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Schedule Interview".tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Interview Date & Time".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
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
                      color: isDark
                          ? AppColors.darkInputBackground
                          : Colors.white,
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
                              "Select Date".tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
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
                "Location / Link".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.locationController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: "E.g., Floor 5, Jobber City HQ or Zoom Link".tr,
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
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Message to Candidate (Optional)".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.messageController,
                maxLines: 2,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: "E.g., Please prepare a small presentation.".tr,
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
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade400,
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
                        "Cancel".tr,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (controller.selectedInterviewDate.value == null ||
                            controller.locationController.text.isEmpty) {
                          Get.snackbar(
                            "Required".tr,
                            "Please select a date and enter a location.".tr,
                            backgroundColor: isDark
                                ? Colors.orangeAccent.withValues(alpha: 0.15)
                                : Colors.orange.shade50,
                            colorText: isDark
                                ? Colors.orangeAccent
                                : Colors.orange.shade800,
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
                        "Schedule".tr,
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

  void _showConfirmationDialog(
    String actionName,
    String newStatus,
    Color actionColor,
  ) {
    final isDark = Get.isDarkMode;
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(LucideIcons.alertCircle, color: actionColor),
            const SizedBox(width: 10),
            Text(
              "Confirm Action".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to @action this candidate?".trParams({
            'action': actionName.toLowerCase(),
          }),
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.darkTextSecondary : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel".tr,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : Colors.grey,
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
              "Yes, @action".trParams({'action': actionName}),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
