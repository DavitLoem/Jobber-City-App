import 'package:get/get.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';

class LoginScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginScreenViewController(), fenix: false);
  }
}
