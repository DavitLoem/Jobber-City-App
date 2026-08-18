part of 'login_screen_view.dart';

class LoginScreenViewController extends GetxController {
  final AuthServices authServices = AuthServices();

  late TextEditingController emailCtrl;
  late TextEditingController passwordCtrl;

  final formKey = GlobalKey<FormState>();

  var rememberMe = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void clearFields() {
    emailCtrl.clear();
    passwordCtrl.clear();
  }

  void toggleRememberMe([bool? value]) {
    rememberMe.value = value ?? !rememberMe.value;
  }

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await authServices.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      await TokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        role: response.user.role,
        onboardingCompleted: response.user.onboardingCompleted,
        isProfileCompleted: response.user.isProfileCompleted,
      );

      await Get.find<AuthController>().checkLoginStatus();

      Get.snackbar(
        "Success",
        "Login Successfully",
        backgroundColor: AppColors.success, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );

      String userEmail = emailCtrl.text.trim();
      clearFields();

      final user = response.user;

      if (user.role == 'employer') {
        if (user.isProfileCompleted) {
          Get.offAllNamed(AppRoutes.mainScreenEmployer);
        } else {
          Get.offAllNamed(AppRoutes.companyProfile);
        }
      } else {
        if (user.onboardingCompleted) {
          Get.offAllNamed(AppRoutes.mainScreenSeeker);
        } else {
          Get.offAllNamed(AppRoutes.location, arguments: {'email': userEmail});
        }
      }
    } on ApiException catch (e) {
      Get.snackbar(
        "Error",
        e.message,
        backgroundColor: AppColors.error, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
    } catch (e, stacktrace) {
      debugPrint("❌ Login Runtime Crash Log: $e\n$stacktrace");
      Get.snackbar(
        "Error",
        "An unexpected error occurred",
        backgroundColor: AppColors.error, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void loginWithGoogle() {
    Get.find<AuthController>().loginWithGoogle();
  }
}
