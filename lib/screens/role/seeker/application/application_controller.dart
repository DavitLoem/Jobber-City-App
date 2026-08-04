part of 'application_view.dart';

class ApplicationViewController extends GetxController {
  // 🎯 ហៅ Service ដែលយើងបានបង្កើត
  final SeekerApplicationService _service = SeekerApplicationService();

  // 🎯 គ្រប់គ្រងស្ថានភាពនៃការ Load និងទុកទិន្នន័យ
  var isLoading = true.obs;
  var applications = <MyApplicationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApplications();
  }

  // 🎯 អនុគមន៍ទាញយកទិន្នន័យពី Backend
  Future<void> fetchApplications() async {
    try {
      isLoading.value = true;
      final result = await _service
          .getMyApplications(); // អាចថែម page, limit បើចង់
      applications.assignAll(result);
    } catch (e) {
      debugPrint("❌ Error fetching my applications: $e");
      Get.snackbar(
        "Error",
        "Cannot load your applications. Please try again.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 🎯 មុខងារបំបែកទិន្នន័យតាម Tab (Filter)
  // ==========================================

  // សម្រាប់ Tab ទី១៖ Pending (រួមបញ្ចូល pending, reviewed, shortlisted)
  List<MyApplicationModel> get pendingApps => applications
      .where(
        (app) =>
            app.status.toLowerCase() == 'pending' ||
            app.status.toLowerCase() == 'reviewed' ||
            app.status.toLowerCase() == 'shortlisted',
      )
      .toList();

  // សម្រាប់ Tab ទី២៖ Interview
  List<MyApplicationModel> get interviewApps => applications
      .where((app) => app.status.toLowerCase() == 'interview')
      .toList();

  // សម្រាប់ Tab ទី៣៖ Closed (រួមបញ្ចូល rejected ឬ hired)
  List<MyApplicationModel> get closedApps => applications
      .where(
        (app) =>
            app.status.toLowerCase() == 'rejected' ||
            app.status.toLowerCase() == 'hired',
      )
      .toList();
}
