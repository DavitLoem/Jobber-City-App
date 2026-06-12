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
    // ពិនិត្យលក្ខខណ្ឌថាតើបានយល់ព្រមតាម Terms ហើយឬនៅ
    bool hasAgreed = selectedIndex.value == 0
        ? agreeToTermsEmployer.value
        : agreeToTermsSeeker.value;
    if (!hasAgreed) {
      Get.snackbar("Warning", "Please agree to the Terms and Conditions");
      return;
    }

    if (firstNameCtrl.text.isEmpty ||
        lastNameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;
    try {
      var response = await authServices.register(
        firstName: firstNameCtrl.text,
        lastName: lastNameCtrl.text,
        email: emailCtrl.text,
        password: passwordCtrl.text,
        role: selectedIndex.value == 0 ? "employer" : "seeker",
      );

      // ✅ កែប្រែពី response.success មកជា response["success"] វិញ
      if (response != null && response["success"] == true) {
        Get.snackbar(
          "Success",
          response["message"] ?? "Account created successfully",
        );
        Get.offAllNamed(AppRoutes.verifyOtp, arguments: emailCtrl.text.trim());
      } else {
        // ✅ កែប្រែពី response.detail មកជា response["message"] ឬ "detail" ទៅតាម key របស់ Backend
        Get.snackbar(
          "Error",
          response["message"] ?? "Failed to create account",
        );
      }
    } catch (e) {
      if (e is DioException) {
        Get.snackbar(
          "Error",
          e.response?.data["detail"] ?? "Something went wrong",
        );
      } else {
        Get.snackbar("Error", "Something went wrong");
      }
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
