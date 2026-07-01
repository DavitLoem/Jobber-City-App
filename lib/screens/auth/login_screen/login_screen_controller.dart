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

  // Clear input fields manually
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
      // 2. Call Auth API Service
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
      }

      Get.snackbar("Success", message);

      // 🟢 ត្រូវប្រាកដថាអ្នកមានបន្ទាត់នេះ! (វាជាអ្នកបង្កើតអថេរ userEmail)
      String userEmail = emailCtrl.text.trim();

      // បន្ទាប់ពីចាប់ Email ទុកហើយ ទើបយើងលុបវាចេញពីប្រអប់
      clearFields();

      // 🟢 បំបែកផ្លូវ
      if (role == 'employer') {
        Get.offAllNamed(
          AppRoutes.companyProfile,
          arguments: {'email': userEmail}, // ប្រើអថេរដែលទើបបង្កើត
        );
      } else {
        Get.offAllNamed(
          AppRoutes.location,
          arguments: {'email': userEmail},
        ); // ប្រើអថេរដែលទើបបង្កើត
      }
    } on ApiException catch (e) {
      Get.snackbar("Error", e.message);
    } catch (e, stacktrace) {
      debugPrint("❌ Login Runtime Crash Log: $e\n$stacktrace");
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }
}
