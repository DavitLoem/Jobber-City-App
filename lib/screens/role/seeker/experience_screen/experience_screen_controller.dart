import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/experience_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/models/role/seeker/experience_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

class ExperienceScreenViewController extends GetxController {
  final ExperienceServices _experienceServices = ExperienceServices();
  final SeekerProfileServices _profileServices = SeekerProfileServices();

  // Controllers សម្រាប់ Form
  final jobTitleCtrl = TextEditingController();
  final companyNameCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  var isCurrentJob = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExperienceData();
  }

  Future<void> fetchExperienceData() async {
    try {
      isLoading.value = true;
      final response = await _profileServices.getSeekerProfile();

      debugPrint('Profile response: $response');

      // if (response != null && response is Map && response['data'] != null) {
      //   final data = response['data'];
      //   debugPrint('Data: $data');

      //   if (data['experiences'] != null &&
      //       (data['experiences'] as List).isNotEmpty) {
      //     final experiences = data['experiences'] as List;
      //     debugPrint('Experiences length: ${experiences.length}');
      //     final expData = experiences.last; // Get the most recent experience
      //     debugPrint('Last experience: $expData');

      //     jobTitleCtrl.text = expData['job_title']?.toString() ?? '';
      //     companyNameCtrl.text = expData['company_name']?.toString() ?? '';

      //     // Fix date format: split 'T' from datetime
      //     startDateCtrl.text =
      //         expData['start_date']?.toString().split('T').first ?? '';
      //     endDateCtrl.text =
      //         expData['end_date']?.toString().split('T').first ?? '';

      //     descriptionCtrl.text = expData['description']?.toString() ?? '';

      //     isCurrentJob.value =
      //         expData['is_current_job'] == true ||
      //         expData['is_current_job'] == "true";

      //     debugPrint('Job Title: ${jobTitleCtrl.text}');
      //     debugPrint('Company: ${companyNameCtrl.text}');
      //     debugPrint('Start Date: ${startDateCtrl.text}');
      //   } else {
      //     debugPrint('No experiences found');
      //   }
      // }
    } catch (e) {
      debugPrint("Fetch Experience Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // មុខងាររើសថ្ងៃខែ (Date Picker)
  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // មុខងារ Save ទិន្នន័យទៅកាន់ API
  Future<void> saveExperience() async {
    if (jobTitleCtrl.text.trim().isEmpty ||
        companyNameCtrl.text.trim().isEmpty ||
        startDateCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Notice",
        "Job Title, Company, and Start Date are required!",
      );
      return;
    }

    isLoading.value = true;
    try {
      final newExperience = ExperienceModel(
        jobTitle: jobTitleCtrl.text.trim(),
        companyName: companyNameCtrl.text.trim(),
        startDate: startDateCtrl.text.trim(),
        endDate: isCurrentJob.value ? null : endDateCtrl.text.trim(),
        isCurrentJob: isCurrentJob.value,
        description: descriptionCtrl.text.trim(),
      );

      await _experienceServices.addExperience(newExperience);

      Get.toNamed(AppRoutes.experience);
      Get.snackbar("Success", "Experience saved successfully!");
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    jobTitleCtrl.dispose();
    companyNameCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
