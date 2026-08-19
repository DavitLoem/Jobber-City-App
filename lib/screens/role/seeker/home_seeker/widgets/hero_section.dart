import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/notification_controller.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../home_seeker_view.dart'; // សម្រាប់ទាញយក Controller
import 'avatar_tap_scale.dart';
import 'shimmer_box.dart';

class HeroSection extends GetView<HomeSeekerViewController> {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, topInset + 18, 20, 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.78),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _buildHeroTopRow(),
        ),
        Positioned(left: 20, right: 20, bottom: -28, child: _buildSearchBar()),
      ],
    );
  }

  Widget _buildHeroTopRow() {
    final NotificationController notifController =
        Get.find<NotificationController>();
    return Row(
      children: [
        AvatarTapScale(
          onTap: () => Get.toNamed(
            '/edit-profile',
          )?.then((_) => controller.fetchProfileRaw()),
          child: Obx(() {
            if (controller.isLoadingProfile.value) {
              return const ShimmerBox(
                width: 54,
                height: 54,
                borderRadius: 27,
                baseColor: Color(0x40FFFFFF),
              );
            }
            return Container(
              width: 54,
              height: 54,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.6,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  child: controller.profileImageUrl.value.isNotEmpty
                      ? Image.network(
                          controller.profileImageUrl.value,
                          width: 49,
                          height: 49,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildUserFallback(),
                        )
                      : _buildUserFallback(),
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingProfile.value) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: 90,
                    height: 12,
                    borderRadius: 6,
                    baseColor: Color(0x40FFFFFF),
                  ),
                  SizedBox(height: 8),
                  ShimmerBox(
                    width: 150,
                    height: 16,
                    borderRadius: 6,
                    baseColor: Color(0x40FFFFFF),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.getGreeting()} 👋",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.firstName.value.isNotEmpty
                      ? "${controller.lastName.value} ${controller.firstName.value}"
                      : "Guest",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }),
        ),
        Obx(
          () => _RoundIconButton(
            icon: LucideIcons.bell,
            iconColor: Colors.white,
            onTap: () {
              // លោតទៅកាន់ទំព័រ Notification
              Get.toNamed(AppRoutes.notification);
            },
            // 🎯 កំណត់លក្ខខណ្ឌទីនេះ៖ បើមានសារមិនទាន់អាន (hasUnread == true) វានឹងបង្ហាញ Dot
            showDot: notifController.hasUnread,
          ),
        ),
      ],
    );
  }

  Widget _buildUserFallback() {
    if (controller.firstName.value.isNotEmpty) {
      return Center(
        child: Text(
          controller.firstName.value[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.person_rounded, size: 26, color: AppColors.primary),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.search),
      child: Hero(
        tag: 'search_bar_hero',
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 52, // កំណត់កម្ពស់ឱ្យស្មើគ្នា
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.textHint, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search for a job or Company...',
                    style: TextStyle(color: AppColors.textHint, fontSize: 14.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool showDot;

  const _RoundIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(13),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 20, color: iconColor),
              if (showDot)
                Positioned(
                  top: 9,
                  right: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEF4444),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
