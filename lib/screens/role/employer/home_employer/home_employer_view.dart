import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/company_profile_services.dart';
import 'package:jobber_city/core/api/services/role/employer/employer_dashboard_service.dart'; // 🟢 Must Import
import 'package:jobber_city/models/role/employer/company_model.dart';
import 'package:jobber_city/models/role/employer/employer_dashboard_model.dart'; // 🟢 Must Import

import 'widgets/applicant_pipeline_card.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/recent_applicants_section.dart';
import 'widgets/stats_grid.dart';

part 'home_employer_binding.dart';
part 'home_employer_controller.dart';

class HomeEmployerView extends GetView<HomeEmployerViewController> {
  const HomeEmployerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Added to inherit dark/light theme background
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(
            0xFF4f7df7,
          ), // Color of the loading indicator when pulled
          backgroundColor: Theme.of(
            context,
          ).cardColor, // Updated from Colors.white for dark mode support
          onRefresh: () async {
            // 🟢 2. Call the function to fetch data again when the user pulls down
            await Future.wait([
              controller.fetchCompanyProfile(),
              controller.fetchDashboardOverview(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: Column(
              children: [
                const HomeHeader(),
                const SizedBox(height: 16),

                // 🟢 Wrap with Obx to wait for API data
                Obx(() {
                  if (controller.isDashboardLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4f7df7),
                        ),
                      ),
                    );
                  }

                  final dashboardData = controller.dashboardData.value;

                  if (dashboardData == null) {
                    return Center(
                      child: Text(
                        "No dashboard data found.",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color, // Prevents text from turning invisible in dark mode
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Pass overview data to StatsGrid
                      StatsGrid(overview: dashboardData.overview),
                      const SizedBox(height: 16),

                      // Pass pipeline data to Pipeline Card
                      ApplicantPipelineCard(
                        screening: dashboardData.pipeline.screening,
                        review: dashboardData.pipeline.review,
                        interview: dashboardData.pipeline.interview,
                        offer: dashboardData.pipeline.offer,
                      ),
                      const SizedBox(height: 16),

                      // When updating RecentApplicantsSection, don't forget to pass `dashboardData.recentApplicants` to it
                      RecentApplicantsSection(
                        applicants: dashboardData.recentApplicants,
                      ),

                      const SizedBox(height: 16),
                      const QuickActionsSection(),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
