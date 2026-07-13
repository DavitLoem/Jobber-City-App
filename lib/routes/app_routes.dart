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
  static const String mainScreenSeeker = '/main-screen';
  static const String homeSeeker = '/home-seeker';
  static const String editprofile = '/edit-profile';
  static const String expertise = '/expertise';
  static const String location = '/location';
  static const String jobDetail = '/job-detail';

  // ==========================================
  // 🟠 ៣. EMPLOYER ROUTES
  // ==========================================
  static const String homeEmployer = '/home-employer';
  static const String companyProfile = '/company-profile';
  static const String mainScreenEmployer = '/main-screen-employer';
  static const String myJob = '/my-job';
  static const String candidates = '/candidates';
  static const String employerProfile = '/employer-profile';
  static const String employerEditprofile = '/edit-profile';
  static const String experience = '/experience';
  static const String educations = '/educations';
  static const String trainings = '/trainings';

  // Employer routes
<<<<<<< HEAD
=======
  static const String mainScreenEmployer = '/main-screen-employer';
  static const String postJob = '/post-job';
  static const String recruit = '/recruit';
  static const String detailPost = '/recruit/detail';
>>>>>>> origin/profile_new
}
