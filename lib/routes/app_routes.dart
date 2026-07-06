class AppRoutes {
  // ==========================================
  // 🟢 ១. CORE & PUBLIC ROUTES (ទំព័រទូទៅ និងការចុះឈ្មោះ)
  // ==========================================
  static const String splash = '/splash';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';

  // ==========================================
  // 🔵 ២. SEEKER ROUTES (សម្រាប់អ្នកស្វែងរកការងារ)
  // ==========================================
  static const String mainScreen = '/main-screen';
  static const String homeSeeker = '/home-seeker';
  static const String editprofile = '/edit-profile';
  static const String category = '/category';
  static const String location = '/location';

  // ==========================================
  // 🟠 ៣. EMPLOYER ROUTES (សម្រាប់ថៅកែ ឬក្រុមហ៊ុន)
  // ==========================================
  static const String homeEmployer = '/home-employer';
  static const String companyProfile = '/company-profile';
}
