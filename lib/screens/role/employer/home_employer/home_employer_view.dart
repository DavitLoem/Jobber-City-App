import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/company_profile_services.dart';
import 'package:jobber_city/core/api/services/role/employer/employer_dashboard_service.dart'; // 🟢 ត្រូវ Import
import 'package:jobber_city/models/role/employer/company_model.dart';
import 'package:jobber_city/models/role/employer/employer_dashboard_model.dart'; // 🟢 ត្រូវ Import

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
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF4f7df7), // ពណ៌របស់រង្វង់វិលពេលទាញ
          backgroundColor: Colors.white,
          onRefresh: () async {
            // 🟢 ២. ហៅមុខងារទាញយកទិន្នន័យសាជាថ្មីពេលអ្នកប្រើប្រាស់ទាញទម្លាក់
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

                // 🟢 រុំជាមួយ Obx ដើម្បីរង់ចាំទិន្នន័យពី API
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
                    return const Center(
                      child: Text("No dashboard data found."),
                    );
                  }

                  return Column(
                    children: [
                      // បោះទិន្នន័យ overview ទៅឱ្យ StatsGrid
                      StatsGrid(overview: dashboardData.overview),
                      const SizedBox(height: 16),

                      // បោះទិន្នន័យ pipeline ទៅឱ្យ Pipeline Card
                      ApplicantPipelineCard(
                        screening: dashboardData.pipeline.screening,
                        review: dashboardData.pipeline.review,
                        interview: dashboardData.pipeline.interview,
                        offer: dashboardData.pipeline.offer,
                      ),
                      const SizedBox(height: 16),

                      // ពេលអ្នកអាប់ដេត RecentApplicantsSection កុំភ្លេចបោះ `dashboardData.recentApplicants` ឱ្យវា
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
