import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/widgets/custom_button.dart';

import 'widget/address_section.dart';
import 'widget/contact_section.dart';
import 'widget/current_position_section.dart';
import 'widget/edit_profile_header.dart';
import 'widget/personal_info_section.dart';

class EditProfileScreenView extends GetView<EditProfileScreenViewController> {
  const EditProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Get global theme context
    final isDark = theme.brightness == Brightness.dark; // 🟢 Get current mode

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎯 1. ផ្នែក Header និងរូប Profile
                EditProfileHeader(controller: controller),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // 🎯 2. ផ្នែក Personal Information
                      _Section(
                        index: 0,
                        icon: Icons.badge_outlined,
                        label: 'Personal Information'.tr, // 🟢 Added .tr
                        isDark: isDark, // 🟢 Passed Theme State
                        theme: theme, // 🟢 Passed Theme Context
                        child: PersonalInfoSection(controller: controller),
                      ),
                      const SizedBox(height: 20),

                      // 🎯 3. ផ្នែក Contact
                      _Section(
                        index: 1,
                        icon: Icons.contact_mail_outlined,
                        label: 'Contact'.tr, // 🟢 Added .tr
                        isDark: isDark,
                        theme: theme,
                        child: ContactSection(controller: controller),
                      ),
                      const SizedBox(height: 20),

                      // 🎯 4. ផ្នែក Current Position
                      _Section(
                        index: 2,
                        icon: Icons.work_outline_rounded,
                        label: 'Current Position'.tr, // 🟢 Added .tr
                        isDark: isDark,
                        theme: theme,
                        child: CurrentPositionSection(controller: controller),
                      ),
                      const SizedBox(height: 20),

                      // 🎯 5. ផ្នែក Address
                      _Section(
                        index: 3,
                        icon: Icons.location_on_outlined,
                        label: 'Address'.tr, // 🟢 Added .tr
                        isDark: isDark,
                        theme: theme,
                        child: AddressSection(controller: controller),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor, // 🟢 Dynamic Bottom Nav BG
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.darkDivider
                  : Colors.transparent, // 🟢 Better edge styling in dark mode
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.3 : 0.04,
              ), // 🟢 Dynamic Shadow
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52,
              child: CustomButton(
                // ប្តូរអក្សរពេលកំពុង Save
                text: controller.isSaving.value
                    ? 'Saving...'.tr
                    : 'Save Profile'.tr, // 🟢 Added .tr
                // បិទប៊ូតុងកុំឱ្យចុចត្រួតគ្នាពេលកំពុង Save
                onPressed: controller.isSaving.value
                    ? null
                    : controller.updateProfile,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// រក្សា Class _Section ដដែលសម្រាប់ស៊ុមពណ៌សជុំវិញ
class _Section extends StatelessWidget {
  const _Section({
    required this.index,
    required this.icon,
    required this.label,
    required this.child,
    required this.isDark, // 🟢 Added
    required this.theme, // 🟢 Added
  });

  final int index;
  final IconData icon;
  final String label;
  final Widget child;
  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + index * 90),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.primaryLight, // 🟢 Dynamic BG
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: isDark
                      ? Colors.blueAccent
                      : AppColors.primary, // 🟢 Dynamic Icon
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textHint, // 🟢 Dynamic Text
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor, // 🟢 Dynamic Content Box BG
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? AppColors.darkCardBorder
                    : AppColors.cardBorder, // 🟢 Dynamic Content Box Border
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}
