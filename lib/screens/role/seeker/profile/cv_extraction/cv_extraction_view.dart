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
    // ស្តាប់រាល់ពេលមាន Error
    ever(controller.errorMessage, (String error) {
      if (error.isNotEmpty) {
        Get.snackbar(
          'Upload Failed',
          error,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    });

    // ស្តាប់រាល់ពេលការទាញយកទិន្នន័យជោគជ័យ
    ever(controller.extractionResult, (result) {
      if (result != null && result.parsedData != null) {
        _showSuccessBottomSheet(result.parsedData!);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Upload Resume',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
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
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR UPLOAD NEW",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
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
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    "Smart CV Parsing",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    controller.currentResumeUrl.value.isNotEmpty
                        ? "Upload a new PDF to replace your current resume and automatically update your profile data."
                        : "Upload your PDF resume and let our AI automatically extract your experience, education, and skills to save you time.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
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
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: Text(
                        controller.currentResumeUrl.value.isNotEmpty
                            ? "Replace PDF File"
                            : "Select PDF File",
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
              ScanningOverlay(
                onCancel: () =>
                    controller.cancelScanning(), // 🎯 បន្ថែមបន្ទាត់នេះ
              ),
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
      // 🎯 ហៅ ExtractionSuccessSheet មកប្រើ
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
