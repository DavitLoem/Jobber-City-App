part of 'forgot_pass_screen_view.dart';

class ForgotPassScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: false ensures controller is destroyed when leaving this screen
    Get.lazyPut(() => ForgotPassScreenViewController(), fenix: false);
  }
}
