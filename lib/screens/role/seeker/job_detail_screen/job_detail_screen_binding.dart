import 'package:get/get.dart';
import 'job_detail_screen_controller.dart'; // 🟢 Import Controller ចូលទីនេះ

class JobDetailScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobDetailScreenViewController());
  }
}
