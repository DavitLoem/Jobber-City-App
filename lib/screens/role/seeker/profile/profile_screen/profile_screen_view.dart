import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';
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

  bool get _isDark {
    final mode = controller.themeController.themeMode.value;
    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              // រង់ចាំឱ្យអនុគមន៍ទាំង ២ ទាញទិន្នន័យចប់សិន ទើបបិទរង្វង់ Refresh
              await Future.wait([
                controller.fetchCompleteProfile(),
                controller.fetchProfileRaw(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                    icon: Icons.picture_as_pdf_outlined,
                    title: "Generate CV".tr,
                    onTap: () {
                      Get.toNamed(AppRoutes.cvGenerate);
                    },
                  ),
                  const SizedBox(height: 12),

                  // 🎯 1. Edit Resume (Upload CV)
                  ProfileSectionItem(
                    icon: Icons.upload_file_rounded,
                    title: "Edit Resume".tr,
                    // សន្មតថាបើមាន URL ឬ Filename គឺបាន Completed ហើយ
                    isCompleted:
                        controller.profileData.value?.resumeUrl != null &&
                        controller.profileData.value!.resumeUrl.isNotEmpty,
                    isResume: true, // 🟢 កំណត់ថាជា Resume ទីនេះ
                    onTap: () {
                      Get.toNamed(AppRoutes.cvExtraction);
                    },
                  ),
                  const SizedBox(height: 12),

                  // 🎯 2. Work Experience
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

                  // 🎯 3. Education Background
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

                  // 🎯 4. Trainings
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

                  // 🎯 5. Skills
                  ProfileSectionItem(
                    icon: Icons.psychology_outlined, // ឬ Icons.star_border
                    title: "Skills".tr,
                    isCompleted:
                        controller.profileData.value?.skills != null &&
                        controller.profileData.value!.skills.isNotEmpty,
                    onTap: () {
                      Get.toNamed(AppRoutes.skill);
                    },
                  ),
                  const SizedBox(height: 12),

                  // 🎯 6. Biography
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

                  // 🎯 7. Language
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
                  const SizedBox(height: 12),

                  // 🎯 8. Appearance
                  ProfileSectionItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: "Appearance".tr,
                    onTap: () => _showAppearanceBottomSheet(),
                  ),
                  const SizedBox(height: 12),

                  // 🎯 9. App Language
                  ProfileSectionItem(
                    icon: Icons.g_translate_rounded,
                    title: "App Language".tr,
                    onTap: () => _showLanguageBottomSheet(),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showAppearanceBottomSheet() {
    Get.bottomSheet(
      Obx(() {
        final isDark = _isDark;
        final bgColor = isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark
            ? AppColors.darkTextHint
            : AppColors.textHint;
        final dividerColor = isDark
            ? AppColors.darkDivider
            : Colors.grey.withValues(alpha: 0.3);

        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Appearance'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your preferred color scheme'.tr,
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThemeOption(
                    title: 'Light'.tr,
                    mode: ThemeMode.light,
                    mockup: const _PhoneMockup(style: _MockupStyle.light),
                    isDark: isDark,
                  ),
                  _buildThemeOption(
                    title: 'Dark'.tr,
                    mode: ThemeMode.dark,
                    mockup: const _PhoneMockup(style: _MockupStyle.dark),
                    isDark: isDark,
                  ),
                  _buildThemeOption(
                    title: 'System'.tr,
                    mode: ThemeMode.system,
                    mockup: const _PhoneMockup(style: _MockupStyle.system),
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _buildThemeOption({
    required String title,
    required ThemeMode mode,
    required Widget mockup,
    required bool isDark,
  }) {
    final isSelected = controller.themeController.themeMode.value == mode;

    final textActiveColor = isDark ? Colors.white : Colors.black87;
    final textInactiveColor = isDark
        ? AppColors.darkTextHint
        : AppColors.textHint;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTheme(mode),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              mockup,
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? textActiveColor : textInactiveColor,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    Get.bottomSheet(
      Obx(() {
        final isDark = _isDark;
        final bgColor = isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark
            ? AppColors.darkTextHint
            : AppColors.textHint;
        final dividerColor = isDark
            ? AppColors.darkDivider
            : Colors.grey.withValues(alpha: 0.3);

        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'App Language'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your preferred language'.tr,
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLanguageOption(
                    title: 'English',
                    flagEmoji: '🇺🇸',
                    accentColor: const Color(0xFF2F80ED),
                    locale: const Locale('en', 'US'),
                    isDark: isDark,
                  ),
                  _buildLanguageOption(
                    title: 'ភាសាខ្មែរ',
                    flagEmoji: '🇰🇭',
                    accentColor: const Color(0xFFEB5757),
                    locale: const Locale('km', 'KH'),
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String flagEmoji,
    required Color accentColor,
    required Locale locale,
    required bool isDark,
  }) {
    final isSelected = Get.locale?.languageCode == locale.languageCode;

    final textActiveColor = isDark ? Colors.white : Colors.black87;
    final textInactiveColor = isDark
        ? AppColors.darkTextHint
        : AppColors.textHint;

    return Expanded(
      child: InkWell(
        onTap: () {
          controller.changeLanguage(
            locale.languageCode,
            locale.countryCode ?? '',
          );
          Get.back();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Text(flagEmoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? textActiveColor : textInactiveColor,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MockupStyle { light, dark, system }

class _PhoneMockup extends StatelessWidget {
  final _MockupStyle style;
  const _PhoneMockup({required this.style});

  @override
  Widget build(BuildContext context) {
    const double width = 96;
    const double height = 170;
    const radius = 18.0;

    if (style != _MockupStyle.system) {
      final isDark = style == _MockupStyle.dark;
      return _phoneShell(
        width: width,
        height: height,
        radius: radius,
        child: _mockupContent(isDark: isDark),
      );
    }

    return _phoneShell(
      width: width,
      height: height,
      radius: radius,
      child: Stack(
        children: [
          ClipRect(
            clipper: _HalfClipper(right: false),
            child: _mockupContent(isDark: false),
          ),
          ClipRect(
            clipper: _HalfClipper(right: true),
            child: _mockupContent(isDark: true),
          ),
        ],
      ),
    );
  }

  Widget _phoneShell({
    required double width,
    required double height,
    required double radius,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 3),
        child: child,
      ),
    );
  }

  Widget _mockupContent({required bool isDark}) {
    final bg = isDark ? const Color(0xFF141414) : const Color(0xFFF2F2F5);
    final barColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.08);
    final dotColor = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.black.withValues(alpha: 0.15);

    Widget bar({required double width, Color? color}) => Container(
      height: 8,
      width: width,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: color ?? barColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );

    Widget dotRow() => Row(
      children: [
        _dot(dotColor: const Color(0xFF4CD97B)),
        const SizedBox(width: 4),
        _dot(dotColor: const Color(0xFFF2C94C)),
        const SizedBox(width: 4),
        _dot(dotColor: const Color(0xFFEB5757)),
      ],
    );

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(dotColor: dotColor, size: 5),
                const SizedBox(width: 3),
                _dot(dotColor: dotColor, size: 5),
              ],
            ),
          ),
          const SizedBox(height: 8),
          bar(width: 40, color: const Color(0xFFE0397C)),
          const SizedBox(height: 2),
          bar(width: 60, color: const Color(0xFFF2545B)),
          const SizedBox(height: 6),
          dotRow(),
          const SizedBox(height: 8),
          bar(width: 70),
          bar(width: 50),
          const SizedBox(height: 6),
          bar(width: 34, color: const Color(0xFF2F80ED)),
          const SizedBox(height: 2),
          bar(width: 48, color: const Color(0xFF2FC5D2)),
        ],
      ),
    );
  }

  Widget _dot({required Color dotColor, double size = 7}) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
  );
}

class _HalfClipper extends CustomClipper<Rect> {
  final bool right;
  _HalfClipper({required this.right});

  @override
  Rect getClip(Size size) {
    return right
        ? Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height)
        : Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
