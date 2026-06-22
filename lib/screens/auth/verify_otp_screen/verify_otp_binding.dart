part of 'verify_otp_view.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: false ensures controller is destroyed when leaving this screen
    Get.lazyPut(() => VerifyOtpController(), fenix: false);
  }
}
