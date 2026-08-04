import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_feed_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart'; // 🎯 ប្តូរមកប្រើ Model ថ្មី

import 'widgets/hero_section.dart';
import 'widgets/job_ui_utils.dart';
// 🎯 Import Widgets ដែលទើបនឹងបំបែក
import 'widgets/promo_banner_slider.dart';
import 'widgets/recent_jobs_section.dart';
import 'widgets/recommended_jobs_section.dart';

part 'home_seeker_binding.dart';
part 'home_seeker_controller.dart';

class HomeSeekerView extends GetView<HomeSeekerViewController> {
  const HomeSeekerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          controller.fetchProfileRaw();
          controller.fetchJobRecommended();
          controller.fetchJobRecent(isRefresh: true);
        },
        // 🎯 បន្ថែម Listener ដើម្បីចាប់យកសកម្មភាពអូសចុះក្រោមដល់បាត
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isRecentLoadingMore.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              controller.fetchJobRecent(); // ទាញយក Page បន្ទាប់
            }
            return false;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroSection(), // 🎯 ហៅ Component ទី ១ មកប្រើ
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PromoBannerSlider(), // 🎯 ហៅ Component ទី ២ មកប្រើ
                      const SizedBox(height: 28),

                      JobUiUtils.buildSectionHeader("Recommended For You"),
                      const SizedBox(height: 16),
                      const RecommendedJobsSection(), // 🎯 ហៅ Component ទី ៣ មកប្រើ

                      const SizedBox(height: 32),

                      JobUiUtils.buildSectionHeader("Recent Jobs"),
                      const SizedBox(height: 16),
                      const RecentJobsSection(), // 🎯 ហៅ Component ទី ៤ មកប្រើ

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
