part of 'education_view.dart';

class EducationViewController extends GetxController {
  final ProfileCrudService _profileService = ProfileCrudService();

  final _parentController = Get.find<ProfileScreenViewController>();

  // ─── State Variables ───
  final isLoading = false.obs;
  final isSaving = false.obs;
  final Rx<String?> editingId = Rx<String?>(null);

  List<EducationModel> get educationList =>
      _parentController.profileData.value?.educations ?? [];

  // ─── Text Controllers ───
  final schoolNameCtrl = TextEditingController();
  final degreeCtrl = TextEditingController();
  final fieldOfStudyCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();

  // ─── Helper: ទម្រង់កាលបរិច្ឆេទសម្រាប់ Form ───
  String _formatDateForInput(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return dateStr.split('T').first;
    }
  }

  // ─── 1. រៀបចំ Form សម្រាប់ការ Add ថ្មី ───
  void clearForm() {
    editingId.value = null;
    schoolNameCtrl.clear();
    degreeCtrl.clear();
    fieldOfStudyCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
  }

  // ─── 2. រៀបចំ Form សម្រាប់ការ Edit ───
  void populateForm(EducationModel edu) {
    editingId.value = edu.id;
    schoolNameCtrl.text = edu.schoolName;
    degreeCtrl.text = edu.degree;
    fieldOfStudyCtrl.text = edu.fieldOfStudy ?? '';
    startDateCtrl.text = _formatDateForInput(edu.startDate);
    endDateCtrl.text = _formatDateForInput(edu.endDate);
  }

  // ─── 3. មុខងារ Save (Add & Update) ───
  Future<void> saveEducation() async {
    // Validation ងាយៗ
    if (schoolNameCtrl.text.trim().isEmpty || degreeCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'School Name and Degree are required.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSaving.value = true;

      // រៀបចំទិន្នន័យ (Payload)
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

      // បាញ់ API ទៅតាមលក្ខខណ្ឌ
      if (editingId.value != null) {
        // UPDATE
        await _profileService.updateEducation(editingId.value!, payload);
      } else {
        // ADD NEW
        await _profileService.addEducation(payload);
      }

      await _parentController.fetchCompleteProfile();

      Get.back(); // បិទ Form
      Get.snackbar(
        'Success',
        editingId.value == null
            ? 'Education added successfully.'
            : 'Education updated successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ─── 4. មុខងារ Delete ───
  Future<void> deleteEducation(String id) async {
    try {
      isLoading.value = true;

      await _profileService.deleteEducation(id);
      await _parentController.fetchCompleteProfile();

      Get.snackbar(
        'Deleted',
        'Education background has been removed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  onClose() {
    schoolNameCtrl.dispose();
    degreeCtrl.dispose();
    fieldOfStudyCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
  }
}
