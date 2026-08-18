part of 'language_view.dart';

class LanguageViewController extends GetxController {
  final ProfileCrudService _profileService = ProfileCrudService();
  final ProfileScreenViewController _parentController =
      Get.find<ProfileScreenViewController>();

  final isLoading = false.obs;
  final isSaving = false.obs;

  List<LanguageModel> get languageList =>
      _parentController.profileData.value?.languages ?? [];
  final editingId = Rx<String?>(null);

  final languageNameCtrl = TextEditingController();
  final proficiencyCtrl = TextEditingController();

  void clearForm() {
    editingId.value = null;
    languageNameCtrl.clear();
    proficiencyCtrl.clear();
  }

  void populateForm(LanguageModel language) {
    editingId.value = language.id;
    languageNameCtrl.text = language.language;
    proficiencyCtrl.text = language.proficiency;
  }

  Future<void> saveLanguage() async {
    if (languageNameCtrl.text.trim().isEmpty ||
        proficiencyCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Required'.tr, // 🟢 Added .tr
        'Please select both language and proficiency level.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;

      final payload = LanguageModel(
        id: editingId.value,
        language: languageNameCtrl.text.trim(),
        proficiency: proficiencyCtrl.text.trim(),
      );

      if (editingId.value != null) {
        await _profileService.updateLanguage(editingId.value!, payload);
      } else {
        await _profileService.addLanguage(payload);
      }

      await _parentController.fetchCompleteProfile();

      Get.back();
      Get.snackbar(
        'Success'.tr, // 🟢 Added .tr
        'Language saved successfully.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Failed to save: '.tr + '$e', // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteLanguage(String id) async {
    try {
      isLoading.value = true;
      await _profileService.deleteLanguage(id);
      await _parentController.fetchCompleteProfile();
      Get.snackbar(
        'Deleted'.tr, // 🟢 Added .tr
        'Language removed.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Failed to delete: '.tr + '$e', // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
