import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/core/api/services/role/seeker/cv_extraction_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/cv_extraction_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/current_resume_card.dart';
import 'widgets/extraction_success_sheet.dart';
import 'widgets/scanning_overlay.dart';

part 'cv_extraction_binding.dart';
part 'cv_extraction_controller.dart';

class CvExtractionView extends GetView<CvExtractionViewController> {
  const CvExtractionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ស្តាប់រាល់ពេលមាន Error
    ever(controller.errorMessage, (String error) {
      if (error.isNotEmpty) {
        final currentDark =
            Get.isDarkMode; // 🟢 Theme check for Snackbars inside ever
        Get.snackbar(
          'Upload Failed'.tr, // 🟢 Added .tr
          error, // 🟢 Usually already mapped with .tr in the controller
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: currentDark
              ? AppColors.error.withValues(alpha: 0.15)
              : Colors.redAccent, // 🟢 Dynamic BG
          colorText: currentDark
              ? Colors.redAccent
              : Colors.white, // 🟢 Dynamic Text
          margin: const EdgeInsets.all(16),
          icon: Icon(
            Icons.error_outline,
            color: currentDark ? Colors.redAccent : Colors.white,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Icon
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Upload Resume'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ), // 🟢 Dynamic Text
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🎯 ហៅ CurrentResumeCard មកប្រើ
                  if (controller.currentResumeUrl.value.isNotEmpty) ...[
                    CurrentResumeCard(
                      filename: controller.currentResumeFilename.value,
                      onView: () => controller.viewCurrentResume(),
                      onDelete: () => controller.deleteCurrentResume(),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Divider(
                          color: isDark
                              ? AppColors.darkDivider
                              : Colors.grey.shade300,
                        ), // 🟢 Dynamic Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR UPLOAD NEW".tr, // 🟢 Added .tr
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextHint
                                  : Colors.grey, // 🟢 Dynamic Text
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.darkDivider
                                : Colors.grey.shade300,
                          ), // 🟢 Dynamic Divider
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ] else ...[
                    const SizedBox(height: 40),
                  ],

                  // Upload Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.primaryLight.withValues(
                              alpha: 0.5,
                            ), // 🟢 Dynamic Icon BG
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    "Smart CV Parsing".tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    controller.currentResumeUrl.value.isNotEmpty
                        ? "Upload a new PDF to replace your current resume and automatically update your profile data."
                              .tr // 🟢 Added .tr
                        : "Upload your PDF resume and let our AI automatically extract your experience, education, and skills to save you time."
                              .tr, // 🟢 Added .tr
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade600, // 🟢 Dynamic Subtitle
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Upload Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: controller.isScanning.value
                          ? null
                          : () => controller.pickAndProcessCv(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: isDark
                            ? AppColors.darkSurfaceElevated
                            : Colors.grey.shade300, // 🟢 Dynamic Disabled BG
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: Text(
                        controller.currentResumeUrl.value.isNotEmpty
                            ? "Replace PDF File"
                                  .tr // 🟢 Added .tr
                            : "Select PDF File".tr, // 🟢 Added .tr
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🎯 ហៅ ScanningOverlay មកប្រើ
            if (controller.isScanning.value)
              ScanningOverlay(onCancel: () => controller.cancelScanning()),
          ],
        );
      }),
    );
  }

  /// មុខងារបង្ហាញផ្ទាំងសង្ខេបទិន្នន័យ
  void _showSuccessBottomSheet(dynamic parsedData) {
    int expCount = parsedData.experiences.length;
    int eduCount = parsedData.educations.length;
    int skillCount = parsedData.skills.length;

    Get.bottomSheet(
      ExtractionSuccessSheet(
        expCount: expCount,
        eduCount: eduCount,
        skillCount: skillCount,
        onReview: () {
          Get.back();
          Get.toNamed(AppRoutes.cvReview, arguments: parsedData);
        },
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );
  }
}
