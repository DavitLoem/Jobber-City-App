import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../job_detail_view.dart';

class BottomApplyBar extends GetView<JobDetailController> {
  const BottomApplyBar({super.key});

  void _showApplyBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Apply for this job".tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceElevated
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textTertiary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (controller.isLoadingProfile.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                bool hasCv = controller.resumeUrl.value.isNotEmpty;
                String displayName = controller.resumeFilename.value.isNotEmpty
                    ? controller.resumeFilename.value
                    : "Attached Resume/CV".tr; // 🟢 Added .tr

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: hasCv
                        ? (isDark
                              ? AppColors.primary.withValues(
                                  alpha: 0.15,
                                ) // 🟢 Updated opacity
                              : AppColors.primaryLight)
                        : (isDark
                              ? Colors.redAccent.withValues(
                                  alpha: 0.15,
                                ) // 🟢 Updated opacity
                              : Colors.red.shade50),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasCv
                          ? AppColors.primary.withValues(
                              alpha: 0.3,
                            ) // 🟢 Updated opacity
                          : (isDark
                                ? Colors.redAccent.withValues(
                                    alpha: 0.4,
                                  ) // 🟢 Updated opacity
                                : Colors.red.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: hasCv
                              ? (isDark ? AppColors.darkSurface : Colors.white)
                              : (isDark
                                    ? Colors.redAccent.withValues(
                                        alpha: 0.3,
                                      ) // 🟢 Updated opacity
                                    : Colors.red.shade100),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          hasCv
                              ? Icons.picture_as_pdf_rounded
                              : Icons.warning_rounded,
                          color: hasCv
                              ? AppColors.primary
                              : (isDark
                                    ? Colors.redAccent
                                    : Colors.red.shade700),
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
                                  : "No Resume/CV Found".tr, // 🟢 Added .tr
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: hasCv
                                    ? AppColors.primary
                                    : (isDark
                                          ? Colors.redAccent
                                          : Colors.red.shade700),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasCv
                                  ? "This document will be sent to the employer."
                                        .tr // 🟢 Added .tr
                                  : "Please upload a CV in your profile first."
                                        .tr, // 🟢 Added .tr
                              style: TextStyle(
                                fontSize: 12,
                                color: hasCv
                                    ? AppColors.primary.withValues(
                                        alpha: 0.8,
                                      ) // 🟢 Updated opacity
                                    : (isDark
                                          ? Colors.redAccent.withValues(
                                              alpha: 0.8,
                                            ) // 🟢 Updated opacity
                                          : Colors.red.shade600),
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

              Text(
                "Cover Letter (Optional)".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.coverLetterController,
                maxLines: 4,
                style: TextStyle(
                  color: isDark ? AppColors.darkInputText : AppColors.inputText,
                ),
                decoration: InputDecoration(
                  hintText:
                      "Write a short message explaining why you are a great fit..."
                          .tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextHint
                        : Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkInputBackground
                      : AppColors.lightSurfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() {
                  bool hasCv = controller.resumeUrl.value.isNotEmpty;
                  bool isLoading =
                      controller.isLoadingProfile.value ||
                      controller.isApplying.value;

                  return ElevatedButton(
                    onPressed: (hasCv && !isLoading)
                        ? () => controller.submitApplication()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: isDark
                          ? AppColors.darkSurfaceElevated
                          : Colors.grey.shade300,
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
                        : Text(
                            "Submit Application".tr, // 🟢 Added .tr
                            style: const TextStyle(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05, // 🟢 Updated opacity
            ),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
            () => GestureDetector(
              onTap: controller.toggleSave,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceElevated
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  controller.job.value?.isSaved == true
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: controller.job.value?.isSaved == true
                      ? AppColors.primary
                      : (isDark ? AppColors.darkTextHint : AppColors.textHint),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                    color: controller.hasApplied.value
                        ? (isDark ? Colors.greenAccent : AppColors.success)
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
                        controller.hasApplied.value
                            ? "Applied".tr
                            : "Apply Now".tr, // 🟢 Added .tr
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
