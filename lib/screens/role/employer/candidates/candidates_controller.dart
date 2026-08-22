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

  // 🟢 ១. អថេរថ្មីៗសម្រាប់ Pagination
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
    fetchApplicants(isRefresh: true); // 🟢 ចាប់ផ្តើមដោយ Refresh
    fetchStatusSummary();
  }

  Future<void> startChatWithSeeker(ApplicantModel applicant) async {
    // ត្រួតពិនិត្យថាមាន User ID ឬអត់
    if (applicant.seekerUserId.isEmpty) {
      Get.snackbar(
        "Error",
        "Cannot start chat. User ID is missing.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // បង្ហាញសញ្ញា Loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 🎯 ១. កែតម្រូវការហៅ API ឱ្យត្រូវនឹង ChatRestService ថ្មី
      // ប្រើ Parameter: otherUserId និងចាប់យក selectedJobId ពិតប្រាកដ
      final conversation = await _chatRestService.startConversation(
        otherUserId: applicant.seekerUserId,
        jobId: (selectedJobId.value.isNotEmpty && selectedJobId.value != 'all')
            ? selectedJobId.value
            : null,
      );

      // បិទ Loading វិញ
      Get.back();

      // 🎯 ២. ប្រើប្រាស់ ChatThreadArgs ដែលមានសុវត្ថិភាពខ្ពស់ ជំនួសការប្រើ Map
      Get.toNamed(
        AppRoutes
            .chatRoom, // (ចំណាំ: សូមប្រាកដថា Route នេះត្រូវគ្នានឹង AppRoutes របស់អ្នក)
        arguments: ChatThreadArgs(
          conversationId: conversation.id,
          otherPartyName: applicant.fullName,
          otherPartyAvatarUrl: applicant.profileImageUrl,
          otherPartyRole: 'seeker', // Employer កំពុងឆាតទៅ Seeker
          jobId:
              (selectedJobId.value.isNotEmpty && selectedJobId.value != 'all')
              ? selectedJobId.value
              : null,
        ),
      );
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Something went wrong.");
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
      return 'All Jobs';
    }
    final job = postedJobs.firstWhere(
      (j) => j.jobId == selectedJobId.value,
      orElse: () => JobDropdownItemModel(
        jobId: '',
        displayName: 'Loading...',
        status: '',
      ),
    );
    return job.displayName;
  }

  // 🟢 ២. មុខងារ Refresh (ទាញពីលើចុះក្រោម)
  Future<void> refreshApplicants() async {
    currentPage.value = 1;
    hasMore.value = true;
    await fetchApplicants(isRefresh: true);
  }

  // 🟢 ៣. មុខងារ Load More (អូសដល់ក្រោម)
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

    // បង្ខំឱ្យ Reset ទៅទំព័រទី 1 និងទាញទិន្នន័យថ្មី
    currentPage.value = 1;
    hasMore.value = true;
    fetchApplicants(isRefresh: true);
  }

  // 🟢 ៤. កែប្រែ fetchApplicants ដើម្បីគាំទ្រ Pagination
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

      // ឆែកថាតើអស់ទិន្នន័យឬនៅ
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
      Get.snackbar(
        "Error",
        "Failed to load candidates. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
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
          Get.snackbar(
            "Selection Error",
            "You can only select candidates with the same status at a time.",
            backgroundColor: Colors.orange.shade50,
            colorText: Colors.orange.shade900,
            snackPosition: SnackPosition.TOP,
            icon: Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade900,
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
      // 🟢 ពេល Search ត្រូវ Reset ទៅទំព័រទី 1 វិញ
      currentPage.value = 1;
      hasMore.value = true;
      fetchApplicants(isRefresh: true);
    });
  }

  void changeTab(String status) {
    clearSelection();
    // 🟢 ពេលដូរ Tab ត្រូវ Reset ទៅទំព័រទី 1 វិញ
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
          "Success",
          "Candidates have been updated successfully.",
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade700,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Could not process bulk action.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
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
            fetchApplicants(isRefresh: true); // 🟢 ទាញយកសាថ្មី ព្រោះវា Update
            Get.snackbar(
              "Success",
              "Interview schedule has been updated.",
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade700,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              icon: Icon(
                Icons.check_circle_outline,
                color: Colors.green.shade700,
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
        "Action Failed",
        "Could not update data. Please try again.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
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
