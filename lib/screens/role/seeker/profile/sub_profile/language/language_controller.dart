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

  // ─── Text Controllers ───
  final languageNameCtrl = TextEditingController();
  final proficiencyCtrl = TextEditingController();

  // ─── រៀបចំ Form ───
  void clearForm() {
    editingId.value = null;
    languageNameCtrl.clear();
    proficiencyCtrl.clear();
  }

  void populateForm(LanguageModel language) {
    editingId.value = language.id;
    // សន្មតថា LanguageModel មាន name និង proficiency
    languageNameCtrl.text = language.language;
    proficiencyCtrl.text = language.proficiency;
  }

  // ─── រក្សាទុក (Save / Update) ───
  Future<void> saveLanguage() async {
    if (languageNameCtrl.text.trim().isEmpty ||
        proficiencyCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please select both language and proficiency level.',
        backgroundColor: Colors.orange,
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

      await _parentController.fetchCompleteProfile(); // Refresh Profile Data

      Get.back();
      Get.snackbar(
        'Success',
        'Language saved successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ─── លុប (Delete) ───
  Future<void> deleteLanguage(String id) async {
    try {
      isLoading.value = true;
      await _profileService.deleteLanguage(id);
      await _parentController.fetchCompleteProfile();
      Get.snackbar(
        'Deleted',
        'Language removed.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
