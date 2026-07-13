import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';

import '../../routes/app_routes.dart';

// 🛡 ១. អ្នកយាមទ្វារទី១៖ ឆែកមើលថាតើគាត់បាន Login ហើយឬនៅ?
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // យើងមិនអាចប្រើ await ក្នុងចំណុចនេះបានទេ ដូច្នេះទាមទារឱ្យ
    // TokenStorage របស់អ្នកមានអថេរដែលផ្ទុក Token ជា Synchronous (InMemory)
    // ឬ វិធីងាយស្រួលបំផុតគឺឆែកតាមរយៈ Controller ណាមួយដែលរស់រហូត (ដូចជា AuthController)

    // សន្មត់ថាយើងមាន AuthController ជាអ្នកកាន់ State
    final bool isLoggedIn = Get.find<AuthController>().isLoggedIn.value;

    if (!isLoggedIn) {
      // បើមិនទាន់ Login ទេ ទាត់បញ្ជូនទៅផ្ទាំង Login វិញ
      return const RouteSettings(name: AppRoutes.login);
    }
    return null; // បើ Login ហើយ អនុញ្ញាតឱ្យដើរទៅមុខធម្មតា
  }
}

// 🛡 ២. អ្នកយាមទ្វារទី២៖ ឆែកមើលថាតើគាត់មាន Role ត្រឹមត្រូវឬទេ?
class RoleMiddleware extends GetMiddleware {
  final String requiredRole;

  RoleMiddleware({required this.requiredRole});

  @override
  RouteSettings? redirect(String? route) {
    final authCtrl = Get.find<AuthController>();
    final String currentRole = authCtrl.userRole.value;
    final bool isProfileCompleted =
        authCtrl.isProfileCompleted.value; // 🎯 ទាញពី Auth

    // លក្ខខណ្ឌទី ១៖ បើ Role មិនត្រូវគ្នា (ចង់ចូលខុសផ្ទះ)
    if (currentRole != requiredRole) {
      if (currentRole == 'employer') {
        // បើគាត់ជា Employer ត្រូវបញ្ជូនទៅតាម Status Profile របស់គាត់
        return isProfileCompleted
            ? const RouteSettings(name: AppRoutes.mainScreenEmployer)
            : const RouteSettings(name: AppRoutes.companyProfile);
      } else {
        return const RouteSettings(name: AppRoutes.mainScreenSeeker);
      }
    }

    // លក្ខខណ្ឌទី ២ 🎯៖ បើគាត់ជា Employer ត្រូវ Role ហើយ តែមិនទាន់បំពេញ Profile!
    if (currentRole == 'employer' &&
        !isProfileCompleted &&
        route != AppRoutes.companyProfile) {
      return const RouteSettings(
        name: AppRoutes.companyProfile,
      ); // ទាត់ត្រឡប់ទៅឱ្យបំពេញសិន
    }

    return null;
  }
}
