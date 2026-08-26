part of 'interview_list_view.dart';

class InterviewListViewController extends GetxController {
  final InterviewService _interviewService = InterviewService();

  final interviews = <InterviewModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final filter = _InterviewFilter.upcoming.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInterviews();
  }

  void setFilter(_InterviewFilter value) => filter.value = value;

  List<InterviewModel> get visibleInterviews {
    if (filter.value == _InterviewFilter.upcoming) {
      final list = interviews.where((i) => i.isUpcoming).toList();
      list.sort(
        (a, b) => a.scheduledAt.compareTo(b.scheduledAt),
      ); // soonest first
      return list;
    }
    final list = interviews.where((i) => !i.isUpcoming).toList();
    list.sort(
      (a, b) => b.scheduledAt.compareTo(a.scheduledAt),
    ); // most recent first
    return list;
  }

  Future<void> fetchInterviews() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _interviewService.listInterviews(
        status: 'all',
        limit: 50,
      );
      interviews.assignAll(result);
    } catch (e) {
      errorMessage.value =
          'Could not load your interviews. Pull down to try again.'
              .tr; // 🟢 Added .tr
      debugPrint('[InterviewList] fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openInterview(InterviewModel interview) async {
    await Get.toNamed(AppRoutes.interviewDetail, arguments: interview);
    fetchInterviews();
  }
}
