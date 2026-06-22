import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
// import '../controllers/theme_controller.dart'; // ឧទាហរណ៍សម្រាប់ថ្ងៃមុខ

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
