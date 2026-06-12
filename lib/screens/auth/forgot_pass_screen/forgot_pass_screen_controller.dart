part of 'forgot_pass_screen_view.dart';

class ForgotPassScreenViewController extends GetxController {
  final AuthServices authServices = AuthServices();
  final emailCtrl = TextEditingController();

  var isLoading = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }

  void forgotPassword() async {
    String email = emailCtrl.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email Address.");
      return;
    }
    try {
      isLoading.value = true;
      var response = await authServices.forgotPassword(email: email);

      if (response != null && response["success"] == true) {
        Get.snackbar(
          "Success",
          response["message"] ??
              "Verification code has been sent to your email.",
        );
        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: {'email': email, 'from': 'forgot_password'},
        );
      } else {
        Get.snackbar(
          "Error",
          response["message"] ??
              "Failed to send verification code. Please try again",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something wrong. Please check your connection");
    } finally {
      isLoading.value = false;
    }
  }
}
