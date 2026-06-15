part of 'verify_otp_screen_dart_view.dart';

class VerifyOtpScreenDartViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  var isLoading = false.obs;
  String userEmail = '';
  String maskedEmail = '';
  String fromScreen = ''; // 🟢 Track where the navigation came from

  // Countdown timer setup
  var remainingSeconds = 30.obs;
  Timer? _timer;

  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments is String) {
        userEmail = Get.arguments as String;
      } else if (Get.arguments is Map) {
        final Map argsMap = Get.arguments as Map;
        userEmail = argsMap['email']?.toString() ?? '';
        fromScreen =
            argsMap['from']?.toString() ?? ''; // 🟢 Extract the 'from' argument
      }

      if (userEmail.isNotEmpty) {
        maskedEmail = _maskEmail(userEmail);
      }
    }

    startTimer();
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    String username = parts[0];
    String domain = parts[1];

    if (username.length <= 2) {
      return "${username.substring(0, 1)}***@$domain";
    } else {
      return "${username.substring(0, 2)}***@$domain";
    }
  }

  void startTimer() {
    remainingSeconds.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  String get completeOtp => controllers.map((c) => c.text).join();

  void verifyOtp() async {
    String otp = completeOtp;

    if (otp.length != 4) {
      Get.snackbar('Error', 'Please enter a complete 4-digit code');
      return;
    }

    try {
      isLoading.value = true;

      // 🟢 Check if the user came from the forgot password screen
      if (fromScreen == 'forgot_password') {
        // Skip the registration OTP API check. Take them straight to your Reset Password Screen
        // and pass both the email and the entered OTP so it can be submitted with the new password.
        // This controller will be automatically cleaned up when navigating away
        Get.toNamed(
          AppRoutes.resetPassword,
          arguments: {'email': userEmail, 'otp': otp},
        );
      } else {
        // 🔵 Account Creation Flow (Normal behavior)
        var response = await _authServices.verifyOtp(
          email: userEmail,
          otp: otp,
        );

        if (response != null && response["success"] == true) {
          Get.snackbar(
            'Success',
            response["message"] ?? 'OTP Verified successfully!',
          );
          // Clean navigation to home - login binding with fenix: true handles recreation if needed
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.snackbar(
            'Error',
            response["message"] ?? 'Invalid OTP code. Please try again.',
          );
        }
      }
    } catch (e) {
      print("Verify OTP Crash Log: $e");

      // 🟢 Better Error Handling: Show exact error from backend instead of hiding it
      if (e is DioException) {
        String backendMessage =
            e.response?.data["message"] ??
            e.response?.data["detail"] ??
            'Server returned an error.';
        Get.snackbar('Error', backendMessage);
      } else {
        Get.snackbar(
          'Error',
          'Something went wrong. Please check your connection.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() async {
    if (remainingSeconds.value > 0) return;

    try {
      isLoading.value = true;
      var response = await _authServices.resendOtp(email: userEmail);

      if (response != null && response["success"] == true) {
        Get.snackbar(
          'Success',
          response["message"] ?? 'OTP has been resent to your email.',
        );
        startTimer();
      } else {
        Get.snackbar('Error', response["message"] ?? 'Failed to resend OTP.');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please check your connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
