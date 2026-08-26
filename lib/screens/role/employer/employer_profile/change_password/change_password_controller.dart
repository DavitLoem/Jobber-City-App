part of 'change_password_view.dart';

class ChangePasswordViewController extends GetxController {
  // 🟢 Added reactive state variables for password visibility
  var obscureCurrent = true.obs;
  var obscureNew = true.obs;
  var obscureConfirm = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // 🟢 Visibility toggle functions
  void toggleCurrent() => obscureCurrent.value = !obscureCurrent.value;
  void toggleNew() => obscureNew.value = !obscureNew.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;
}
