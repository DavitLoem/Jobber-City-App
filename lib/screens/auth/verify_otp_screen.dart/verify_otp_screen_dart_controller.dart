part of 'verify_otp_screen_dart_view.dart';

class VerifyOtpScreenDartViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  var isLoading = false.obs;
  String userEmail = '';
  String maskedEmail = '';

  // សម្រាប់គ្រប់គ្រងការរាប់ថយក្រោយ (៣០ វិនាទី)
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
    // ចាប់យកអ៊ីមែលពី arguments ដែលបញ្ជូនមកពីផ្ទាំងមុន
    if (Get.arguments != null && Get.arguments is String) {
      userEmail = Get.arguments;
      maskedEmail = _maskEmail(userEmail);
    }

    // ចាប់ផ្តើមរាប់ថយក្រោយភ្លាមៗនៅពេលបើកអេក្រង់នេះ
    startTimer();
  }

  // មុខងារលាក់ខ្ទង់អ៊ីមែល (e.g., sample.user@gmail.com -> sa***@gmail.com)
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

  // មុខងាររាប់ថយក្រោយពេលផ្ញើ OTP
  void startTimer() {
    remainingSeconds.value = 30; // រាប់ថយក្រោយពី ៣០ វិនាទី
    _timer?.cancel(); // បញ្ឈប់ timer ចាស់ (បើមាន)
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  // ប្រមូលផ្តុំលេខកូដពីប្រឡោះទាំង ៤ មកជា String តែមួយ
  String get completeOtp => controllers.map((c) => c.text).join();

  // មុខងារផ្ទៀងផ្ទាត់ OTP ជាមួយ Backend API
  void verifyOtp() async {
    String otp = completeOtp;

    if (otp.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter a complete 4-digit code',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      var response = await _authServices.verifyOtp(email: userEmail, otp: otp);

      if (response != null && response["success"] == true) {
        Get.snackbar(
          'Success',
          response["message"] ?? 'OTP Verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Error',
          response["message"] ?? 'Invalid OTP code. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Verify OTP Crash Log: $e");
      Get.snackbar(
        'Error',
        'Something went wrong. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ មុខងារផ្ញើលេខកូដ OTP ម្តងទៀត (ដោះស្រាយកំហុស undefined_method)
  void resendOtp() async {
    // បើកំពុងរាប់ថយក្រោយ មិនអនុញ្ញាតឱ្យចុចផ្ញើឡើងវិញឡើយ
    if (remainingSeconds.value > 0) return;

    try {
      isLoading.value = true;
      var response = await _authServices.resendOtp(email: userEmail);

      if (response != null && response["success"] == true) {
        Get.snackbar(
          'Success',
          response["message"] ?? 'OTP has been resent to your email.',
          snackPosition: SnackPosition.BOTTOM,
        );
        // បើផ្ញើជោគជ័យ ចាប់ផ្តើមរាប់ថយក្រោយសារជាថ្មី
        startTimer();
      } else {
        Get.snackbar(
          'Error',
          response["message"] ?? 'Failed to resend OTP.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Resend OTP Crash Log: $e");
      Get.snackbar(
        'Error',
        'Something went wrong. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // បិទ Timer ពេលចាកចេញពីអេក្រង់ដើម្បីការពារ Memory Leak
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
