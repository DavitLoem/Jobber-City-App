part of 'application_view.dart';

class ApplicationViewController extends GetxController {
  final SeekerApplicationService _service = SeekerApplicationService();

  var isLoading = true.obs;
  var applications = <MyApplicationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    try {
      isLoading.value = true;
      final result = await _service.getMyApplications();
      applications.assignAll(result);
    } catch (e) {
      debugPrint("❌ Error fetching my applications: $e");
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Cannot load your applications. Please try again.".tr, // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 🎯 មុខងារបំបែកទិន្នន័យតាម Tab (Filter)
  // ==========================================

  List<MyApplicationModel> get pendingApps => applications
      .where(
        (app) =>
            app.status.toLowerCase() == 'pending' ||
            app.status.toLowerCase() == 'reviewed' ||
            app.status.toLowerCase() == 'shortlisted',
      )
      .toList();

  List<MyApplicationModel> get interviewApps => applications
      .where((app) => app.status.toLowerCase() == 'interview')
      .toList();

  List<MyApplicationModel> get closedApps => applications
      .where(
        (app) =>
            app.status.toLowerCase() == 'rejected' ||
            app.status.toLowerCase() == 'hired',
      )
      .toList();
}
