part of 'biography_view.dart';

class BiographyViewController extends GetxController {
  final ProfileScreenViewController _parentController =
      Get.find<ProfileScreenViewController>();
  final SeekerProfileServices _profileServices = SeekerProfileServices();

  final isLoading = false.obs;
  final isSaving = false.obs;

  final biographyCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadExistingBiography();
  }

  void _loadExistingBiography() {
    final currentProfile = _parentController.profileData.value;
    if (currentProfile != null) {
      biographyCtrl.text = currentProfile.biography;
    }
  }

  Future<void> saveBiography() async {
    final currentProfile = _parentController.profileData.value;

    if (currentProfile == null) return;

    try {
      isSaving.value = true;

      // 🎯 ប្រើប្រាស់មុខងាររួម (Clean & Short)
      final updateRequest = currentProfile.toUpdateRequest(
        biography: biographyCtrl.text.trim(),
      );

      final success = await _profileServices.updateCoreProfile(updateRequest);

      if (success) {
        await _parentController.fetchCompleteProfile(); // Refresh
        Get.back();
        Get.snackbar(
          'Success',
          'Biography updated successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update biography.',
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
    biographyCtrl.dispose();
    super.onClose();
  }
}
