part of 'reset_pass_screen_view.dart';

class ResetPassScreenViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  late final TextEditingController newPasswordCtrl;
  late final TextEditingController confirmPasswordCtrl;

  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isObscureNew = true.obs;
  var isObscureConfirm = true.obs;

  String email = '';
  String otp = '';

  @override
  @override
  void onInit() {
    super.onInit();
    newPasswordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();

    if (Get.arguments != null && Get.arguments is Map) {
      email = Get.arguments['email'] ?? '';
      otp = Get.arguments['otp'] ?? '';
    }
  }

  void resetPassword() async {
    // 🎯 ២. បញ្ជាឱ្យ Form ឆែកមើលប្រអប់ Password តាមរយៈ Validator
    if (!formKey.currentState!.validate()) {
      return;
    }

    String newPassword = newPasswordCtrl.text.trim();
    String confirmPassword = confirmPasswordCtrl.text.trim();

    // 🎯 ៣. ការឆែក Confirm Password អាចដាក់នៅទីនេះ ឬក្នុង AuthValidator ខាង UI ក៏បាន
    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Notice",
        "Passwords do not match.",
        backgroundColor: Colors.orangeAccent,
      );
      return;
    }

    try {
      isLoading.value = true;

      // ៤. បាញ់ API ដោយប្រើប្រាស់ Model ត្រឹមត្រូវ (ត្រូវប្រាកដថា Model របស់អ្នកមាន Parameter ត្រូវគ្នា)
      var response = await _authServices.resetPassword(
        ResetPasswordRequestModel(
          email: email,
          otpCode: otp, // ⚠️ បើ Backend ទាមទារឈ្មោះ key ខុសពីនេះ សូមកែនៅ Model
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );

      // ៥. បើឆ្លងកាត់ការបាញ់ API ខាងលើបានដោយមិនធ្លាក់ចូល catch គឺជោគជ័យ
      Get.snackbar(
        "Success",
        response["message"] ?? "Password reset successfully.",
      );

      // ៦. សម្អាត Email និង Password ចាស់ចោលពី LoginScreen មុននឹងថយក្រោយ
      if (Get.isRegistered<LoginScreenViewController>()) {
        Get.find<LoginScreenViewController>().clearFields();
      }

      // ៧. ថយក្រោយរហូតដល់ជួបផ្ទាំង Login (ល្អបំផុតដើម្បីការពារ Memory Leak)
      Get.until((route) => route.settings.name == AppRoutes.login);
    } on ApiException catch (e) {
      // 🎯 ៨. ចាប់យក Error ពិតប្រាកដពី Server មកបង្ហាញយ៉ាងស្អាត
      Get.snackbar("Error", e.message);
    } catch (e) {
      // ករណីគាំងទូទៅ (ឧ. ដាច់អ៊ីនធឺណិត)
      print("Reset Password Crash Log: $e");
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
