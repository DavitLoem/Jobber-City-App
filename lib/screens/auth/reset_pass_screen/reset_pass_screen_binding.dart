part of 'reset_pass_screen_view.dart';

class ResetPassScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPassScreenViewController());
  }
}