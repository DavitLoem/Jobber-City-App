part of 'forgot_pass_screen_view.dart';

class ForgotPassScreenViewController extends GetxController {
  final AuthServices authServices = AuthServices();
  late final TextEditingController emailCtrl;

  final fromKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    emailCtrl = TextEditingController();
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }

  void forgotPassword() async {
    if (!fromKey.currentState!.validate()) {
      return;
    }

    String email = emailCtrl.text.trim();

    try {
      isLoading.value = true;

      var response = await authServices.forgotPassword(email: email);

      String message =
          response["message"] ??
          "Verification code has been sent to your email.";
      Get.snackbar(
        "Success",
        message,
        backgroundColor: AppColors.success, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );

      Get.toNamed(
        AppRoutes.verifyOtp,
        arguments: {'email': email, 'from': 'forgot_password'},
      );
    } on ApiException catch (e) {
      Get.snackbar(
        "Error",
        e.message,
        backgroundColor: AppColors.error, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something wrong. Please check your connection",
        backgroundColor: AppColors.error, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
