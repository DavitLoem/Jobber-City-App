import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/location_controller.dart';
import '../../../../core/api/services/role/employer/company_profile_services.dart';
import '../../../../models/role/employer/company_model.dart';

part 'employer_profile_binding.dart';
part 'employer_profile_controller.dart';

class EmployerProfileView extends GetView<EmployerProfileViewController> {
  const EmployerProfileView({super.key});

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
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Company Profile'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.alertCircle,
                  size: 48,
                  color: _isDark ? Colors.redAccent : Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: _isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchMyProfile,
                  child: Text('Retry'.tr), // 🟢 Added .tr
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(theme),
              const SizedBox(height: 20),
              _buildQuickStats(theme),
              const SizedBox(height: 24),
              _buildMenuSection(
                title: "General Settings".tr, // 🟢 Added .tr
                theme: theme,
                items: [
                  _buildMenuItem(
                    icon: LucideIcons.building2,
                    title: "Company Details".tr, // 🟢 Added .tr
                    theme: theme,
                    onTap: () {
                      Get.toNamed(AppRoutes.companyDetail);
                    },
                  ),
                  _buildMenuItem(
                    icon: LucideIcons.lock,
                    title: "Change Password".tr, // 🟢 Added .tr
                    theme: theme,
                    onTap: () {
                      Get.toNamed(AppRoutes.changePassword);
                    },
                  ),
                  _buildMenuItem(
                    icon: LucideIcons.bell,
                    title: "Notifications".tr, // 🟢 Added .tr
                    theme: theme,
                    onTap: () {
                      Get.toNamed(AppRoutes.notificationEmployer);
                    },
                  ),
                  _buildMenuItem(
                    icon: LucideIcons.palette,
                    title: "Appearance".tr, // 🟢 Added .tr
                    theme: theme,
                    onTap: () => _showAppearanceBottomSheet(),
                  ),
                  // 🟢 Added Language option directly into General Settings list
                  _buildMenuItem(
                    icon: LucideIcons.languages,
                    title: "Language".tr, // 🟢 Added .tr
                    theme: theme,
                    onTap: () => _showLanguageBottomSheet(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildMenuSection(
                title: "Support & Legal".tr, // 🟢 Added .tr
                theme: theme,
                items: [
                  _buildMenuItem(
                    icon: LucideIcons.helpCircle,
                    title: "Help Center & FAQ".tr, // 🟢 Added .tr
                    theme: theme,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: LucideIcons.shieldCheck,
                    title: "Terms & Privacy Policy".tr, // 🟢 Added .tr
                    theme: theme,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.find<AuthController>().logout();
                  },
                  icon: Icon(
                    LucideIcons.logOut,
                    color: _isDark
                        ? Colors.redAccent
                        : Colors.redAccent.shade400,
                  ),
                  label: Text(
                    "Log Out".tr, // 🟢 Added .tr
                    style: TextStyle(
                      color: _isDark
                          ? Colors.redAccent
                          : Colors.redAccent.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide(
                      color: _isDark
                          ? Colors.redAccent.shade700
                          : Colors.redAccent.shade100,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    final profile = controller.companyProfile.value;
    final companyName =
        profile?.companyName ?? 'Company Name'.tr; // 🟢 Added .tr
    final hasLogo = profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty;
    final isDark = _isDark;

    final industryName = controller.getIndustryName(profile?.industryId);
    final provinceName = controller.getProvinceName(profile?.provinceId);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.primary.withValues(
                              alpha: 0.8,
                            ), // 🟢 Updated
                            AppColors.primary.withValues(
                              alpha: 0.4,
                            ), // 🟢 Updated
                          ]
                        : [const Color(0xFF4f7df7), const Color(0xFF8faaf9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceElevated
                        : const Color(0xFFF0F4FF),
                    backgroundImage: hasLogo
                        ? NetworkImage(profile.logoUrl!)
                        : null,
                    child: hasLogo
                        ? null
                        : const Icon(
                            LucideIcons.building,
                            size: 40,
                            color: AppColors.primary,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                companyName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              if (profile?.isVerified == true) ...[
                const SizedBox(width: 6),
                const Icon(
                  LucideIcons.badgeCheck,
                  color: Colors.blue,
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$industryName • $provinceName",
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey.shade600,
            ),
          ),
          Text(
            "Company Size: @size".trParams({
              'size': profile?.companySize ?? 'N/A',
            }), // 🟢 Added .trParams
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.editProfileEmployer);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: Text(
              "Edit Profile".tr, // 🟢 Added .tr
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard("Active Jobs".tr, "15", theme), // 🟢 Added .tr
          const SizedBox(width: 16),
          _buildStatCard("Candidates".tr, "120", theme), // 🟢 Added .tr
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, ThemeData theme) {
    final isDark = _isDark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.2 : 0.05,
              ), // 🟢 Updated
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required ThemeData theme,
    required List<Widget> items,
  }) {
    final isDark = _isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextHint : Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.grey.shade100,
            ),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required ThemeData theme,
    required VoidCallback onTap,
    String? trailingText,
  }) {
    final isDark = _isDark;
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.15) // 🟢 Updated
              : const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          if (trailingText != null) const SizedBox(width: 8),
          Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: isDark ? AppColors.darkIconSecondary : Colors.grey.shade400,
          ),
        ],
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
            : Colors.grey.withValues(alpha: 0.3); // 🟢 Updated

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
                'Appearance'.tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your preferred color scheme'.tr, // 🟢 Added .tr
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThemeOption(
                    title: 'Light'.tr, // 🟢 Added .tr
                    mode: ThemeMode.light,
                    mockup: const _PhoneMockup(style: _MockupStyle.light),
                    isDark: isDark,
                  ),
                  _buildThemeOption(
                    title: 'Dark'.tr, // 🟢 Added .tr
                    mode: ThemeMode.dark,
                    mockup: const _PhoneMockup(style: _MockupStyle.dark),
                    isDark: isDark,
                  ),
                  _buildThemeOption(
                    title: 'System'.tr, // 🟢 Added .tr
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

  // 🟢 NEW: Language Bottom Sheet
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
                'Language'.tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your preferred language'.tr, // 🟢 Added .tr
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 32),

              _buildLanguageOption(
                title: 'English'.tr,
                langCode: 'en',
                countryCode: 'US',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                title: 'Khmer'.tr,
                langCode: 'km',
                countryCode: 'KH',
                isDark: isDark,
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
        onTap: () {
          controller.changeTheme(mode);
          Get.back();
        },
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
                      ? AppColors.primary.withValues(
                          alpha: 0.12,
                        ) // 🟢 Updated opacity
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

  Widget _buildLanguageOption({
    required String title,
    required String langCode,
    required String countryCode,
    required bool isDark,
  }) {
    final isSelected = Get.locale?.languageCode == langCode;

    final textActiveColor = isDark ? Colors.white : Colors.black87;
    final textInactiveColor = isDark
        ? AppColors.darkTextHint
        : AppColors.textHint;

    return InkWell(
      onTap: () {
        controller.changeLanguage(langCode, countryCode);
        Get.back(); // Closes the bottom sheet
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.5)
                : (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? textActiveColor : textInactiveColor,
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}

// Phone Mockups components
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
        ? Colors.white.withValues(alpha: 0.14) // 🟢 Updated opacity
        : Colors.black.withValues(alpha: 0.08); // 🟢 Updated opacity
    final dotColor = isDark
        ? Colors.white.withValues(alpha: 0.25) // 🟢 Updated opacity
        : Colors.black.withValues(alpha: 0.15); // 🟢 Updated opacity

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
