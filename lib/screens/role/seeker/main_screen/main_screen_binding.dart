import 'package:get/get.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_controller.dart';

// 🟢 ១. ត្រូវ Import ហ្វាល់ View (ព្រោះ Controller របស់អ្នកស្ថិតក្នុងហ្វាល់ View ជាទម្រង់ part of)
import 'package:jobber_city/screens/role/seeker/home_seeker/home_seeker_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    // សម្រាប់ Bottom Bar (Main)
    Get.lazyPut(() => MainScreenController());

    // សម្រាប់ Tab ទី១ (Home)
    Get.lazyPut(() => HomeSeekerViewController());

    // 🟢 ២. សម្រាប់ Tab ទី៤ (Profile)
    Get.lazyPut(() => ProfileScreenViewController());
  }
}
