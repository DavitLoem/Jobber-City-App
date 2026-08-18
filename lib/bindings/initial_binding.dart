import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';

import '../controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);

    Get.put(CategoryController(), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(MasterDataController(), permanent: true);
  }
}
