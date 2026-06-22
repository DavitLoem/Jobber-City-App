part of 'verify_otp_view.dart';

class VerifyOtpController extends GetxController {
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
        fromScreen = argsMap['from']?.toString() ?? '';
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

    //១. ពិនិត្យភាពត្រឹមត្រូវ (Validation) តាមរយៈ AuthValidator
    String? validationError = AuthValidator.validateOTP(otpCode: otp);
    if (validationError != null) {
      Get.snackbar('Error', validationError);
      return;
    }

    isLoading.value = true;

    try {
      // ផ្លូវទី ១៖ សម្រាប់អ្នកភ្លេចលេខសម្ងាត់ (Forgot Password Flow)
      if (fromScreen == 'forgot_password') {
        Get.toNamed(
          AppRoutes.resetPassword,
          arguments: {'email': userEmail, 'otp': otp},
        );
      }
      // ផ្លូវទី ២៖ សម្រាប់អ្នកចុះឈ្មោះគណនីថ្មី (Register Flow)
      else {
        final response = await _authServices.verifyOtp(
          email: userEmail,
          otp: otp,
        );

        // ក. រក្សាទុកសោ (Tokens) ចូលក្នុង Secure Storage
        await TokenStorage.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          role: response.user.role,
        );

        Get.snackbar('Success', 'Your account has been verified successfully!');

        if (response.user.role == 'employer') {
          Get.offAllNamed(AppRoutes.homeEmployer);
        } else {
          Get.offAllNamed(AppRoutes.homeSeeker);
        }
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      debugPrint("Verify OTP Crash Log: $e");
      Get.snackbar(
        'Error',
        'There is a system error. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() async {
    if (remainingSeconds.value > 0) return;

    try {
      isLoading.value = true;
      dynamic response;

      if (fromScreen == 'forgot_password') {
        response = await _authServices.forgotPassword(email: userEmail);
      } else {
        response = await _authServices.resendOtp(email: userEmail);
      }

      Get.snackbar(
        'Success',
        response["message"] ?? 'OTP has been resent to your email.',
      );

      startTimer();
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar(
        'Error',
        'There is a system error. Please check your internet connection.',
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
