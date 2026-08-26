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
      _cancelToken!.cancel("User cancelled the upload.".tr); // 🟢 Added .tr
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
      final isDark = Get.isDarkMode; // 🟢 Theme check for Snackbars
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Could not open the document.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
    }
  }

  // 🎯 មុខងារលុប CV
  Future<void> deleteCurrentResume() async {
    final isDark = Get.isDarkMode; // 🟢 Theme check for Dialog

    bool? confirm = await Get.defaultDialog<bool>(
      title: "Delete Resume".tr, // 🟢 Added .tr
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87, // 🟢 Dynamic text color
      ),
      middleText: "Are you sure you want to remove your current resume?"
          .tr, // 🟢 Added .tr
      middleTextStyle: TextStyle(
        color: isDark
            ? AppColors.darkTextSecondary
            : Colors.black87, // 🟢 Dynamic text color
      ),
      textConfirm: "Delete".tr, // 🟢 Added .tr
      textCancel: "Cancel".tr, // 🟢 Added .tr
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: isDark
          ? Colors.white
          : Colors.black87, // 🟢 Dynamic cancel color
      backgroundColor: isDark
          ? AppColors.darkSurfaceElevated
          : Colors.white, // 🟢 Dynamic BG
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
        'Deleted'.tr, // 🟢 Added .tr
        'Your resume has been removed.'.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.greenAccent
            : Colors.white, // 🟢 Dynamic Text
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e
          .toString()
          .replaceAll('Exception: ', '')
          .tr; // 🟢 Translate exception if mapped
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
        errorMessage.value = e
            .toString()
            .replaceAll('Exception: ', '')
            .tr; // 🟢 Added .tr for error propagation
      }
    } finally {
      isScanning.value = false;
      _cancelToken = null; // destroy the cancel token after operation
    }
  }
}
