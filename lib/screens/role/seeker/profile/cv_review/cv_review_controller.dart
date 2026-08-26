part of 'cv_review_view.dart';

class CvReviewViewController extends GetxController {
  // 🎯 ១. អថេរសម្រាប់បង្ហាញ State Loading ពេលចុច Save
  final isLoading = false.obs;

  // 🎯 ២. TextControllers សម្រាប់គ្រប់គ្រងទិន្នន័យ Personal Info
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  final skillInputCtrl = TextEditingController();

  // 🎯 ៣. Observable Lists សម្រាប់បទពិសោធន៍ ការសិក្សា និងជំនាញ
  final skills = <String>[].obs;
  final experiences = <ExperienceModel>[].obs;
  final educations = <EducationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDataFromArguments();
  }

  // 🎯 ៤. មុខងារទាញយកទិន្នន័យដែលបោះមកពីអេក្រង់ Upload CV
  void _loadDataFromArguments() {
    if (Get.arguments != null && Get.arguments is ParsedDataModel) {
      final ParsedDataModel data = Get.arguments;

      if (data.personalInfo != null) {
        firstNameCtrl.text = data.personalInfo!.firstName ?? '';
        lastNameCtrl.text = data.personalInfo!.lastName ?? '';
        emailCtrl.text = data.personalInfo!.email ?? '';
        phoneCtrl.text = data.personalInfo!.phoneNumber ?? '';
        bioCtrl.text = data.personalInfo!.biography ?? '';
      }

      skills.assignAll(data.skills);
      experiences.assignAll(data.experiences);
      educations.assignAll(data.educations);
    }
  }

  void addSkill() {
    final newSkill = skillInputCtrl.text.trim();
    if (newSkill.isNotEmpty && !skills.contains(newSkill)) {
      skills.add(newSkill);
      skillInputCtrl.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  void removeExperience(int index) {
    experiences.removeAt(index);
  }

  void addOrUpdateExperience(ExperienceModel exp, {int? index}) {
    if (index != null) {
      experiences[index] = exp;
    } else {
      experiences.add(exp);
    }
  }

  void removeEducation(int index) {
    educations.removeAt(index);
  }

  void addOrUpdateEducation(EducationModel edu, {int? index}) {
    if (index != null) {
      educations[index] = edu;
    } else {
      educations.add(edu);
    }
  }

  Future<void> saveReviewedData() async {
    try {
      isLoading.value = true;

      // TODO: API Call Here

      await Future.delayed(const Duration(seconds: 2));

      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        'Success'.tr, // 🟢 Added .tr
        'Your profile has been updated successfully!'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.greenAccent
            : Colors.white, // 🟢 Dynamic Text
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back();
    } catch (e) {
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        e.toString().tr,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.redAccent, // 🟢 Dynamic BG
        colorText: isDark ? Colors.redAccent : Colors.white, // 🟢 Dynamic Text
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    bioCtrl.dispose();
    skillInputCtrl.dispose();
    super.onClose();
  }
}
