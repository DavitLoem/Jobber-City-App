import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';

class EditProfileHeader extends StatelessWidget {
  const EditProfileHeader({super.key, required this.controller});

  final EditProfileScreenViewController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.primary.withValues(alpha: 0.15),
                  theme.scaffoldBackgroundColor,
                ]
              : [
                  AppColors.primaryLight.withValues(alpha: 0.55),
                  Colors.white,
                ], // 🟢 Dynamic BG Gradient
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceElevated
                        : Colors.white, // 🟢 Dynamic Btn BG
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : AppColors.cardBorder,
                    ), // 🟢 Dynamic Border
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Icon
                  ),
                ),
              ),
              Text(
                'Edit Profile'.tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 18),
          _buildAvatarHeader(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildAvatarHeader(ThemeData theme, bool isDark) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.7 + (0.3 * value.clamp(0.0, 1.0)),
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          );
        },
        child: Column(
          children: [
            _AvatarTapScale(
              onTap: controller.pickProfileImage,
              child: Obx(() {
                final imageUrl = controller.profileImageUrl.value;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.darkSurfaceElevated
                              : Colors.white, // 🟢 Dynamic Ring
                        ),
                        padding: const EdgeInsets.all(3),
                        child: ClipOval(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: ScaleTransition(scale: anim, child: child),
                            ),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    key: ValueKey(imageUrl),
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholderAvatar(isDark);
                                    },
                                  )
                                : _buildPlaceholderAvatar(isDark),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : Colors.white,
                            width: 2.5,
                          ), // 🟢 Dynamic Ring
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 12),

            AnimatedBuilder(
              animation: Listenable.merge([
                controller.firstNameCtrl,
                controller.lastNameCtrl,
              ]),
              builder: (context, _) {
                final fullName =
                    '${controller.lastNameCtrl.text} ${controller.firstNameCtrl.text}'
                        .trim();

                return Text(
                  fullName.isEmpty ? "Loading...".tr : fullName, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(bool isDark) {
    return Container(
      key: const ValueKey('avatar_placeholder'),
      width: 82,
      height: 82,
      color: isDark
          ? AppColors.primary.withValues(alpha: 0.15)
          : AppColors.primaryLight, // 🟢 Dynamic BG
      child: const Icon(
        Icons.person_rounded,
        size: 42,
        color: AppColors.primary,
      ),
    );
  }
}

class _AvatarTapScale extends StatefulWidget {
  const _AvatarTapScale({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_AvatarTapScale> createState() => _AvatarTapScaleState();
}

class _AvatarTapScaleState extends State<_AvatarTapScale> {
  double _scale = 1.0;

  void _setScale(double value) => setState(() => _scale = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setScale(0.92),
      onTapUp: (_) => _setScale(1.0),
      onTapCancel: () => _setScale(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
