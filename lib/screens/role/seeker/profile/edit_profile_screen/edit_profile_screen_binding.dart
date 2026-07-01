import 'package:get/get.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';

class EditProfileScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileScreenViewController());
  }
}
