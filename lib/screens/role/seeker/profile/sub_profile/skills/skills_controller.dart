part of 'skills_view.dart';

class SkillsViewController extends GetxController {
  final ProfileScreenViewController _parentController =
      Get.find<ProfileScreenViewController>();
  final SeekerProfileServices _profileServices = SeekerProfileServices();

  final isLoading = false.obs;
  final isSaving = false.obs;

  // 🎯 បញ្ជីជំនាញសម្រាប់បង្ហាញលើ UI
  final skillsList = <String>[].obs;

  // 🎯 ប្រអប់វាយបញ្ចូល
  final skillInputCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadExistingSkills();
  }

  // ទាញយក Skill ចាស់ៗពី Profile មេមកបង្ហាញ
  void _loadExistingSkills() {
    final currentProfile = _parentController.profileData.value;
    if (currentProfile != null && currentProfile.skills.isNotEmpty) {
      skillsList.assignAll(currentProfile.skills);
    }
  }

  // 🎯 មុខងារបន្ថែម Skill ចូលទៅក្នុង List (Local)
  void addSkill() {
    final newSkill = skillInputCtrl.text.trim();
    if (newSkill.isNotEmpty && !skillsList.contains(newSkill)) {
      skillsList.add(newSkill);
      skillInputCtrl.clear(); // លុបអក្សរក្នុងប្រអប់ចោលបន្ទាប់ពី Add
    } else if (skillsList.contains(newSkill)) {
      Get.snackbar(
        'Notice',
        'This skill is already added.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 🎯 មុខងារលុប Skill ចេញពី List (Local)
  void removeSkill(String skill) {
    skillsList.remove(skill);
  }

  // 🎯 មុខងារ Save ទៅកាន់ Backend
  Future<void> saveSkills() async {
    final currentProfile = _parentController.profileData.value;

    if (currentProfile == null) {
      Get.snackbar(
        'Error',
        'Profile data is missing. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;

      // 🎯 រៀបចំ Request Object ដោយចម្លងទិន្នន័យចាស់ទាំងអស់ ហើយដូរតែ skills
      final updateRequest = SeekerCoreUpdateRequest(
        firstName: currentProfile.firstName,
        lastName: currentProfile.lastName,
        dateOfBirth: currentProfile.dateOfBirth,
        gender: currentProfile.gender,
        maritalStatus: currentProfile.maritalStatus,
        nationality: currentProfile.nationality,
        currentPosition: currentProfile.currentPosition,
        email: currentProfile.email,
        phoneNumber: currentProfile.phoneNumber,
        addressProvinceId: currentProfile.addressProvinceId,
        addressDistrictId: currentProfile.addressDistrictId,
        commune: currentProfile.commune,
        village: currentProfile.village,
        street: currentProfile.street,
        houseNo: currentProfile.houseNo,
        biography: currentProfile.biography,
        expectedSalaryMin: currentProfile.expectedSalaryMin,
        expectedSalaryMax: currentProfile.expectedSalaryMax,
        jobTypePreferences: currentProfile.jobTypePreferences,
        expertiseCategoryIds: currentProfile.expertiseCategoryIds,
        skills: skillsList.toList(), // 🟢 បញ្ចូល List Skills ថ្មីនៅទីនេះ
        portfolioUrl: currentProfile.portfolioUrl,
        linkedinUrl: currentProfile.linkedinUrl,
        onboardingCompleted: currentProfile.onboardingCompleted,
      );

      // បាញ់ API Update Core Profile
      final success = await _profileServices.updateCoreProfile(updateRequest);

      if (success) {
        // Refresh Profile ទំព័រមេ
        await _parentController.fetchCompleteProfile();

        Get.back();
        Get.snackbar(
          'Success',
          'Skills updated successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update skills.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    skillInputCtrl.dispose();
    super.onClose();
  }
}
