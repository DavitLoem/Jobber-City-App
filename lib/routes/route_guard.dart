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
    // ទាញយក Role បច្ចុប្បន្នពី AuthController
    final String currentRole = Get.find<AuthController>().userRole.value;

    if (currentRole != requiredRole) {
      // បើ Role មិនត្រូវគ្នា ទាត់ទៅ Home របស់ពួកគេរៀងៗខ្លួន
      if (currentRole == 'employer') {
        return const RouteSettings(name: AppRoutes.homeEmployer);
      } else {
        return const RouteSettings(name: AppRoutes.homeSeeker);
      }
    }
    return null; // បើ Role ត្រូវគ្នា អនុញ្ញាតឱ្យចូល
  }
}
