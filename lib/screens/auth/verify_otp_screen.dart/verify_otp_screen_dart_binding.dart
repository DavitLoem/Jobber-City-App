part of 'verify_otp_screen_dart_view.dart';

class VerifyOtpScreenDartViewBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: false ensures controller is destroyed when leaving this screen
    Get.lazyPut(() => VerifyOtpScreenDartViewController(), fenix: false);
  }
}
