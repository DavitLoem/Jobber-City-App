part of 'cv_extraction_view.dart';

class CvExtractionViewController extends GetxController {
  final CvExtractionService _service = CvExtractionService();
  final ApiClient _apiClient = ApiClient();

  CancelToken? _cancelToken;

  final extractionResult = Rxn<CvExtractionResponseModel>();
  final isScanning = false.obs;
  final errorMessage = ''.obs;

  final currentResumeUrl = ''.obs;
  final currentResumeFilename = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentResumeUrl();
  }

  void cancelScanning() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("User cancelled the upload.");
    }
    isScanning.value = false;
  }

  Future<void> fetchCurrentResumeUrl() async {
    try {
      final response = await _apiClient.get('/seeker/profile/');
      if (response != null && response['data'] != null) {
        var data = response['data'];
        currentResumeUrl.value = data['resume_url'] ?? '';

        // 🎯 ៣. ទាញយកឈ្មោះ File ពី Response ដែល Backend បោះមក
        // បើអត់មានឈ្មោះ (ឯកសារចាស់) យើងបង្ហាញពាក្យ "Uploaded_Resume.pdf" សិន
        currentResumeFilename.value =
            data['resume_filename'] != null &&
                data['resume_filename'].toString().isNotEmpty
            ? data['resume_filename']
            : "Uploaded_Resume.pdf";
      }
    } catch (e) {
      currentResumeUrl.value = '';
      currentResumeFilename.value = '';
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
      isScanning.value = true;

      await _service.deleteCv();

      // 🎯 ៤. Clear ទិន្នន័យទាំង URL ទាំងឈ្មោះ File ពេលលុបជោគជ័យ
      currentResumeUrl.value = '';
      currentResumeFilename.value = '';

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

      _cancelToken = CancelToken();
      isScanning.value = true;

      final response = await _service.uploadAndExtractCv(
        cvFile,
        cancelToken: _cancelToken,
      );
      extractionResult.value = response;

      await fetchCurrentResumeUrl();
    } catch (e) {
      // 🎯 ៥. ឆែកមើលថាតើ Error នេះមកពីការចុច Cancel ដែរឬទេ បើពិតមែនមិនបាច់លោត Snackbar ទេ
      if (e is DioException && e.type == DioExceptionType.cancel) {
        debugPrint("Upload was cancelled by user.");
      } else {
        errorMessage.value = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      isScanning.value = false;
      _cancelToken = null; // destroy the cancel token after operation
    }
  }
}
