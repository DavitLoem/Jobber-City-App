part of 'cv_extraction_view.dart';

class CvExtractionViewController extends GetxController {
  final CvExtractionService _service = CvExtractionService();
  final ApiClient _apiClient = ApiClient();

  final extractionResult = Rxn<CvExtractionResponseModel>();
  final isScanning = false.obs;
  final errorMessage = ''.obs;

  final currentResumeUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentResumeUrl();
  }

  // 🎯 Getter សម្រាប់កាត់យកឈ្មោះ File ពី URL
  String get currentResumeFilename {
    if (currentResumeUrl.value.isEmpty) return "";
    try {
      return Uri.parse(currentResumeUrl.value).pathSegments.last;
    } catch (e) {
      return "Uploaded_Resume.pdf";
    }
  }

  Future<void> fetchCurrentResumeUrl() async {
    try {
      final response = await _apiClient.get('/seeker/profile/');
      if (response != null && response['data'] != null) {
        var data = response['data'];
        currentResumeUrl.value = data['resume_url'] ?? '';
      }
    } catch (e) {
      currentResumeUrl.value = '';
    }
  }

  Future<void> viewCurrentResume() async {
    if (currentResumeUrl.value.isEmpty) return;
    final Uri url = Uri.parse(currentResumeUrl.value);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not open the document.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 🎯 មុខងារលុប CV
  Future<void> deleteCurrentResume() async {
    bool? confirm = await Get.defaultDialog<bool>(
      title: "Delete Resume",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to remove your current resume?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.black87,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirm != true) return;

    try {
      isScanning.value = true; // ប្រើ Loading ដដែល

      await _service.deleteCv(); // ហៅ Service លុប

      currentResumeUrl.value = ''; // Update UI ភ្លាមៗ

      Get.snackbar(
        'Deleted',
        'Your resume has been removed.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> pickAndProcessCv() async {
    try {
      errorMessage.value = '';
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) return;

      File cvFile = File(result.files.single.path!);
      isScanning.value = true;

      final response = await _service.uploadAndExtractCv(cvFile);
      extractionResult.value = response;

      // បន្ទាប់ពី Upload ជោគជ័យ ទាញយក URL ថ្មីមកបង្ហាញ
      await fetchCurrentResumeUrl();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isScanning.value = false;
    }
  }
}
