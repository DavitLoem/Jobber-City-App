import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/routes/route_guard.dart';
import 'package:jobber_city/screens/auth/create_acc_screen/create_acc_screen_view.dart';
import 'package:jobber_city/screens/auth/forgot_pass_screen/forgot_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_binding.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';
import 'package:jobber_city/screens/auth/reset_pass_screen/reset_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/verify_otp_screen/verify_otp_view.dart';
import 'package:jobber_city/screens/role/employer/company_profile/company_profile_view.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_binding.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_view.dart';
import 'package:jobber_city/screens/role/seeker/educations_screen/educations_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/experience_screen/experience_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/experience_screen/experience_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/category_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/job_detail/job_detail_view.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/location_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/trainings_screen/trainings_screen_view.dart';
// Import Views & Bindings
import 'package:jobber_city/screens/splash/splash_view.dart';

class AppRoles {
  static const String seeker = 'seeker';
  static const String employer = 'employer';
}

class AppPages {
  static final routes = [
    // ==========================================
    // 🟢 ១. PUBLIC ROUTES (មិនត្រូវការ Login)
    // ==========================================
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: SplashViewBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreenView(),
      binding: LoginScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.createAccount,
      page: () => CreateAccScreenView(),
      binding: CreateAccScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => VerifyOtpView(),
      binding: VerifyOtpBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPassScreenView(),
      binding: ForgotPassScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPassScreenView(),
      binding: ResetPassScreenViewBinding(),
    ),

    // ==========================================
    // 🔵 ២. SEEKER ROUTES (ត្រូវការ Login ជា Seeker)
    // ==========================================
    GetPage(
      name: AppRoutes.mainScreenSeeker,
      page: () => MainScreenView(),
      binding: MainScreenBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.expertise,
      page: () => CategoryScreenView(),
      binding: CategoryScreenViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.location,
      page: () => LocationScreenView(),
      binding: LocationScreenViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.editprofile,
      page: () => EditProfileScreenView(),
      binding: EditProfileScreenViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.jobDetail,
      page: () => JobDetailView(),
      binding: JobDetailViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),

    // ==========================================
    // 🟠 ៣. EMPLOYER ROUTES
    // ==========================================
    GetPage(
      name: AppRoutes.mainScreenEmployer,
      page: () => MainScreenEmloyerView(),
      binding: MainScreenEmloyerBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.companyProfile,
      page: () => CompanyProfileView(),
      binding: CompanyProfileViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.experience,
      page: () => ExperienceScreenView(),
      binding: ExperienceScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.educations,
      page: () => EducationsScreenView(),
      binding: EducationsScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.trainings,
      page: () => TrainingsScreenView(),
      binding: TrainingsScreenViewBinding(),
    ),

    // Employer routes
  ];
}
