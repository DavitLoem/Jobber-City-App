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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic background
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
                EditProfileHeader(controller: controller),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _Section(
                        index: 0,
                        icon: Icons.badge_outlined,
                        label: 'Personal Information'.tr, // 🟢 Added .tr
                        child: PersonalInfoSection(controller: controller),
                      ),
                      const SizedBox(height: 20),
                      _Section(
                        index: 1,
                        icon: Icons.contact_mail_outlined,
                        label: 'Contact'.tr, // 🟢 Added .tr
                        child: ContactSection(controller: controller),
                      ),
                      const SizedBox(height: 20),
                      _Section(
                        index: 2,
                        icon: Icons.work_outline_rounded,
                        label: 'Current Position'.tr, // 🟢 Added .tr
                        child: CurrentPositionSection(controller: controller),
                      ),
                      const SizedBox(height: 20),
                      _Section(
                        index: 3,
                        icon: Icons.location_on_outlined,
                        label: 'Address'.tr, // 🟢 Added .tr
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
          color: theme.scaffoldBackgroundColor, // 🟢 Dynamic background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.3 : 0.04,
              ), // 🟢 Updated opacity
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
                text: controller.isSaving.value
                    ? 'Saving...'.tr
                    : 'Save Profile'.tr, // 🟢 Added .tr
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

class _Section extends StatelessWidget {
  const _Section({
    required this.index,
    required this.icon,
    required this.label,
    required this.child,
  });

  final int index;
  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                      ? AppColors.primary.withValues(
                          alpha: 0.2,
                        ) // 🟢 Updated opacity
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextHint
                      : AppColors.textHint, // 🟢 Dynamic label
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor, // 🟢 Dynamic card color
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
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
