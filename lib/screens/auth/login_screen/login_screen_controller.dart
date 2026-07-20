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
    // Clear the fields but avoid disposing the controllers here because
    // the framework or other async callbacks may still access them during
    // navigation. Disposing here can lead to "used after being disposed"
    // errors. Let the framework clean up the controllers when appropriate.
    emailCtrl.clear();
    passwordCtrl.clear();
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

      Get.snackbar("Success", "Login Successfully");

      String userEmail = emailCtrl.text.trim();
      clearFields();

      // Use the data from the response model for navigation
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
      Get.snackbar("Error", e.message);
    } catch (e, stacktrace) {
      debugPrint("❌ Login Runtime Crash Log: $e\n$stacktrace");
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void loginWithGoogle() {
    // 🎯 មិនបោះ Role ទេ ព្រោះយើងចង់ Login សុទ្ធ
    Get.find<AuthController>().loginWithGoogle();
  }
}
