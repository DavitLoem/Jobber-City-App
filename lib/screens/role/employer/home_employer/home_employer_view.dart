import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
          child: Column(
            children: [
              const HomeHeader(),
              SizedBox(height: 16),
              StatsGrid(),
              SizedBox(height: 16),
              const ApplicantPipelineCard(
                screening: 34,
                review: 21,
                interview: 18,
                offer: 12,
              ),
              SizedBox(height: 16),
              RecentApplicantsSection(),
              SizedBox(height: 16),
              QuickActionsSection(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

          // IconButton(
          //   onPressed: () {
          //     Get.find<AuthController>().logout();
          //   },
          //   icon: const Icon(Icons.logout),
          // ),
