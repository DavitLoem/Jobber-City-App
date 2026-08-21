import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/application/application_view.dart';
import 'package:jobber_city/screens/role/seeker/home_seeker/home_seeker_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/save_job_screen/save_job_screen_view.dart';

class MainScreenController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  // 🎯 មុខងារគ្រប់គ្រង Nested Routes (ប្រវត្តិដាច់ដោយឡែករបស់ Tab នីមួយៗ)
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeSeeker:
        return GetPageRoute(
          settings: settings,
          page: () => const HomeSeekerView(),
        );
      case AppRoutes.saveJob:
        return GetPageRoute(
          settings: settings,
          page: () => const SaveJobScreenView(),
        );
      case AppRoutes.applied:
        return GetPageRoute(settings: settings, page: () => ApplicationView());
      case '/profile':
        return GetPageRoute(
          settings: settings,
          page: () => const ProfileScreenView(),
        );
      default:
        return null;
    }
  }
}
