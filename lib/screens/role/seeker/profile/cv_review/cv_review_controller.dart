part of 'cv_review_view.dart';

class CvReviewViewController extends GetxController {
  final isLoading = false.obs;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  final skillInputCtrl = TextEditingController();

  final skills = <String>[].obs;
  final experiences = <ExperienceModel>[].obs;
  final educations = <EducationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDataFromArguments();
  }

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

      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success'.tr, // 🟢 Added .tr
        'Your profile has been updated successfully!'.tr, // 🟢 Added .tr
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
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
