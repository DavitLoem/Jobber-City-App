part of 'educations_screen_view.dart';

class EducationsScreenViewController extends GetxController {
  final EducationsServices educationsServices = EducationsServices();
  final SeekerProfileServices seekerProfileServices = SeekerProfileServices();

  final TextEditingController schoolNameCtrl = TextEditingController();
  final TextEditingController degreeCtrl = TextEditingController();
  final TextEditingController fieldOfStudyCtrl = TextEditingController();
  final TextEditingController startDateCtrl = TextEditingController();
  final TextEditingController endDateCtrl = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // ហៅមុខងារទាញទិន្នន័យពេលចូលមកដល់ទំព័រនេះភ្លាម
    fetchEducationsData();
  }

  Future<void> fetchEducationsData() async {
    try {
      isLoading.value = true;
      final response = await seekerProfileServices.getSeekerProfile();

      debugPrint('Profile response: $response');

      // if (response != null && response is Map && response['data'] != null) {
      //   final data = response['data'];

      //   // ចាប់យក Array នៃ Education ពី API
      //   final educations = data['educations'] as List<dynamic>? ?? [];

      //   if (educations.isNotEmpty) {
      //     // ចាប់យកទិន្នន័យចុងក្រោយគេបង្អស់ (ឬអាចប្រើ .first ទៅតាមការចង់បាន)
      //     final eduData = educations.last;

      //     // 🟢 បញ្ចូលទិន្នន័យទៅក្នុង Textfield ទាំងអស់
      //     schoolNameCtrl.text = eduData['school_name']?.toString() ?? '';
      //     degreeCtrl.text = eduData['degree']?.toString() ?? '';
      //     fieldOfStudyCtrl.text = eduData['field_of_study']?.toString() ?? '';

      //     // កាត់យកតែថ្ងៃខែឆ្នាំ ដោយកាត់អក្សរ 'T' ចេញពី "2026-07-01T00:00:00"
      //     startDateCtrl.text =
      //         eduData['start_date']?.toString().split('T').first ?? '';
      //     endDateCtrl.text =
      //         eduData['end_date']?.toString().split('T').first ?? '';
      //   }
      // }
    } catch (e) {
      debugPrint('Error fetching educations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> saveEducation() async {
    if (schoolNameCtrl.text.trim().isEmpty ||
        degreeCtrl.text.trim().isEmpty ||
        fieldOfStudyCtrl.text.trim().isEmpty ||
        startDateCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Notice",
        "School Name, Degree, Field of Study, and Start Date are required!",
      );
      return;
    }

    isLoading.value = true;
    try {
      final newEducation = EducationsModel(
        schoolName: schoolNameCtrl.text.trim(),
        degree: degreeCtrl.text.trim(),
        fieldOfStudy: fieldOfStudyCtrl.text.trim(),
        startDate: startDateCtrl.text.trim(),
        endDate: endDateCtrl.text.trim().isEmpty
            ? null
            : endDateCtrl.text.trim(),
      );

      // បញ្ជូនទិន្នន័យទៅ API
      await educationsServices.educations(newEducation);

      Get.snackbar(
        "Success",
        "Education added successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back(); // ថយក្រោយពេលជោគជ័យ
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add education: $e",
        backgroundColor: Colors.red,
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
