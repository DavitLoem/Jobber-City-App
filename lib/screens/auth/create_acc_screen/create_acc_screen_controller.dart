part of 'create_acc_screen_view.dart';

class CreateAccScreenViewController extends GetxController {
  final AuthServices authServices = AuthServices();
  final _storage = const FlutterSecureStorage();

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

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

    if (!formKey.currentState!.validate()) {
      return;
    }

    bool hasAgreed = selectedIndex.value == 0
        ? agreeToTermsSeeker.value
        : agreeToTermsEmployer.value;

    if (!hasAgreed) {
      Get.snackbar(
        "Notice",
        "Please agree to the Terms and Conditions",
        backgroundColor: AppColors.warning, // 🟢 Updated to AppColors
        colorText: Colors.white,
      );
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

      await authServices.register(requestModel);

      // Store user data in FlutterSecureStorage for later use
      await _storage.write(key: 'temp_firstName', value: firstName);
      await _storage.write(key: 'temp_lastName', value: lastName);
      await _storage.write(key: 'temp_email', value: email);

      Get.toNamed(
        AppRoutes.verifyOtp,
        arguments: {
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
        },
      );
    } on ApiException catch (e) {
      Get.snackbar("Error", e.message);
    } catch (e, stackTrace) {
      AppLogger.e("Register Failed (System)", e, stackTrace);
      Get.snackbar("Error", "An unexpected error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void registerWithGoogle() {
    String selectedRole = selectedIndex.value == 0 ? 'seeker' : 'employer';
    // 🎯 បោះ Role ទៅ ដើម្បីប្រាប់ថាចង់ Register ជាអ្វី
    Get.find<AuthController>().loginWithGoogle(role: selectedRole);
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
