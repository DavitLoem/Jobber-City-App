import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/company_profile_services.dart';
import 'package:jobber_city/models/role/employer/company_model.dart';

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
    final theme = Theme.of(context); // 🟢 Grab active theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 16),
              const StatsGrid(),
              const SizedBox(height: 16),
              const ApplicantPipelineCard(
                screening: 34,
                review: 21,
                interview: 18,
                offer: 12,
              ),
              const SizedBox(height: 16),
              const RecentApplicantsSection(),
              const SizedBox(height: 16),
              const QuickActionsSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
