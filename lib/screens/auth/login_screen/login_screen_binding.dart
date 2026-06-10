import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';

class LoginScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginScreenViewController());
  }
}