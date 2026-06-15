part of 'reset_pass_screen_view.dart';

class ResetPassScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    // Don't use fenix: true - we want the controller to be destroyed when leaving this screen
    Get.lazyPut(() => ResetPassScreenViewController(), fenix: false);
  }
}
