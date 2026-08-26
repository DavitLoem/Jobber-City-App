part of 'detail_post_screen_view.dart';

class DetailPostScreenViewController extends GetxController {
  var job = Rxn<EmployerJobModel>();

  var provinceName = ''.obs;
  var districtName = ''.obs;
  var categoryName = ''.obs;
  var jobLevelName = ''.obs;
  var workTypeName = ''.obs;
  var employmentTypeName = ''.obs;
  var educationLevelName = ''.obs;

  var skillNames = <String>[].obs;

  final LocationServices _locationServices = LocationServices();
  final MasterDataController _masterDataServices =
      Get.find<MasterDataController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args is EmployerJobModel) {
      job.value = args;
    } else if (args is Map<String, dynamic>) {
      job.value = EmployerJobModel.fromJson(args);
    }
  }
}
