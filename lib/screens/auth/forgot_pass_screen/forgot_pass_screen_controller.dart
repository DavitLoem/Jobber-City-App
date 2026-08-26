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
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    try {
      isLoading.value = true;

      var response = await authServices.forgotPassword(email: email);

      String message =
          response["message"]?.toString().tr ??
          "Verification code has been sent to your email.".tr; // 🟢 Added .tr

      Get.snackbar(
        "Success".tr, // 🟢 Added .tr
        message,
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green.shade50, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.greenAccent
            : Colors.green.shade700, // 🟢 Dynamic Text
      );

      Get.toNamed(
        AppRoutes.verifyOtp,
        arguments: {'email': email, 'from': 'forgot_password'},
      );
    } on ApiException catch (e) {
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        e.message.tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.redAccent
            : Colors.red.shade700, // 🟢 Dynamic Text
      );
    } catch (e) {
      Get.snackbar(
        "Error".tr, // 🟢 Added .tr
        "Something wrong. Please check your connection".tr, // 🟢 Added .tr
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.redAccent
            : Colors.red.shade700, // 🟢 Dynamic Text
      );
    } finally {
      isLoading.value = false;
    }
  }
}
