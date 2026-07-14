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
      var response = await authServices.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      var dataMap = response["data"] ?? response;

      String? accessToken = dataMap["access_token"];
      String? refreshToken = dataMap["refresh_token"];

      // 🎯 ទាញយក Role ពី JSON
      String? role = dataMap["user"] != null
          ? dataMap["user"]["role"]
          : dataMap["role"];

      bool onboardingCompleted = false;
      if (dataMap["user"] != null &&
          dataMap["user"]["onboarding_completed"] != null) {
        onboardingCompleted = dataMap["user"]["onboarding_completed"];
      }

      bool isProfileCompleted = false;
      if (dataMap["user"] != null &&
          dataMap["user"]["is_profile_completed"] != null) {
        isProfileCompleted = dataMap["user"]["is_profile_completed"];
      }

      String message = response["message"] ?? "Login Successfully";

      if (accessToken != null) {
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken ?? "",
          role: role ?? 'seeker',
          onboardingCompleted: onboardingCompleted,
          isProfileCompleted: isProfileCompleted,
        );

        await Get.find<AuthController>().checkLoginStatus();
      }

      Get.snackbar("Success", message);

      String userEmail = emailCtrl.text.trim();
      clearFields();

      if (role == 'employer') {
        if (isProfileCompleted == true) {
          Get.offAllNamed(AppRoutes.mainScreenEmployer);
        } else {
          Get.offAllNamed(AppRoutes.companyProfile);
        }
      } else {
        if (onboardingCompleted == true) {
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
}
