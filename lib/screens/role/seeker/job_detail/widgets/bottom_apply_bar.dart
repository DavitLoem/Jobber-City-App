import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../job_detail_view.dart';

class BottomApplyBar extends GetView<JobDetailController> {
  const BottomApplyBar({super.key});

  // 🎯 មុខងារសម្រាប់ហៅផ្ទាំង Bottom Sheet មកបង្ហាញ
  void _showApplyBottomSheet(BuildContext context) {
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Apply for this job",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🎯 ផ្នែកបង្ហាញស្ថានភាព CV (Resume Status Card)
              Obx(() {
                if (controller.isLoadingProfile.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                bool hasCv = controller.resumeUrl.value.isNotEmpty;
                // 🎯 យកឈ្មោះ CV មកបង្ហាញ បើគ្មានដាក់ "Attached Resume/CV"
                String displayName = controller.resumeFilename.value.isNotEmpty
                    ? controller.resumeFilename.value
                    : "Attached Resume/CV";

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: hasCv ? AppColors.primaryLight : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasCv
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.red.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: hasCv ? Colors.white : Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          hasCv
                              ? Icons.picture_as_pdf_rounded
                              : Icons.warning_rounded,
                          color: hasCv
                              ? AppColors.primary
                              : Colors.red.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasCv
                                  ? displayName
                                  : "No Resume/CV Found", // 🎯 បង្ហាញឈ្មោះឯកសារនៅទីនេះ
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: hasCv
                                    ? AppColors.primary
                                    : Colors.red.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow
                                  .ellipsis, // ការពារករណីឈ្មោះវែងពេក
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasCv
                                  ? "This document will be sent to the employer."
                                  : "Please upload a CV in your profile first.",
                              style: TextStyle(
                                fontSize: 12,
                                color: hasCv
                                    ? AppColors.primary.withValues(alpha: 0.8)
                                    : Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              const Text(
                "Cover Letter (Optional)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.coverLetterController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      "Write a short message explaining why you are a great fit...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: AppColors.lightSurfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 12),

              // 🎯 កូដថ្មី៖ ផ្នែកបង្ហាញប៊ូតុង Upload ឬ បង្ហាញឈ្មោះឯកសារដែលបានរើសរួច
              Obx(() {
                if (controller.coverLetterDocName.value.isNotEmpty) {
                  // បង្ហាញឈ្មោះឯកសារ និងប៊ូតុងលុបចោល
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.coverLetterDocName.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.removeCoverLetterDocument,
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // បង្ហាញប៊ូតុងសម្រាប់ចុច Upload
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: controller.pickCoverLetterDocument,
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: const Text("Upload Cover Letter (PDF, Word)"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  );
                }
              }),

              const SizedBox(height: 24),

              // 🎯 ប៊ូតុង Submit
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() {
                  bool hasCv = controller.resumeUrl.value.isNotEmpty;
                  bool isLoading =
                      controller.isLoadingProfile.value ||
                      controller.isApplying.value;

                  return ElevatedButton(
                    // 🎯 បិទប៊ូតុងបើអត់មាន CV ឬកំពុង Load
                    onPressed: (hasCv && !isLoading)
                        ? () => controller.submitApplication()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          Colors.grey.shade300, // ពណ៌ប៊ូតុងពេលត្រូវបិទ
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isApplying.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Submit Application",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ប៊ូតុង Save (Bookmark)
          Obx(
            () => GestureDetector(
              onTap: controller.toggleSave,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  controller.job.value?.isSaved == true
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: controller.job.value?.isSaved == true
                      ? AppColors.primary
                      : AppColors.textHint,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ប៊ូតុង Apply Now
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: controller.hasApplied.value
                    ? null
                    : () => _showApplyBottomSheet(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 52,
                  decoration: BoxDecoration(
                    // ប្តូរពណ៌ទៅពណ៌បៃតងពេលដាក់ពាក្យរួច
                    color: controller.hasApplied.value
                        ? AppColors.success
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.hasApplied.value
                            ? Icons.check_circle_rounded
                            : Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        controller.hasApplied.value ? "Applied" : "Apply Now",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
