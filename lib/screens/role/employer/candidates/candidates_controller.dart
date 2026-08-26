part of 'candidates_view.dart';

class CandidatesViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApplicantEmployerService applicantService = ApplicantEmployerService();
  final ChatRestService _chatRestService = Get.find<ChatRestService>();

  var isLoading = false.obs;
  var isJobsLoading = false.obs;
  var applicants = <ApplicantModel>[].obs;
  var postedJobs = <JobDropdownItemModel>[].obs;
  var selectedJobId = ''.obs;

  var currentPage = 1.obs;
  var isLoadMore = false.obs;
  var hasMore = true.obs;
  final int limit = 20;

  final searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  final List<String> tabs = [
    'all',
    'pending',
    'shortlisted',
    'interview',
    'hired',
    'rejected',
  ];

  late TabController tabController;

  var statusSummary = ApplicantStatusSummaryModel(
    all: 0,
    pending: 0,
    shortlisted: 0,
    interview: 0,
    hired: 0,
    rejected: 0,
  ).obs;

  var selectedApplicantIds = <String>[].obs;
  bool get isSelectionMode => selectedApplicantIds.isNotEmpty;

  var currentSort = 'newest'.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is String) {
      selectedJobId.value = Get.arguments as String;
    } else {
      selectedJobId.value = 'all';
    }

    tabController = TabController(length: tabs.length, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        changeTab(tabs[tabController.index]);
      }
    });

    fetchPostedJobs();
    fetchApplicants(isRefresh: true);
    fetchStatusSummary();
  }

  Future<void> startChatWithSeeker(ApplicantModel applicant) async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    if (applicant.seekerUserId.isEmpty) {
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Cannot start chat. User ID is missing.".tr, // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final conversation = await _chatRestService.startConversation(
        otherUserId: applicant.seekerUserId,
        jobId: (selectedJobId.value.isNotEmpty && selectedJobId.value != 'all')
            ? selectedJobId.value
            : null,
      );

      Get.back();

      Get.toNamed(
        AppRoutes.chatRoom,
        arguments: ChatThreadArgs(
          conversationId: conversation.id,
          otherPartyName: applicant.fullName,
          otherPartyAvatarUrl: applicant.profileImageUrl,
          otherPartyRole: 'seeker',
          jobId:
              (selectedJobId.value.isNotEmpty && selectedJobId.value != 'all')
              ? selectedJobId.value
              : null,
        ),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Something went wrong.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      debugPrint("Error starting chat: $e");
    }
  }

  Future<void> fetchPostedJobs() async {
    try {
      isJobsLoading.value = true;
      final result = await applicantService.getJobDropdownList();
      postedJobs.assignAll(result);
    } catch (e) {
      debugPrint("❌ Error fetching jobs for dropdown: $e");
    } finally {
      isJobsLoading.value = false;
    }
  }

  String get selectedJobDisplayName {
    if (selectedJobId.value == 'all' || selectedJobId.value.isEmpty) {
      return 'All Jobs'.tr; // 🟢 Added .tr
    }
    final job = postedJobs.firstWhere(
      (j) => j.jobId == selectedJobId.value,
      orElse: () => JobDropdownItemModel(
        jobId: '',
        displayName: 'Loading...'.tr, // 🟢 Added .tr
        status: '',
      ),
    );
    return job.displayName;
  }

  Future<void> refreshApplicants() async {
    currentPage.value = 1;
    hasMore.value = true;
    await fetchApplicants(isRefresh: true);
  }

  Future<void> loadMoreApplicants() async {
    if (isLoadMore.value || !hasMore.value) return;

    isLoadMore.value = true;
    currentPage.value++;
    await fetchApplicants(isRefresh: false);
    isLoadMore.value = false;
  }

  void changeSortOption(String newSort) {
    if (currentSort.value == newSort) return;
    currentSort.value = newSort;

    currentPage.value = 1;
    hasMore.value = true;
    fetchApplicants(isRefresh: true);
  }

  Future<void> fetchApplicants({bool isRefresh = true}) async {
    if (selectedJobId.value.isEmpty) return;

    try {
      if (isRefresh) {
        isLoading.value = true;
        currentPage.value = 1;
      }

      String activeStatus = tabs[tabController.index];

      final result = await applicantService.getJobApplicants(
        jobId: selectedJobId.value,
        status: activeStatus,
        searchKeyword: searchController.text,
        sortBy: currentSort.value,
        page: currentPage.value,
        limit: limit,
      );

      if (result.length < limit) {
        hasMore.value = false;
      } else {
        hasMore.value = true;
      }

      if (isRefresh) {
        applicants.assignAll(result);
      } else {
        applicants.addAll(result);
      }
    } catch (e) {
      debugPrint("❌ Error in Controller: $e");
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Failed to load candidates. Please try again.".tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
    } finally {
      if (isRefresh) isLoading.value = false;
    }
  }

  Future<void> fetchStatusSummary() async {
    if (selectedJobId.value.isEmpty) return;
    try {
      final result = await applicantService.getApplicantStatusSummary(
        selectedJobId.value,
      );
      if (result != null) {
        statusSummary.value = result;
      }
    } catch (e) {
      debugPrint("❌ Error in Controller fetching summary: $e");
    }
  }

  void toggleSelection(String applicationId) {
    if (selectedApplicantIds.isEmpty) {
      selectedApplicantIds.add(applicationId);
    } else {
      if (selectedApplicantIds.contains(applicationId)) {
        selectedApplicantIds.remove(applicationId);
      } else {
        final newApplicant = applicants.firstWhere(
          (app) => app.applicationId == applicationId,
        );
        final firstSelectedId = selectedApplicantIds.first;
        final firstApplicant = applicants.firstWhere(
          (app) => app.applicationId == firstSelectedId,
        );

        if (newApplicant.status != firstApplicant.status) {
          final isDark = Get.isDarkMode; // 🟢 Theme Check
          Get.snackbar(
            "Selection Error".tr, // 🟢 Added .tr
            "You can only select candidates with the same status at a time."
                .tr, // 🟢 Added .tr
            backgroundColor: isDark
                ? Colors.orangeAccent.withValues(alpha: 0.15)
                : Colors.orange.shade50,
            colorText: isDark ? Colors.orangeAccent : Colors.orange.shade900,
            snackPosition: SnackPosition.TOP,
            icon: Icon(
              Icons.warning_amber_rounded,
              color: isDark ? Colors.orangeAccent : Colors.orange.shade900,
            ),
          );
          return;
        }
        selectedApplicantIds.add(applicationId);
      }
    }
  }

  void selectAllCurrentTab() {
    final ids = applicants.map((app) => app.applicationId).toList();
    selectedApplicantIds.assignAll(ids);
  }

  void clearSelection() {
    selectedApplicantIds.clear();
  }

  void onSearchChanged(String query) {
    _debouncer.run(() {
      currentPage.value = 1;
      hasMore.value = true;
      fetchApplicants(isRefresh: true);
    });
  }

  void changeTab(String status) {
    clearSelection();
    hasMore.value = true;
    currentPage.value = 1;
    fetchApplicants(isRefresh: true);
  }

  Future<bool> bulkUpdateStatus(
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    if (selectedApplicantIds.isEmpty) return false;
    final isDark = Get.isDarkMode; // 🟢 Theme Check
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final success = await applicantService.bulkUpdateApplicationStatus(
        applicationIds: selectedApplicantIds.toList(),
        newStatus: newStatus,
        interviewSchedule: interviewSchedule,
        feedback: feedback,
      );
      Get.back();
      if (success) {
        applicants.removeWhere(
          (app) => selectedApplicantIds.contains(app.applicationId),
        );
        clearSelection();
        fetchStatusSummary();
        Get.snackbar(
          "Success".tr, // 🟢 Added .tr
          "Candidates have been updated successfully.".tr, // 🟢 Added .tr
          backgroundColor: isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : Colors.green.shade50,
          colorText: isDark ? Colors.greenAccent : Colors.green.shade700,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Could not process bulk action.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      return false;
    }
  }

  Future<bool> updateApplicantStatus(
    String applicationId,
    String newStatus, {
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final success = await applicantService.updateApplicationStatus(
        applicationId: applicationId,
        newStatus: newStatus,
        interviewSchedule: interviewSchedule,
        feedback: feedback,
      );
      Get.back();
      if (success) {
        final existingApplicantIndex = applicants.indexWhere(
          (app) => app.applicationId == applicationId,
        );
        if (existingApplicantIndex != -1) {
          final currentStatus = applicants[existingApplicantIndex].status
              .toLowerCase();
          if (currentStatus == newStatus.toLowerCase()) {
            fetchApplicants(isRefresh: true);
            Get.snackbar(
              "Success".tr, // 🟢 Added .tr
              "Interview schedule has been updated.".tr, // 🟢 Added .tr
              backgroundColor: isDark
                  ? AppColors.success.withValues(alpha: 0.15)
                  : Colors.green.shade50,
              colorText: isDark ? Colors.greenAccent : Colors.green.shade700,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              icon: Icon(
                Icons.check_circle_outline,
                color: isDark ? Colors.greenAccent : Colors.green.shade700,
              ),
            );
          } else {
            applicants.removeAt(existingApplicantIndex);
            fetchStatusSummary();
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Action Failed".tr, // 🟢 Added .tr
        "Could not update data. Please try again.".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      return false;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
