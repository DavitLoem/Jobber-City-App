part of 'education_view.dart';

class EducationViewController extends GetxController {
  final ProfileCrudService _profileService = ProfileCrudService();
  final _parentController = Get.find<ProfileScreenViewController>();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final Rx<String?> editingId = Rx<String?>(null);

  List<EducationModel> get educationList =>
      _parentController.profileData.value?.educations ?? [];

  final schoolNameCtrl = TextEditingController();
  final degreeCtrl = TextEditingController();
  final fieldOfStudyCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();

  String _formatDateForInput(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return dateStr.split('T').first;
    }
  }

  void clearForm() {
    editingId.value = null;
    schoolNameCtrl.clear();
    degreeCtrl.clear();
    fieldOfStudyCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
  }

  void populateForm(EducationModel edu) {
    editingId.value = edu.id;
    schoolNameCtrl.text = edu.schoolName;
    degreeCtrl.text = edu.degree;
    fieldOfStudyCtrl.text = edu.fieldOfStudy ?? '';
    startDateCtrl.text = _formatDateForInput(edu.startDate);
    endDateCtrl.text = _formatDateForInput(edu.endDate);
  }

  Future<void> saveEducation() async {
    if (schoolNameCtrl.text.trim().isEmpty || degreeCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error'.tr, // 🟢 Added .tr
        'School Name and Degree are required.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSaving.value = true;

      final payload = EducationModel(
        id: editingId.value,
        schoolName: schoolNameCtrl.text.trim(),
        degree: degreeCtrl.text.trim(),
        fieldOfStudy: fieldOfStudyCtrl.text.trim(),
        startDate: startDateCtrl.text.trim().isNotEmpty
            ? startDateCtrl.text.trim()
            : null,
        endDate: endDateCtrl.text.trim().isNotEmpty
            ? endDateCtrl.text.trim()
            : null,
      );

      if (editingId.value != null) {
        await _profileService.updateEducation(editingId.value!, payload);
      } else {
        await _profileService.addEducation(payload);
      }

      await _parentController.fetchCompleteProfile();

      Get.back();
      Get.snackbar(
        'Success'.tr, // 🟢 Added .tr
        editingId.value == null
            ? 'Education added successfully.'
                  .tr // 🟢 Added .tr
            : 'Education updated successfully.'.tr, // 🟢 Added .tr
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Failed to save: '.tr + '$e', // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteEducation(String id) async {
    try {
      isLoading.value = true;

      await _profileService.deleteEducation(id);
      await _parentController.fetchCompleteProfile();

      Get.snackbar(
        'Deleted'.tr, // 🟢 Added .tr
        'Education background has been removed.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Failed to delete: '.tr + '$e', // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    schoolNameCtrl.dispose();
    degreeCtrl.dispose();
    fieldOfStudyCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    super.onClose();
  }
}
