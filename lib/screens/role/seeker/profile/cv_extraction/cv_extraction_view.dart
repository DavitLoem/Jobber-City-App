import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/core/api/services/role/seeker/cv_extraction_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/cv_extraction_model.dart';
import 'package:url_launcher/url_launcher.dart';

part 'cv_extraction_binding.dart';
part 'cv_extraction_controller.dart';

class CvExtractionView extends GetView<CvExtractionViewController> {
  const CvExtractionView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ស្តាប់រាល់ពេលមាន Error លោតឡើង ដើម្បីបង្ហាញជា Snackbar[cite: 8]
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

    // 🎯 ស្តាប់រាល់ពេលការទាញយកទិន្នន័យជោគជ័យ ដើម្បីបង្ហាញ BottomSheet ឬ លោតទៅអេក្រង់ Review[cite: 8]
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
            // ── ផ្នែក UI គោល ──[cite: 8]
            SingleChildScrollView(
              // 🎯 ប្តូរមកប្រើ Scroll ដើម្បីកុំឱ្យ Overflow ពេលមានកាត CV
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🎯 ផ្នែកបង្ហាញ CV បច្ចុប្បន្ន (លោតចេញតែពេលមាន resumeUrl ប៉ុណ្ណោះ)
                  if (controller.currentResumeUrl.value.isNotEmpty) ...[
                    _buildCurrentResumeCard(),
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
                    const SizedBox(height: 40), // ទីធ្លាសម្រាប់ពេលគ្មាន CV
                  ],

                  // រូបតំណាង Upload[cite: 8]
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.5),
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
                    // 🎯 ប្តូរអត្ថបទទៅតាមស្ថានភាព
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

                  // ប៊ូតុង Upload[cite: 8]
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      // បិទប៊ូតុងមិនឱ្យចុចត្រួតគ្នាពេលកំពុង Scan[cite: 8]
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
                        // 🎯 ប្តូរឈ្មោះប៊ូតុងទៅតាមស្ថានភាព
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

            // ── ផ្ទាំង Loading Overlay (បង្ហាញពេលកំពុង Scan ពីលើ UI គោល) ──[cite: 8]
            if (controller.isScanning.value)
              Container(
                color: Colors.black.withOpacity(
                  0.4,
                ), // ផ្ទៃងងឹតពីក្រោយ[cite: 8]
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'AI is analyzing your CV...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This might take a few seconds.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // 🎯 Widget បង្ហាញកាត CV បច្ចុប្បន្ន
  // 🎯 Widget បង្ហាញកាត CV បច្ចុប្បន្ន
  Widget _buildCurrentResumeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.redAccent,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.currentResumeFilename, // 🎯 ប្រើឈ្មោះ File ពិត
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Uploaded Document",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          // 🎯 បង្ហាញប៊ូតុង View និង Delete
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppColors.primary,
                ),
                onPressed: () => controller.viewCurrentResume(),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
                onPressed: () =>
                    controller.deleteCurrentResume(), // 🎯 ហៅមុខងារលុប
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// មុខងារបង្ហាញផ្ទាំងសង្ខេបទិន្នន័យ (ហៅចេញពី View នេះផ្ទាល់)[cite: 8]
  void _showSuccessBottomSheet(dynamic parsedData) {
    // ប្រើ dynamic ជាបណ្តោះអាសន្ន ឬប្តូរទៅជា Model ពិតរបស់អ្នក (ParsedDataModel)[cite: 8]
    int expCount = parsedData.experiences.length;
    int eduCount = parsedData.educations.length;
    int skillCount = parsedData.skills.length;

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
            const Center(
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Scan Complete!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We found $expCount experiences, $eduCount educations, and $skillCount skills in your CV.',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.back(); // បិទ BottomSheet សិន
                },
                child: const Text(
                  'Review Data',
                  style: TextStyle(
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
      isScrollControlled: true,
      isDismissible: false, // ការពារកុំឱ្យចុចបិទចោលដោយអចេតនា
      enableDrag: false,
    );
  }
}
