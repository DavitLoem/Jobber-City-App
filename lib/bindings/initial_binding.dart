import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/chat/chat_rest_service.dart';
import 'package:jobber_city/core/api/services/chat/chat_ws_service.dart';

import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
// import '../controllers/theme_controller.dart'; // ឧទាហរណ៍សម្រាប់ថ្ងៃមុខ

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);

    Get.put(CategoryController(), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(MasterDataController(), permanent: true);

    Get.put(NotificationController(), permanent: true);

    Get.put(ChatRestService(), permanent: true);
    Get.put(ChatWsService(), permanent: true);
  }
}
