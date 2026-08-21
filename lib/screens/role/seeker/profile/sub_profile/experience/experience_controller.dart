part of 'experience_view.dart';

class ExperienceViewController extends GetxController {
  final ProfileCrudService _profileService = ProfileCrudService();
  final _parentController = Get.find<ProfileScreenViewController>();
  // 🎯 ១. អថេរគ្រប់គ្រង State
  final isLoading = false.obs;
  final isSaving = false.obs;
  List<ExperienceModel> get experienceList =>
      _parentController.profileData.value?.experiences ?? [];

  final jobTitleCtrl = TextEditingController();
  final companyNameCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final isCurrentJob = false.obs;
  final editingId = RxnString();

  // 🎯 ៤. មុខងាររៀបចំ Form ឱ្យទទេស្អាត (ហៅពេលចុចប៊ូតុង "Add Experience")
  void clearForm() {
    editingId.value = null;
    jobTitleCtrl.clear();
    companyNameCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
    descriptionCtrl.clear();
    isCurrentJob.value = false;
  }

  // 🎯 ៥. មុខងារបញ្ចូលទិន្នន័យចាស់ទៅក្នុង Form (ហៅពេលចុច Icon "Edit" លើកាត)
  void populateForm(ExperienceModel exp) {
    editingId.value = exp.id; // ត្រូវការ Id របស់ Item ដើម្បីបាញ់ API កែ
    jobTitleCtrl.text = exp.jobTitle;
    companyNameCtrl.text = exp.companyName;
    startDateCtrl.text = _formatDateForInput(exp.startDate);
    endDateCtrl.text = _formatDateForInput(exp.endDate);
    descriptionCtrl.text = exp.description ?? '';
    isCurrentJob.value = exp.isCurrentJob;
  }

  // 🎯 ៦. មុខងាររក្សាទុក (ដើរតួជា Add ផង និង Update ផង ផ្អែកលើ editingId)
  Future<void> saveExperience() async {
    if (jobTitleCtrl.text.trim().isEmpty ||
        companyNameCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Job Title and Company Name cannot be empty!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;

      // ១. រៀបចំ Model សម្រាប់បញ្ជូន
      final payload = ExperienceModel(
        id: editingId.value ?? '',
        jobTitle: jobTitleCtrl.text.trim(),
        companyName: companyNameCtrl.text.trim(),
        startDate: startDateCtrl.text.trim().isEmpty
            ? null
            : startDateCtrl.text.trim(),
        // បើគាត់រើសយក Current Job, End Date ត្រូវតែ null
        endDate: isCurrentJob.value || endDateCtrl.text.trim().isEmpty
            ? null
            : endDateCtrl.text.trim(),
        isCurrentJob: isCurrentJob.value,
        description: descriptionCtrl.text.trim(),
      );

      // ២. បាញ់ API ទៅតាមលក្ខខណ្ឌ
      if (editingId.value != null) {
        await _profileService.updateExperience(editingId.value!, payload);
      } else {
        await _profileService.addExperience(payload);
      }

      await _parentController.fetchCompleteProfile();

      Get.back();
      Get.snackbar(
        'Success',
        'Experience saved successfully.',
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

  // 🎯 ៧. មុខងារលុប
  Future<void> deleteExperience(String id) async {
    try {
      // បើក Loading State ពេលកំពុងលុប
      isLoading.value = true;

      // ១. ហៅ API លុប (DELETE Request) ទៅកាន់ Backend
      await _profileService.deleteExperience(id);

      // ២. ប្រាប់ Controller មេឱ្យទាញយកទិន្នន័យ Profile ថ្មីដើម្បី Update UI ភ្លាមៗ
      await _parentController.fetchCompleteProfile();

      // ៣. បង្ហាញសារជោគជ័យ
      Get.snackbar(
        'Deleted',
        'Experience has been removed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green, // ដាក់ពណ៌បៃតងព្រោះវាលុបជោគជ័យ
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
      // បិទ Loading State វិញទោះជោគជ័យ ឬបរាជ័យ
      isLoading.value = false;
    }
  }

  String _formatDateForInput(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      // បំប្លែងពី 2020-01-15T00:00:00 ទៅជា 2020-01-15
      final DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      // បើ Error, យកត្រឹមអក្សរ T
      return dateStr.split('T').first;
    }
  }

  @override
  void onClose() {
    // លុបចោលដើម្បីកុំឱ្យស៊ី Memory
    jobTitleCtrl.dispose();
    companyNameCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
