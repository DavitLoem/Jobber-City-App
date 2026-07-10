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

      // 🎯 ១. ទាញយក onboarding_completed ពី JSON (ដាក់ false បើរកមិនឃើញ)
      bool onboardingCompleted = false;
      if (dataMap["user"] != null &&
          dataMap["user"]["onboarding_completed"] != null) {
        onboardingCompleted = dataMap["user"]["onboarding_completed"];
      }

      String message = response["message"] ?? "Login Successfully";

      if (accessToken != null) {
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken ?? "",
          role: role ?? 'seeker',
          onboardingCompleted:
              onboardingCompleted, // 🎯 ២. រក្សាទុកក្នុង Storage
        );

        await Get.find<AuthController>().checkLoginStatus();
      }

      Get.snackbar("Success", message);

      String userEmail = emailCtrl.text.trim();
      clearFields();

      // 🎯 ៣. បំបែកផ្លូវ (Smart Routing)
      if (role == 'employer') {
        Get.offAllNamed(
          AppRoutes.mainScreenEmployer,
          arguments: {'email': userEmail},
        );
      } else {
        // សម្រាប់ Seeker ត្រូវឆែកលក្ខខណ្ឌ Onboarding
        if (onboardingCompleted == true) {
          Get.offAllNamed(
            AppRoutes.mainScreenSeeker,
          ); // បើបំពេញរួច ឱ្យចូល Main តែម្តង
        } else {
          Get.offAllNamed(
            AppRoutes.location, // បើមិនទាន់បំពេញ ទាត់ទៅ Location
            arguments: {'email': userEmail},
          );
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
