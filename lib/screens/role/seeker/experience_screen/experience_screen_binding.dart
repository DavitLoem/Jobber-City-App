import 'package:get/get.dart';
import 'package:jobber_city/screens/role/seeker/experience_screen/experience_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/experience_screen/experience_screen_view.dart';

class ExperienceScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.delete<ExperienceScreenViewController>();
    Get.put(ExperienceScreenViewController());
  }
}
