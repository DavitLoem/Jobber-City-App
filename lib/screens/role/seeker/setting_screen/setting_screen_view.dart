import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';

part 'setting_screen_binding.dart';
part 'setting_screen_controller.dart';

class SettingScreenView extends GetView<SettingScreenViewController> {
  const SettingScreenView({super.key});

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
        child: Column(
          children: [
            _buildAppBar(context),
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
                      context,
                      icon: Icons.remove_red_eye_outlined,
                      title: 'Job Seeking Status'.tr,
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('ACCOUNT SECTION'.tr),
                    _buildSettingItem(
                      context,
                      icon: Icons.person_outline_rounded,
                      title: 'Personal Info'.tr,
                      onTap: () => Get.toNamed(
                        '/edit-profile',
                      )?.then((_) => controller.fetchProfileCompletion()),
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.swap_vert_rounded,
                      title: 'Linked Accounts'.tr,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildSectionTitle('GENERAL SECTION'.tr),
                    _buildSettingItem(
                      context,
                      icon: Icons.notifications_none_rounded,
                      title: 'Notification'.tr,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.work_outline_rounded,
                      title: 'Application Issues'.tr,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.verified_user_outlined,
                      title: 'Security'.tr,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.g_translate_rounded,
                      title: 'Language'.tr,
                      onTap: () => _showLanguageBottomSheet(),
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.remove_red_eye_outlined,
                      title: 'Appearance'.tr,
                      onTap: () => _showAppearanceBottomSheet(),
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: 'Help Center'.tr,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.people_outline_rounded,
                      title: 'Invite Friends'.tr,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.star_border_rounded,
                      title: 'Rate Us'.tr,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildSectionTitle('ABOUT SECTION'.tr),
                    _buildSettingItem(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy'.tr,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms of Service'.tr,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: 'About Us'.tr,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildSettingItem(
                      context,
                      icon: Icons.lock_outline_rounded,
                      title: 'Deactivate Account'.tr,
                      isDanger: true,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.logout_rounded,
                      title: 'Logout'.tr,
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

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Text(
            'Settings'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.textTheme.bodyLarge?.color,
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
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
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
                Text(
                  'Profile Completed'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete your profile to get better job recommendations'.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
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

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = isDanger ? AppColors.error : AppColors.primary;
    final bgColor = isDanger
        ? AppColors.error.withValues(alpha: 0.1)
        : (isDark ? AppColors.darkSurfaceElevated : AppColors.primaryLight);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                      color: isDanger
                          ? color
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDanger ? color : theme.hintColor,
                ),
              ],
            ),
          ),
        ),
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
                'Language'.tr,
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

  void _showLogoutDialog() {
    Get.dialog(
      Obx(() {
        final isDark = _isDark;
        final bgColor = isDark ? AppColors.darkSurface : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subTextColor = isDark
            ? AppColors.darkTextSecondary
            : Colors.black54;
        final borderColor = isDark
            ? AppColors.darkCardBorder
            : AppColors.cardBorder;

        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 32,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Log Out'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to log out from this account?'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
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
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: TextStyle(
                            color: textColor,
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
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Log Out'.tr,
                          style: const TextStyle(
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
        );
      }),
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
