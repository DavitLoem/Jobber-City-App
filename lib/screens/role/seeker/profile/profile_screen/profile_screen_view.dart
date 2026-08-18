import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

import '../../../../../core/utils/app_logger.dart';
import '../../../../../core/utils/token_storage.dart';
import 'widgets/complete_profile_banner.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

                ProfileSectionItem(
                  icon: Icons.upload_file_rounded,
                  title: "Edit Resume".tr,
                  isCompleted:
                      controller.profileData.value?.resumeUrl != null &&
                      controller.profileData.value!.resumeUrl.isNotEmpty,
                  isResume: true,
                  onTap: () {
                    Get.toNamed(AppRoutes.cvExtraction);
                  },
                ),
                const SizedBox(height: 12),

                ProfileSectionItem(
                  icon: Icons.work_outline,
                  title: "Work Experience".tr,
                  isCompleted:
                      controller.profileData.value?.experiences != null &&
                      controller.profileData.value!.experiences.isNotEmpty,
                  onTap: () async {
                    await Get.toNamed(AppRoutes.experience);
                  },
                ),
                const SizedBox(height: 12),

                ProfileSectionItem(
                  icon: Icons.school_outlined,
                  title: "Education Background".tr,
                  isCompleted:
                      controller.profileData.value?.educations != null &&
                      controller.profileData.value!.educations.isNotEmpty,
                  onTap: () async {
                    await Get.toNamed(AppRoutes.educations);
                  },
                ),
                const SizedBox(height: 12),

                ProfileSectionItem(
                  icon: Icons.workspace_premium_outlined,
                  title: "Trainings".tr,
                  isCompleted:
                      controller.profileData.value?.trainings != null &&
                      controller.profileData.value!.trainings.isNotEmpty,
                  onTap: () async {
                    await Get.toNamed(AppRoutes.trainings);
                    controller.fetchProfileRaw();
                  },
                ),
                const SizedBox(height: 12),

                ProfileSectionItem(
                  icon: Icons.psychology_outlined,
                  title: "Skills".tr,
                  isCompleted:
                      controller.profileData.value?.skills != null &&
                      controller.profileData.value!.skills.isNotEmpty,
                  onTap: () {
                    Get.toNamed(AppRoutes.skill);
                  },
                ),
                const SizedBox(height: 12),

                ProfileSectionItem(
                  icon: Icons.article_outlined,
                  title: "Biography".tr,
                  isCompleted:
                      controller.profileData.value?.biography != null &&
                      controller.profileData.value!.biography.isNotEmpty,
                  onTap: () {
                    Get.toNamed(AppRoutes.biography);
                  },
                ),
                const SizedBox(height: 12),

                ProfileSectionItem(
                  icon: Icons.language_outlined,
                  title: "Language".tr,
                  isCompleted:
                      controller.profileData.value?.languages != null &&
                      controller.profileData.value!.languages.isNotEmpty,
                  onTap: () {
                    Get.toNamed(AppRoutes.languages);
                  },
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
