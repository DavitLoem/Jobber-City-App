part of 'verify_otp_screen_dart_view.dart';

class VerifyOtpScreenDartViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyOtpScreenDartViewController());
  }
}