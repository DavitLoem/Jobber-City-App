part of 'application_detail_view.dart';

class ApplicationDetailViewController extends GetxController {
final SeekerApplicationService _service = SeekerApplicationService();

  var isLoading = true.obs;
  var applicationDetail = Rxn<MyApplicationDetailModel>();
  late String applicationId;

  @override
  void onInit() {
    super.onInit();
    // ទទួលយក ID ពីទំព័រមុនពេលចុចលើកាត (Get.toNamed(..., arguments: app.applicationId))
    applicationId = Get.arguments as String;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      final result = await _service.getApplicationDetail(applicationId);
      applicationDetail.value = result;
    } catch (e) {
      debugPrint("Error fetching application detail: $e");
      Get.snackbar(
        "Error",
        "Could not load application details.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
    }
  }
}