import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/app_logger.dart';

part 'setting_screen_binding.dart';
part 'setting_screen_controller.dart';

class SettingScreenView extends GetView<SettingScreenViewController> {
  const SettingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightBackground, // 🟢 ប្រើពណ៌ Background របស់ App
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCompleteBanner(),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.remove_red_eye_outlined,
                      title: 'Job Seeking Status',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('ACCOUNT SECTION'),
                    _buildSettingItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Personal Info',
                      onTap: () => Get.toNamed(
                        '/edit-profile',
                      )?.then((_) => controller.fetchProfileCompletion()),
                    ),
                    _buildSettingItem(
                      icon: Icons.swap_vert_rounded,
                      title: 'Linked Accounts',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildSectionTitle('GENERAL SECTION'),
                    _buildSettingItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notification',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.work_outline_rounded,
                      title: 'Application Issues',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Security',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.g_translate_rounded,
                      title: 'Language',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.remove_red_eye_outlined,
                      title: 'Appearance',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.info_outline_rounded,
                      title: 'Help Center',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.people_outline_rounded,
                      title: 'Invite Friends',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.star_border_rounded,
                      title: 'Rate Us',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildSectionTitle('ABOUT SECTION'),
                    _buildSettingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.info_outline_rounded,
                      title: 'About Us',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildSettingItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Deactivate Account',
                      isDanger: true,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      isDanger: true,
                      onTap: () => _showLogoutDialog(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cardBorder,
                ), // 🟢 ប្រើ AppColors.cardBorder
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProfileCompleteBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primary, // 🟢 ប្រើ AppColors
            AppColors.primary.withOpacity(0.78), // 🟢 ប្រើ AppColors
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CircularProgressIndicator(
                  value: 1.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white24),
                  strokeWidth: 4.5,
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 3,
                      ),
                    );
                  }

                  double pct = controller.completionPercentage.value / 100;
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: pct),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, _) => CircularProgressIndicator(
                      value: value,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 4.5,
                      strokeCap: StrokeCap.round,
                    ),
                  );
                }),
                Center(
                  child: Obx(
                    () => Text(
                      controller.isLoading.value
                          ? '...'
                          : '${controller.completionPercentage.value}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete your profile to get better job recommendations',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textHint, // 🟢 ប្រើ AppColors
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    // 🟢 ប្រើពណ៌ពី AppColors
    final color = isDanger ? AppColors.error : AppColors.primary;
    final bgColor = isDanger
        ? AppColors.error.withOpacity(0.1)
        : AppColors.primaryLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ), // 🟢 ប្រើ AppColors
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDanger ? color : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDanger ? color : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1), // 🟢 ប្រើ AppColors
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 32,
                  color: AppColors.error, // 🟢 ប្រើ AppColors
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to log out from this account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.cardBorder),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error, // 🟢 ប្រើ AppColors
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
