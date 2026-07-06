import 'package:get/get.dart';
import 'edit_profile_screen_controller.dart';

class EditProfileScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileScreenViewController());
  }
}
