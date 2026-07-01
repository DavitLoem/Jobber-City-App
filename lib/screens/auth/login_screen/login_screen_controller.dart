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
    emailCtrl = TextEditingController(text: "slesrofath2203@gmail.com");
    passwordCtrl = TextEditingController(text: "Rofath123");
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
      String? role = dataMap["user"] != null
          ? dataMap["user"]["role"]
          : dataMap["role"];
      String message = response["message"] ?? "Login Successfully";

      if (accessToken != null) {
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken ?? "",
          role: role ?? 'seeker',
        );

        await Get.find<AuthController>().checkLoginStatus();
      }

      Get.snackbar("Success", message);
      clearFields();

      if (role == 'employer') {
        Get.offAllNamed(AppRoutes.homeEmployer);
      } else {
        Get.offAllNamed(AppRoutes.homeSeeker);
      }
    } on ApiException catch (e) {
      Get.snackbar("Error", e.message);
    } catch (e, stacktrace) {
      debugPrint("❌ Login Runtime Crash Log: $e");
      debugPrint("❌ Stacktrace: $stacktrace");

      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
