import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'profile_screen_binding.dart';
part 'profile_screen_controller.dart';

class ProfileScreenView extends GetView<ProfileScreenViewController> {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Clean background color
      body: SafeArea(
        child: Obx(() {
          // Show Loading while fetching data from API
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                _buildProfileCard(),
                const SizedBox(height: 14),
                _buildCompleteProfileBanner(),
                const SizedBox(height: 24),

                // Profile Section List
                _buildSectionItem(
                  icon: Icons.person_outline,
                  title: "Contact Information",
                  onTap: () => Get.toNamed(
                    '/edit-profile',
                  )?.then((_) => controller.fetchProfileRaw()),
                ),
                const SizedBox(height: 12),
                _buildSectionItem(
                  icon: Icons.article_outlined,
                  title: "Summary",
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildSectionItem(
                  icon: Icons.pie_chart_outline_rounded,
                  title: "Expected Salary",
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildSectionItem(
                  icon: Icons.work_outline,
                  title: "Work Experience",
                  onTap: () async {
                    // ១. រង់ចាំរហូតដល់អ្នកប្រើប្រាស់ Back ត្រឡប់មកពីទំព័រ Experience វិញ
                    await Get.toNamed(
                      AppRoutes.experience,
                    ); // សូមដូរឈ្មោះ Route ឲ្យត្រូវនឹងកូដពិតរបស់អ្នក

                    // ២. ពេលត្រឡប់មកដល់ទីនេះវិញ ហៅមុខងារទាញទិន្នន័យម្ដងទៀត ដើម្បី Refresh UI!
                    controller.fetchProfileRaw();
                  },
                ),
                const SizedBox(height: 12),
                _buildSectionItem(
                  icon: Icons.school_outlined,
                  title: "Education",
                  onTap: () {
                    Get.toNamed(AppRoutes.educations);
                    controller.fetchProfileRaw();
                  },
                ),
                const SizedBox(height: 12),
                _buildSectionItem(
                  icon: Icons.bar_chart_rounded,
                  title: "Projects",
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildSectionItem(
                  icon: Icons.workspace_premium_outlined,
                  title: "Certifications & Licenses",
                  onTap: () {
                    Get.toNamed(AppRoutes.trainings);
                    controller.fetchProfileRaw();
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

  // ── AppBar Section ──
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Icon(
            Icons.settings_outlined,
            size: 22,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ── Profile Information Card (Avatar, Name, Position, Edit) ──
  Widget _buildProfileCard() {
    final bool hasPosition = controller.position.value.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🟢 Avatar (Outlined Circle)
          Obx(
            () => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: ClipOval(
                child: controller.profileImageUrl.value.isNotEmpty
                    ? Image.network(
                        controller.profileImageUrl.value,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildAvatarFallback(22),
                      )
                    : _buildAvatarFallback(22),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name and Position Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.firstName.value} ${controller.lastName.value}"
                      .trim(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: hasPosition
                        ? AppColors.successBackground
                        : AppColors.warningBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasPosition
                            ? Icons.check_circle_outline
                            : Icons.info_outline,
                        size: 13,
                        color: hasPosition
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          hasPosition
                              ? controller.position.value
                              : "No position added — tap to fill",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: hasPosition
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Edit Button (pencil icon)
          GestureDetector(
            onTap: () => Get.toNamed(
              '/edit-profile',
            )?.then((_) => controller.fetchProfileRaw()),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 19,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Complete Profile Banner ──
  Widget _buildCompleteProfileBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Complete your profile to stand out to employers.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Get.toNamed(
              '/edit-profile',
            )?.then((_) => controller.fetchProfileRaw()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Fill In",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared avatar fallback (initials) ──
  Widget _buildAvatarFallback(double fontSize) {
    final initial = controller.firstName.value.isNotEmpty
        ? controller.firstName.value[0].toUpperCase()
        : 'U';
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ── Section Item (Icon + Title + Add Button) ──
  Widget _buildSectionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
