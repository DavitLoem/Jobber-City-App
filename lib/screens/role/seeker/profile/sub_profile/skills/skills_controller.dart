part of 'skills_view.dart';

class SkillsViewController extends GetxController {
  final ProfileScreenViewController _parentController =
      Get.find<ProfileScreenViewController>();
  final SeekerProfileServices _profileServices = SeekerProfileServices();

  final isLoading = false.obs;
  final isSaving = false.obs;

  final skillsList = <String>[].obs;
  final skillInputCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadExistingSkills();
  }

  void _loadExistingSkills() {
    final currentProfile = _parentController.profileData.value;
    if (currentProfile != null && currentProfile.skills.isNotEmpty) {
      skillsList.assignAll(currentProfile.skills);
    }
  }

  void addSkill() {
    final newSkill = skillInputCtrl.text.trim();
    if (newSkill.isNotEmpty && !skillsList.contains(newSkill)) {
      skillsList.add(newSkill);
      skillInputCtrl.clear();
    } else if (skillsList.contains(newSkill)) {
      Get.snackbar(
        'Notice'.tr, // 🟢 Added .tr
        'This skill is already added.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeSkill(String skill) {
    skillsList.remove(skill);
  }

  Future<void> saveSkills() async {
    final currentProfile = _parentController.profileData.value;

    if (currentProfile == null) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Profile data is missing. Please try again.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;

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
        skills: skillsList.toList(),
        portfolioUrl: currentProfile.portfolioUrl,
        linkedinUrl: currentProfile.linkedinUrl,
        onboardingCompleted: currentProfile.onboardingCompleted,
      );

      final success = await _profileServices.updateCoreProfile(updateRequest);

      if (success) {
        await _parentController.fetchCompleteProfile();

        Get.back();
        Get.snackbar(
          'Success'.tr, // 🟢 Added .tr
          'Skills updated successfully.'.tr, // 🟢 Added .tr
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error'.tr, // 🟢 Added .tr
          'Failed to update skills.'.tr, // 🟢 Added .tr
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'An error occurred: '.tr + '$e', // 🟢 Added .tr
        backgroundColor: AppColors.error,
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
