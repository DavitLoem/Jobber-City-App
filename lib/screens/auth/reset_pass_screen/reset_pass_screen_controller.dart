part of 'reset_pass_screen_view.dart';

class ResetPassScreenViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  late final TextEditingController newPasswordCtrl;
  late final TextEditingController confirmPasswordCtrl;

  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isObscureNew = true.obs;
  var isObscureConfirm = true.obs;

  String email = '';
  String otp = '';

  @override
  void onInit() {
    super.onInit();
    newPasswordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();

    if (Get.arguments != null && Get.arguments is Map) {
      email = Get.arguments['email'] ?? '';
      otp = Get.arguments['otp'] ?? '';
    }
  }

  void resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    String newPassword = newPasswordCtrl.text.trim();
    String confirmPassword = confirmPasswordCtrl.text.trim();

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Notice",
        "Passwords do not match.",
        backgroundColor: AppColors.warning, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      var response = await _authServices.resetPassword(
        ResetPasswordRequestModel(
          email: email,
          otpCode: otp,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );

      Get.snackbar(
        "Success",
        response["message"] ?? "Password reset successfully.",
        backgroundColor: AppColors.success, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );

      if (Get.isRegistered<LoginScreenViewController>()) {
        Get.find<LoginScreenViewController>().clearFields();
      }

      Get.until((route) => route.settings.name == AppRoutes.login);
    } on ApiException catch (e) {
      Get.snackbar(
        "Error",
        e.message,
        backgroundColor: AppColors.error, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
    } catch (e) {
      print("Reset Password Crash Log: $e");
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        backgroundColor: AppColors.error, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
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
