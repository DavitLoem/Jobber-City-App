part of 'forgot_pass_screen_view.dart';

class ForgotPassScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPassScreenViewController());
  }
}