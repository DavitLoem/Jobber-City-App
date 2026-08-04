import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';

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
        GestureDetector(
          onTap: () => Get.find<AuthController>().logout(),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 22,
            ),
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
      child: Container(
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
        child: Row(
          children: [
            const SizedBox(width: 4),
            const Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Search for a job or Company...',
                  hintStyle: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 13.5,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
