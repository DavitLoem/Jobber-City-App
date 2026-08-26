part of 'job_detail_view.dart';

class JobDetailController extends GetxController {
  // 🎯 ប្រើប្រាស់អថេរតែមួយគត់ដើម្បីផ្ទុកទិន្នន័យ Model ទាំងមូល (Rxn ព្រោះវាអាចជា null មុនពេលទាញយក)
  final job = Rxn<JobFeedModel>();
  final ApplicationService _appService = ApplicationService();
  final ApiClient _apiClient = ApiClient();
  final BookmarkController bookmarkCtrl = Get.put(BookmarkController());

  // ស្ថានភាព UI
  var isDescriptionExpanded = false.obs;
  var isApplying = false.obs;
  var hasApplied = false.obs;

  var resumeUrl = ''.obs;
  var resumeFilename = ''.obs;
  var isLoadingProfile = true.obs;

  var coverLetterDocPath = ''.obs;
  var coverLetterDocName = ''.obs;

  final TextEditingController coverLetterController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // ទទួលយកទិន្នន័យដែលបញ្ជូនពីអេក្រង់ Home (Get.toNamed(..., arguments: job))
    if (Get.arguments is JobFeedModel) {
      job.value = Get.arguments as JobFeedModel;

      hasApplied.value = job.value!.hasApplied;
    }
    fetchUserProfile();
  }

  Future<void> pickCoverLetterDocument() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        // ត្រួតពិនិត្យទំហំកុំឱ្យលើស 5MB (ស្រេចចិត្ត)
        final file = File(result.files.single.path!);
        final sizeInBytes = await file.length();
        if (sizeInBytes > 5 * 1024 * 1024) {
          final isDark = Get.isDarkMode; // 🟢 Dark mode check for controller
          Get.snackbar(
            "File too large".tr, // 🟢 Added .tr
            "Please select a file smaller than 5MB.".tr, // 🟢 Added .tr
            backgroundColor: isDark
                ? AppColors.error.withValues(alpha: 0.15)
                : Colors.red.shade50,
            colorText: isDark ? Colors.redAccent : Colors.red.shade700,
          );
          return;
        }

        coverLetterDocPath.value = result.files.single.path!;
        coverLetterDocName.value = result.files.single.name;
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  void removeCoverLetterDocument() {
    coverLetterDocPath.value = '';
    coverLetterDocName.value = '';
  }

  // 🎯 មុខងារទាញយក Profile ដើម្បីឆែកមើល CV
  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile.value = true;
      final response = await _apiClient.get('/seeker/profile/');
      if (response != null && response['data'] != null) {
        resumeUrl.value = response['data']['resume_url'] ?? '';
        resumeFilename.value =
            response['data']['resume_filename'] ??
            'My_Resume.pdf'; // You could add .tr here if needed, but filenames shouldn't usually be translated
      }
    } catch (e) {
      debugPrint("Error fetching profile for CV check: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void toggleSave() {
    if (job.value == null) return;

    bookmarkCtrl.toggleBookmark(
      job: job.value!,
      onUpdate: () =>
          job.refresh(), // ប្រាប់ GetX ឱ្យគូរ UI ក្នុង Detail ឡើងវិញ
    );
  }

  Future<void> submitApplication() async {
    if (hasApplied.value ||
        isApplying.value ||
        job.value == null ||
        resumeUrl.value.isEmpty) {
      return;
    }

    isApplying.value = true;
    String? finalCoverLetterUrl;
    String? finalCoverLetterFilename;
    final isDark = Get.isDarkMode; // 🟢 Get current theme mode for snackbars

    try {
      if (coverLetterDocPath.value.isNotEmpty) {
        final uploadResult = await _appService.uploadCoverLetter(
          File(coverLetterDocPath.value),
        );
        finalCoverLetterUrl = uploadResult['cover_letter_url'];
        finalCoverLetterFilename = uploadResult['cover_letter_filename'];
      }

      final isSuccess = await _appService.applyForJob(
        jobId: job.value!.id,
        coverLetter: coverLetterController.text.trim(),
        coverLetterUrl: finalCoverLetterUrl,
        coverLetterFilename: finalCoverLetterFilename,
      );

      if (isSuccess) {
        hasApplied.value = true;
        job.value!.hasApplied = true;
        Get.back(); // 🎯 បិទផ្ទាំង Bottom Sheet វិញពេលជោគជ័យ

        if (Get.isRegistered<ApplicationViewController>()) {
          Get.find<ApplicationViewController>().fetchApplications();
        }

        Get.snackbar(
          "Application Sent! 🎉".tr, // 🟢 Added .tr
          "You have successfully applied to @company.".trParams({
            'company': job.value!.companyName,
          }), // 🟢 Added .trParams
          snackPosition: SnackPosition.TOP,
          backgroundColor: isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.successBackground,
          colorText: isDark ? Colors.greenAccent : AppColors.success,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      // 🎯 បង្ហាញ Error ពេលគាត់ដាក់ពាក្យលើស ១០ ដង ឬ Error ផ្សេងៗ
      Get.snackbar(
        "Application Failed".tr, // 🟢 Added .tr
        e
            .toString()
            .replaceAll("Exception: ", "")
            .tr, // 🟢 Tr catches known backend errors if mapped
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isApplying.value = false;
    }
  }

  @override
  void onClose() {
    coverLetterController.dispose();
    super.onClose();
  }
}
