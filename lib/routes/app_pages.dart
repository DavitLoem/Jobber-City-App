import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/auth/create_acc_screen/create_acc_screen_view.dart';
import 'package:jobber_city/screens/auth/forgot_pass_screen/forgot_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_binding.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';
import 'package:jobber_city/screens/auth/reset_pass_screen/reset_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/verify_otp_screen/verify_otp_view.dart';
import 'package:jobber_city/screens/role/seeker/category_screen/category_screen_view.dart';
import 'package:jobber_city/screens/role/employer/company_profile/company_profile_view.dart';
import 'package:jobber_city/screens/role/employer/home_employer/home_employer_view.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/location_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/home_seeker/home_seeker_view.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_binding.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_view.dart';
import 'package:jobber_city/screens/splash/splash_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: SplashViewBinding(),
    ),
    GetPage(
      name: AppRoutes.homeSeeker,
      page: () => HomeSeekerView(),
      binding: HomeSeekerViewBinding(),
    ),
    GetPage(
      name: AppRoutes.homeEmployer,
      page: () => HomeEmployerView(),
      binding: HomeEmployerViewBinding(),
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
    GetPage(
      name: AppRoutes.category,
      page: () => CategoryScreenView(),
      binding: CategoryScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.location,
      page: () => LocationScreenView(),
      binding: LocationScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.companyProfile,
      page: () => CompanyProfileView(),
      binding: CompanyProfileViewBinding(),
    ),
    GetPage(
      name: AppRoutes.mainScreen,
      page: () => MainScreenView(),
      binding: MainScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.editprofile,
      page: () => EditProfileScreenView(),
      binding: EditProfileScreenViewBinding(),
    ),
  ];
}
