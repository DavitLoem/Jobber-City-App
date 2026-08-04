import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/routes/route_guard.dart';
import 'package:jobber_city/screens/auth/create_acc_screen/create_acc_screen_view.dart';
import 'package:jobber_city/screens/auth/forgot_pass_screen/forgot_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_binding.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';
import 'package:jobber_city/screens/auth/reset_pass_screen/reset_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/verify_otp_screen/verify_otp_view.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/candidate_detail_view.dart';
import 'package:jobber_city/screens/role/employer/company_profile/company_profile_view.dart';
import 'package:jobber_city/screens/role/employer/employer_profile/company_detail/company_detail_view.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_binding.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_view.dart';
import 'package:jobber_city/screens/role/employer/my_job_detail/my_job_detail_view.dart';
import 'package:jobber_city/screens/role/employer/new_job/new_job_view.dart';
import 'package:jobber_city/screens/role/seeker/educations_screen/educations_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/experience_screen/experience_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/experience_screen/experience_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/category_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/job_detail/job_detail_view.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/location_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/cv_extraction/cv_extraction_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/save_job_screen/save_job_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/search_button/search_button_binding.dart';
import 'package:jobber_city/screens/role/seeker/search_button/search_button_view.dart';
import 'package:jobber_city/screens/role/seeker/setting_screen/setting_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/trainings_screen/trainings_screen_view.dart';
// Import Views & Bindings
import 'package:jobber_city/screens/splash/splash_view.dart';

import '../screens/role/employer/employer_profile/change_password/change_password_view.dart';
import '../screens/role/employer/employer_profile/edit_profile_employer/edit_profile_employer_view.dart';
import '../screens/role/employer/employer_profile/notification_employer/notification_employer_view.dart';

class AppRoles {
  static const String seeker = 'seeker';
  static const String employer = 'employer';
}

class AppPages {
  static final routes = [
    // ==========================================
    // 🟢 ១. PUBLIC ROUTES
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
      name: AppRoutes.search,
      page: () => SearchButtonView(),
      binding: SearchButtonViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.jobDetail,
      page: () => JobDetailView(),
      binding: JobDetailBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.saveJob,
      page: () => SaveJobScreenView(),
      binding: SaveJobScreenViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => SettingScreenView(),
      binding: SettingScreenViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.seeker),
      ],
    ),
    GetPage(
      name: AppRoutes.cvExtraction,
      page: () => CvExtractionView(),
      binding: CvExtractionViewBinding(),
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
      name: AppRoutes.newJob,
      page: () => NewJobView(),
      binding: NewJobViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.myJobDetail,
      page: () => MyJobDetailView(),
      binding: MyJobDetailViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.editProfileEmployer,
      page: () => EditProfileEmployerView(),
      binding: EditProfileEmployerViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.companyDetail,
      page: () => CompanyDetailView(),
      binding: CompanyDetailViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordView(),
      binding: ChangePasswordViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordView(),
      binding: ChangePasswordViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.notificationEmployer,
      page: () => NotificationEmployerView(),
      binding: NotificationEmployerViewBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requiredRole: AppRoles.employer),
      ],
    ),
    GetPage(
      name: AppRoutes.candidateDetail,
      page: () => CandidateDetailView(),
      binding: CandidateDetailViewBinding(),
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
