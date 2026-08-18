import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/bookmark_controller.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_feed_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

import 'widgets/hero_section.dart';
import 'widgets/job_ui_utils.dart';
import 'widgets/promo_banner_slider.dart';
import 'widgets/recent_jobs_section.dart';
import 'widgets/recommended_jobs_section.dart';

part 'home_seeker_binding.dart';
part 'home_seeker_controller.dart';

class HomeSeekerView extends GetView<HomeSeekerViewController> {
  const HomeSeekerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Get active theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          controller.fetchProfileRaw();
          controller.fetchJobRecommended();
          controller.fetchJobRecent(isRefresh: true);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isRecentLoadingMore.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              controller.fetchJobRecent();
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
                const HeroSection(),
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PromoBannerSlider(),
                      const SizedBox(height: 28),

                      JobUiUtils.buildSectionHeader(
                        "Recommended For You".tr, // 🟢 Added .tr
                        onSeeAll: () {
                          Get.toNamed(
                            AppRoutes.jobList,
                            arguments: {
                              'type': 'recommended',
                              'title': 'Recommended Jobs'.tr, // 🟢 Added .tr
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const RecommendedJobsSection(),

                      const SizedBox(height: 32),

                      JobUiUtils.buildSectionHeader(
                        "Recent Jobs".tr, // 🟢 Added .tr
                        onSeeAll: () {
                          Get.toNamed(
                            AppRoutes.jobList,
                            arguments: {
                              'type': 'recent',
                              'title': 'Recent Jobs'.tr, // 🟢 Added .tr
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const RecentJobsSection(),

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
