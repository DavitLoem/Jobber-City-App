import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/auth/create_acc_screen/create_acc_screen_view.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_binding.dart';
import 'package:jobber_city/screens/auth/login_screen/login_screen_view.dart';
import 'package:jobber_city/screens/home/home_screen/home_screen_view.dart';

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
  ];
}
