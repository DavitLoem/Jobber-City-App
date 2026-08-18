part of 'application_detail_view.dart';

class ApplicationDetailViewController extends GetxController {
  final SeekerApplicationService _service = SeekerApplicationService();

  var isLoading = true.obs;
  var applicationDetail = Rxn<MyApplicationDetailModel>();
  late String applicationId;

  @override
  void onInit() {
    super.onInit();
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
        "Error".tr, // 🟢 Added .tr
        "Could not load application details.".tr, // 🟢 Added .tr
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
