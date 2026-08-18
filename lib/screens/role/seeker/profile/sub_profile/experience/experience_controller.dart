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
    editingId.value = exp.id;
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
        'Required Fields'.tr, // 🟢 Added .tr
        'Job Title and Company Name cannot be empty!'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning,
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
        'Success'.tr, // 🟢 Added .tr
        'Experience saved successfully.'.tr, // 🟢 Added .tr
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

  // 🎯 ៧. មុខងារលុប
  Future<void> deleteExperience(String id) async {
    try {
      isLoading.value = true;

      await _profileService.deleteExperience(id);
      await _parentController.fetchCompleteProfile();

      Get.snackbar(
        'Deleted'.tr, // 🟢 Added .tr
        'Experience has been removed successfully.'.tr, // 🟢 Added .tr
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

  String _formatDateForInput(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return dateStr.split('T').first;
    }
  }

  @override
  void onClose() {
    jobTitleCtrl.dispose();
    companyNameCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
