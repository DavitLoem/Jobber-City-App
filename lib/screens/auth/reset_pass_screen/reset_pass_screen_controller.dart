part of 'reset_pass_screen_view.dart';

class ResetPassScreenViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  var isLoading = false.obs;
  var isObscureNew = true.obs;
  var isObscureConfirm = true.obs;

  String email = '';
  String otp = '';

  @override
  void onInit() {
    super.onInit();
    // Get email and OTP passed from the previous screen
    if (Get.arguments != null && Get.arguments is Map) {
      email = Get.arguments['email'] ?? '';
      otp = Get.arguments['otp'] ?? '';
    }
  }

  void resetPassword() async {
    String newPassword = newPasswordCtrl.text.trim();
    String confirmPassword = confirmPasswordCtrl.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "Please fill all fields.");
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match.");
      return;
    }

    try {
      isLoading.value = true;

      var response = await _authServices.resetPassword(
        email: email,
        otp: otp,
        newpassword: newPassword,
        confirmpassword: confirmPassword,
      );

      if (response != null && response["success"] == true) {
        Get.snackbar(
          "Success",
          response["message"] ?? "Password reset successfully.",
        );

        // 🟢 ទី១៖ សម្អាត Email និង Password ចាស់ចោលពី LoginScreen
        if (Get.isRegistered<LoginScreenViewController>()) {
          Get.find<LoginScreenViewController>().clearFields();
        }

        // 🟢 ទី២៖ ប្រើ Get.until ដើម្បីថយក្រោយរហូតដល់ជួបផ្ទាំង Login ដែលមានស្រាប់
        // វិធីនេះមិនធ្វើឱ្យ LoginController ត្រូវ Dispose ខុសពេលទេ (លែង Crash 100%)
        Get.until((route) => route.settings.name == AppRoutes.login);
      } else {
        Get.snackbar(
          "Error",
          response["message"] ?? "Failed to reset password.",
        );
      }
    } catch (e) {
      print("Reset Password Error Log: $e");

      if (e is DioException) {
        String backendMessage =
            e.response?.data["message"] ??
            e.response?.data["detail"] ??
            "Server error occurred.";
        Get.snackbar("Error", backendMessage);
      } else {
        Get.snackbar("Error", "Something went wrong. Please try again.");
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
