import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/bookmark_controller.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/core/api/services/role/seeker/application_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/screens/role/seeker/application/application_view.dart';

import 'widgets/bottom_apply_bar.dart';
import 'widgets/company_info_card.dart';
import 'widgets/job_content_sections.dart';
import 'widgets/job_detail_header.dart';

part 'job_detail_binding.dart';
part 'job_detail_controller.dart';

class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const JobDetailHeader(),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CompanyInfoCard(),
                        JobContentSections(),
                        SizedBox(height: 110),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomApplyBar(),
          ),
        ],
      ),
    );
  }
}
