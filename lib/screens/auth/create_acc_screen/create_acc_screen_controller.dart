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
    String firstName = firstNameCtrl.text.trim();
    String lastName = lastNameCtrl.text.trim();
    String email = emailCtrl.text.trim();
    String password = passwordCtrl.text;
    bool hasAgreed = selectedIndex.value == 0
        ? agreeToTermsSeeker.value
        : agreeToTermsEmployer.value;

    String? validationError = AuthValidator.validateRegister(
      hasAgreedTerms: hasAgreed,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    if (validationError != null) {
      Get.snackbar("Validation Error", validationError);
      return;
    }
    isLoading.value = true;

    UserRole selectedRoleEnum = selectedIndex.value == 0
        ? UserRole.seeker
        : UserRole.employer;

    try {
      final requestModel = RegisterRequestModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        role: selectedRoleEnum,
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
