part of 'training_view.dart';

class TrainingViewController extends GetxController {
  final ProfileCrudService _profileService = ProfileCrudService();
  final _parentController = Get.find<ProfileScreenViewController>();

  final isLoading = false.obs;
  final isSaving = false.obs;
  List<TrainingModel> get trainingList =>
      _parentController.profileData.value?.trainings ?? [];
  final editingId = Rx<String?>(null);

  final courseNameCtrl = TextEditingController();
  final institutionCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final certificateUrlCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  String _formatDateForInput(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(dateStr));
    } catch (e) {
      return dateStr.split('T').first;
    }
  }

  void clearForm() {
    editingId.value = null;
    courseNameCtrl.clear();
    institutionCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
    certificateUrlCtrl.clear();
    descriptionCtrl.clear();
  }

  void populateForm(TrainingModel training) {
    editingId.value = training.id;
    courseNameCtrl.text = training.courseName;
    institutionCtrl.text = training.institution;
    startDateCtrl.text = _formatDateForInput(training.startDate);
    endDateCtrl.text = _formatDateForInput(training.endDate);
    certificateUrlCtrl.text = training.certificateUrl ?? '';
    descriptionCtrl.text = training.description ?? '';
  }

  Future<void> saveTraining() async {
    if (courseNameCtrl.text.trim().isEmpty ||
        institutionCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Required'.tr, // 🟢 Added .tr
        'Course Name and Institution are required.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;

      final payload = TrainingModel(
        id: editingId.value,
        courseName: courseNameCtrl.text.trim(),
        institution: institutionCtrl.text.trim(),
        startDate: startDateCtrl.text.trim().isNotEmpty
            ? startDateCtrl.text.trim()
            : null,
        endDate: endDateCtrl.text.trim().isNotEmpty
            ? endDateCtrl.text.trim()
            : null,
        certificateUrl: certificateUrlCtrl.text.trim(),
        description: descriptionCtrl.text.trim(),
      );

      if (editingId.value != null) {
        await _profileService.updateTraining(editingId.value!, payload);
      } else {
        await _profileService.addTraining(payload);
      }

      await _parentController.fetchCompleteProfile();

      Get.back();
      Get.snackbar(
        'Success'.tr, // 🟢 Added .tr
        'Training saved successfully.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackbar('Failed to save: '.tr + '$e'); // 🟢 Added .tr
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteTraining(String id) async {
    try {
      isLoading.value = true;
      await _profileService.deleteTraining(id);
      await _parentController.fetchCompleteProfile();
      Get.snackbar(
        'Deleted'.tr, // 🟢 Added .tr
        'Training removed.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackbar('Failed to delete: '.tr + '$e'); // 🟢 Added .tr
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String msg) => Get.snackbar(
    'Error'.tr, // 🟢 Added .tr
    msg,
    backgroundColor: AppColors.error,
    colorText: Colors.white,
  );
}
