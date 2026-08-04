import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/routes/app_routes.dart';

class OnboardingMiddleware extends GetMiddleware {
  @override
  int? get priority => 3; // ឱ្យវាដើរក្រោយ AuthMiddleware និង RoleMiddleware

  @override
  RouteSettings? redirect(String? route) {
    final authCtrl = Get.find<AuthController>();

    // 🎯 ឆែកមើល៖ បើគាត់ជា Seeker ហើយមិនទាន់ Onboarding រួចរាល់
    if (authCtrl.userRole.value == 'seeker' &&
        authCtrl.isOnboardingCompleted.value == false) {
      debugPrint(
        "🚧 OnboardingMiddleware: User is a Seeker and has not completed onboarding. Redirecting to Location Screen.",
      );
      return const RouteSettings(
        name: AppRoutes.location,
      ); // ទាត់ទៅ Location វិញ
    }

    return null; // អនុញ្ញាតឱ្យចូល Main Screen ធម្មតា
  }
}
