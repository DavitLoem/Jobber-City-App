import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/core/api/services/role/seeker/application_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';

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
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
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
                        SizedBox(height: 22),
                        JobContentSections(), // 🎯 ព័ត៌មានទាំងអស់នៅទីនេះ
                        SizedBox(
                          height: 110,
                        ), // ទុករន្ធចន្លោះសម្រាប់ Bottom Bar
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
