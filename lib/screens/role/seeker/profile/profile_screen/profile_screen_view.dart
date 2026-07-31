import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/routes/app_routes.dart';

import '../../../../../core/utils/app_logger.dart';
import '../../../../../core/utils/token_storage.dart';
import 'widgets/complete_profile_banner.dart';
// Import ផ្នែកដែលបានបំបែក
import 'widgets/profile_app_bar.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_section_item.dart';

part 'profile_screen_binding.dart';
part 'profile_screen_controller.dart';

class ProfileScreenView extends GetView<ProfileScreenViewController> {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileAppBar(),
                const SizedBox(height: 15),

                ProfileInfoCard(controller: controller),
                const SizedBox(height: 14),

                CompleteProfileBanner(
                  completionPercentage: 0.4,
                  onFillInTap: () => controller.goToEditProfile(),
                ),
                const SizedBox(height: 24),

                // 🎯 1. Edit Resume (Upload CV)
                ProfileSectionItem(
                  icon: Icons.upload_file_rounded,
                  title: "Edit Resume",
                  isCompleted: false,
                  onTap: () {
                    Get.toNamed(AppRoutes.cvExtraction);
                  },
                ),
                const SizedBox(height: 12),

                // 🎯 2. Work Experience
                ProfileSectionItem(
                  icon: Icons.work_outline,
                  title: "Work Experience",
                  isCompleted: true, // ចាំដាក់លក្ខខណ្ឌពិតប្រាកដតាមក្រោយ
                  onTap: () async {
                    await Get.toNamed(AppRoutes.experience);
                    controller.fetchProfileRaw();
                  },
                ),
                const SizedBox(height: 12),

                // 🎯 3. Education Background
                ProfileSectionItem(
                  icon: Icons.school_outlined,
                  title: "Education Background",
                  isCompleted: true,
                  onTap: () async {
                    await Get.toNamed(AppRoutes.educations);
                    controller.fetchProfileRaw();
                  },
                ),
                const SizedBox(height: 12),

                // 🎯 4. Trainings
                ProfileSectionItem(
                  icon: Icons.workspace_premium_outlined,
                  title: "Trainings",
                  isCompleted: false,
                  onTap: () async {
                    await Get.toNamed(AppRoutes.trainings);
                    controller.fetchProfileRaw();
                  },
                ),
                const SizedBox(height: 12),

                // 🎯 5. Skills
                ProfileSectionItem(
                  icon: Icons.psychology_outlined, // ឬ Icons.star_border
                  title: "Skills",
                  isCompleted: false,
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                // 🎯 6. Biography
                ProfileSectionItem(
                  icon: Icons.article_outlined,
                  title: "Biography",
                  isCompleted: false,
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                // 🎯 7. Language
                ProfileSectionItem(
                  icon: Icons.language_outlined,
                  title: "Language",
                  isCompleted: false,
                  onTap: () {},
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }
}
