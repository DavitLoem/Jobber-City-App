import 'package:get/get.dart';

class AuthValidator {
  /// ១. Validation សម្រាប់ Register
  static String? validateRegister({
    required bool hasAgreedTerms,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    if (!hasAgreedTerms) {
      return "Please agree to the Terms and Conditions";
    }
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      return "Please fill all fields";
    }
    if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email address";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  /// ២. Validation សម្រាប់ Login
  static String? validateLogin({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || password.isEmpty) {
      return "Please enter both email and password";
    }
    if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  /// ៣. Validation សម្រាប់ Verify OTP (និង Resend OTP)
  static String? validateOtp({
    required String otpCode,
    int requiredLength =
        6, // ឧបមាថា OTP មាន ៦ ខ្ទង់ (អាចប្តូរតាម Backend ជាក់ស្តែង)
  }) {
    if (otpCode.isEmpty) {
      return "Please enter the OTP code";
    }
    if (otpCode.length != requiredLength) {
      return "OTP must be exactly $requiredLength digits";
    }
    if (!GetUtils.isNumericOnly(otpCode)) {
      return "OTP can only contain numbers";
    }
    return null;
  }

  /// ៤. Validation សម្រាប់ Forgot Password (ទាមទារតែ Email)
  static String? validateForgotPassword({required String email}) {
    if (email.isEmpty) {
      return "Please enter your email address";
    }
    if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  /// ៥. Validation សម្រាប់ Reset Password (ដាក់លេខសម្ងាត់ថ្មី ក្រោយពេលភ្លេច)
  static String? validateResetPassword({
    required String newPassword,
    required String confirmPassword,
  }) {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      return "Please fill both password fields";
    }
    if (newPassword.length < 8) {
      return "New password must be at least 8 characters long";
    }
    if (newPassword != confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  /// ៦. Validation សម្រាប់ Change Password (ប្តូរលេខសម្ងាត់ពេលកំពុង Login រួច)
  static String? validateChangePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    if (oldPassword.isEmpty) {
      return "Please enter your current password";
    }
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      return "Please fill both new password fields";
    }
    if (newPassword.length < 8) {
      return "New password must be at least 8 characters long";
    }
    if (oldPassword == newPassword) {
      return "New password cannot be the same as the old password";
    }
    if (newPassword != confirmPassword) {
      return "New passwords do not match";
    }
    return null;
  }
}
