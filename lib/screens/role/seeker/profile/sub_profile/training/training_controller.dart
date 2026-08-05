part of 'training_view.dart';

class TrainingViewController extends GetxController {
  final ProfileCrudService _profileService = ProfileCrudService();
  final _parentController = Get.find<ProfileScreenViewController>();

  final isLoading = false.obs;
  final isSaving = false.obs;
  List<TrainingModel> get trainingList =>
      _parentController.profileData.value?.trainings ?? [];
  final editingId = Rx<String?>(null);

  // ─── Text Controllers ───
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

  // ─── រៀបចំ Form ───
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
    // 💡 សន្មតថា TrainingModel មាន Fields ទាំងនេះ
    courseNameCtrl.text = training.courseName;
    institutionCtrl.text = training.institution;
    startDateCtrl.text = _formatDateForInput(training.startDate);
    endDateCtrl.text = _formatDateForInput(training.endDate);
    certificateUrlCtrl.text = training.certificateUrl ?? '';
    descriptionCtrl.text = training.description ?? '';
  }

  // ─── រក្សាទុក (Save / Update) ───
  Future<void> saveTraining() async {
    if (courseNameCtrl.text.trim().isEmpty ||
        institutionCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Course Name and Institution are required.',
        backgroundColor: Colors.orange,
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
        'Success',
        'Training saved successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackbar('Failed to save: $e');
    } finally {
      isSaving.value = false;
    }
  }

  // ─── លុប (Delete) ───
  Future<void> deleteTraining(String id) async {
    try {
      isLoading.value = true;
      await _profileService.deleteTraining(id);
      await _parentController.fetchCompleteProfile();
      Get.snackbar(
        'Deleted',
        'Training removed.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackbar('Failed to delete: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String msg) => Get.snackbar(
    'Error',
    msg,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
}
