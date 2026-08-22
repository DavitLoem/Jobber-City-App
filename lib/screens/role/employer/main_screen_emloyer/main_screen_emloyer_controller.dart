import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:jobber_city/screens/role/employer/employer_profile/employer_profile_view.dart';
import 'package:jobber_city/screens/role/employer/home_employer/home_employer_view.dart';
import 'package:jobber_city/screens/role/employer/my_job/my_job_view.dart';

import '../../../shared/chat/conversation_list/conversation_list_view.dart';

class MainScreenEmloyerController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeEmployer:
        return GetPageRoute(
          settings: settings,
          page: () => const HomeEmployerView(),
        );
      case AppRoutes.myJob:
        return GetPageRoute(settings: settings, page: () => const MyJobView());
      case AppRoutes.candidates:
        return GetPageRoute(
          settings: settings,
          page: () => const CandidatesView(),
        );

      case AppRoutes.conversationList:
        return GetPageRoute(
          settings: settings,
          page: () => const ConversationListView(),
        );
      case AppRoutes.employerProfile:
        return GetPageRoute(
          settings: settings,
          page: () => const EmployerProfileView(),
        );
      default:
        return null;
    }
  }
}
