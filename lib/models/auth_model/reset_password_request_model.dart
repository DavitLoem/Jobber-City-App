class ResetPasswordRequestModel {
  final String email;
  final String otpCode;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.email,
    required this.otpCode,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp_code": otpCode,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    };
  }
}
