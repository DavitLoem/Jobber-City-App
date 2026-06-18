import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/auth/create_acc_screen/create_acc_screen_view.dart';
import 'package:jobber_city/screens/auth/forgot_pass_screen/forgot_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_binding.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';
import 'package:jobber_city/screens/auth/reset_pass_screen/reset_pass_screen_view.dart';
import 'package:jobber_city/screens/auth/verify_otp_screen.dart/verify_otp_screen_dart_view.dart';
import 'package:jobber_city/screens/category_screen/category_screen_view.dart';
import 'package:jobber_city/screens/home_screen/home_screen_view.dart';
import 'package:jobber_city/screens/location_screen/location_screen_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreenView(),
      binding: HomeScreenViewBinding(),
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
      page: () => VerifyOtpScreenDartView(),
      binding: VerifyOtpScreenDartViewBinding(),
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
  ];
}
