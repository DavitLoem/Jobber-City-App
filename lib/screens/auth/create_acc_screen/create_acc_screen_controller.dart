part of 'create_acc_screen_view.dart';

class CreateAccScreenViewController extends GetxController {
  final AuthServices authServices = AuthServices();

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  var isLoading = false.obs;
  var selectedIndex = 0.obs;
  var agreeToTermsEmployer = false.obs;
  var agreeToTermsSeeker = false.obs;

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void register() async {
    bool hasAgreed = selectedIndex.value == 0
        ? agreeToTermsEmployer.value
        : agreeToTermsSeeker.value;

    if (!hasAgreed) {
      Get.snackbar("Warning", "Please agree to the Terms and Conditions");
      return;
    }

    if (firstNameCtrl.text.trim().isEmpty ||
        lastNameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passwordCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    try {
      final requestModel = RegisterRequestModel(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
        role: selectedIndex.value == 0 ? "employer" : "seeker",
      );

      final response = await authServices.register(requestModel);

      AppLogger.i("Register Success: $response");

      Get.toNamed(AppRoutes.verifyOtp, arguments: emailCtrl.text.trim());
    } on ApiException catch (e) {
      AppLogger.w("Register Failed (API): ${e.message}");
      Get.snackbar("Error", e.message);
    } catch (e, stackTrace) {
      AppLogger.e("Register Failed (System)", e, stackTrace);
      Get.snackbar("Error", "An unexpected error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void toggleTermsEmployer() {
    agreeToTermsEmployer.value = !agreeToTermsEmployer.value;
  }

  void toggleTermsSeeker() {
    agreeToTermsSeeker.value = !agreeToTermsSeeker.value;
  }
}
