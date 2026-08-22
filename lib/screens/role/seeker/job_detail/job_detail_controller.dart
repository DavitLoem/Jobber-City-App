part of 'job_detail_view.dart';

class JobDetailController extends GetxController {
  // 🎯 ប្រើប្រាស់អថេរតែមួយគត់ដើម្បីផ្ទុកទិន្នន័យ Model ទាំងមូល (Rxn ព្រោះវាអាចជា null មុនពេលទាញយក)
  final job = Rxn<JobFeedModel>();
  final ApplicationService _appService = ApplicationService();
  final ApiClient _apiClient = ApiClient();
  final ChatService _chatService = ChatService();
  final BookmarkController bookmarkCtrl = Get.put(BookmarkController());

  final isStartingChat = false.obs;

  // ស្ថានភាព UI
  var isDescriptionExpanded = false.obs;
  var isApplying = false.obs;
  var hasApplied = false.obs;

  var resumeUrl = ''.obs;
  var resumeFilename = ''.obs;
  var isLoadingProfile = true.obs;

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

  // 🎯 មុខងារទាញយក Profile ដើម្បីឆែកមើល CV
  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile.value = true;
      final response = await _apiClient.get('/seeker/profile/');
      if (response != null && response['data'] != null) {
        resumeUrl.value = response['data']['resume_url'] ?? '';
        resumeFilename.value =
            response['data']['resume_filename'] ??
            'My_Resume.pdf'; // 🎯 ទាញយកឈ្មោះ CV មកដាក់ (បើគ្មានដាក់ Default)
      }
    } catch (e) {
      debugPrint("Error fetching profile for CV check: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Lets the seeker message the employer directly from a job posting —
  /// mirrors the "Message" flow employers already have on candidate detail,
  /// so a seeker isn't stuck waiting for the employer to reach out first
  /// (e.g. to ask a question or send their CV before formally applying).
  Future<void> messageEmployer() async {
    final currentJob = job.value;
    if (currentJob == null || isStartingChat.value) return;

    if (currentJob.employerUserId == null || currentJob.employerUserId!.isEmpty) {
      Get.snackbar(
        'Unavailable',
        'This employer cannot be messaged right now.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isStartingChat.value = true;
    try {
      final convo = await _chatService.startConversation(
        otherUserId: currentJob.employerUserId!,
        jobId: currentJob.id,
      );
      await Get.toNamed(
        AppRoutes.chatThread,
        arguments: ChatThreadArgs(
          conversationId: convo.id,
          otherPartyName: currentJob.companyName,
          otherPartyAvatarUrl: currentJob.logoUrl,
          otherPartyRole: 'employer',
          jobId: currentJob.id,
        ),
      );
    } catch (e) {
      debugPrint('[JobDetail] messageEmployer error: $e');
      Get.snackbar(
        'Could not start chat',
        'Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isStartingChat.value = false;
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

    try {
      final isSuccess = await _appService.applyForJob(
        jobId: job.value!.id,
        coverLetter: coverLetterController.text.trim(),
        // មិនបាច់ដាក់ resumeUrl ទេ ព្រោះ Backend នឹងទាញពី Profile ស្វ័យប្រវត្តិ
      );

      if (isSuccess) {
        hasApplied.value = true;
        job.value!.hasApplied = true;
        Get.back(); // 🎯 បិទផ្ទាំង Bottom Sheet វិញពេលជោគជ័យ

        if (Get.isRegistered<ApplicationViewController>()) {
          Get.find<ApplicationViewController>().fetchApplications();
        }

        Get.snackbar(
          "Application Sent! 🎉",
          "You have successfully applied to ${job.value!.companyName}.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.successBackground,
          colorText: AppColors.success,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      // 🎯 បង្ហាញ Error ពេលគាត់ដាក់ពាក្យលើស ១០ ដង ឬ Error ផ្សេងៗ
      Get.snackbar(
        "Application Failed",
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
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
