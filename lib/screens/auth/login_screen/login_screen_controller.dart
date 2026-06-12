part of 'login_screen_view.dart';

class LoginScreenViewController extends GetxController {
  final RxBool rememberMe = false.obs;
  final AuthServices authServices = AuthServices();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  var isLoading = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      var response = await authServices.login(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      if (response.success) {
        Get.snackbar('Success', response.message ?? 'Login successful');
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar('Error', response.detail ?? 'Failed to login');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
}
