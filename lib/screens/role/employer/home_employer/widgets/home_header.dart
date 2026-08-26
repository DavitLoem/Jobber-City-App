import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/routes/app_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../controllers/notification_controller.dart';
import '../home_employer_view.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeEmployerViewController());
    final NotificationController notifController =
        Get.find<NotificationController>();

    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: Colors.transparent, // 🟢 Inherits Scaffold Background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Logo + greeting
              Obx(() {
                final profile = controller.companyProfile.value;
                final companyName =
                    profile?.companyName ?? 'Company Name'.tr; // 🟢 Added .tr
                final hasLogo =
                    profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty;

                return Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isDark
                            ? AppColors.darkSurfaceElevated
                            : Colors.white, // 🟢 Dynamic BG
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.transparent
                                : const Color(0xFF4F7DF7).withValues(
                                    alpha: 0.35,
                                  ), // 🟢 Dynamic Shadow
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      child: hasLogo
                          ? Image.network(
                              profile.logoUrl!,
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            )
                          : Icon(
                              LucideIcons.building,
                              color: isDark
                                  ? Colors.blueAccent
                                  : const Color(
                                      0xFF4f7df7,
                                    ), // 🟢 Dynamic Placeholder Icon
                            ),
                    ),
                    const SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome back,".tr, // 🟢 Added .tr
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : const Color(
                                    0xFF697386,
                                  ), // 🟢 Dynamic Welcome Note
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          companyName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme
                                .textTheme
                                .bodyLarge
                                ?.color, // 🟢 Dynamic Company Name
                            height: 1.2,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              // Right: actions
              Row(
                children: [
                  _RoundIconButton(
                    icon: LucideIcons.search,
                    iconColor: isDark
                        ? AppColors.darkIconSecondary
                        : const Color(0xFF697386), // 🟢 Dynamic Search Icon
                    isDark: isDark,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => _RoundIconButton(
                      icon: LucideIcons.bell,
                      iconColor: isDark
                          ? Colors.white
                          : const Color(0xFF1A1F36), // 🟢 Dynamic Bell Icon
                      isDark: isDark,
                      onTap: () {
                        Get.toNamed(AppRoutes.notificationEmployer);
                      },
                      showDot: notifController.hasUnread,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── ផ្នែកដែលបានបន្ថែមថ្មី: Interactive Filter Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Overview".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 18,
                  color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Header
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 🟢 Filter Pill with Arrows
              Obx(
                () => Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInputBackground
                        : const Color(0xFFF3F4F6), // 🟢 Dynamic Pill BG
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.transparent,
                    ), // 🟢 Clean Outline
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.isMonthFilter.value)
                        GestureDetector(
                          onTap: controller.prevMonth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Icon(
                              LucideIcons.chevronLeft,
                              size: 16,
                              color: isDark
                                  ? AppColors.darkIconSecondary
                                  : const Color(
                                      0xFF697386,
                                    ), // 🟢 Dynamic Prev Arrow
                            ),
                          ),
                        ),

                      GestureDetector(
                        onTap: () => _showFilterBottomSheet(
                          context,
                          controller,
                          isDark,
                        ), // 🟢 Passed Theme Check
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: controller.isMonthFilter.value ? 4 : 14,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                controller
                                    .filterLabel
                                    .value
                                    .tr, // 🟢 Added .tr for mapped string like 'Today' or custom translation logic
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.blueAccent
                                      : const Color(
                                          0xFF4F7DF7,
                                        ), // 🟢 Dynamic Text
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                LucideIcons.chevronDown,
                                size: 14,
                                color: isDark
                                    ? Colors.blueAccent
                                    : const Color(
                                        0xFF4F7DF7,
                                      ), // 🟢 Dynamic Icon
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (controller.isMonthFilter.value)
                        GestureDetector(
                          onTap: controller.nextMonth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: isDark
                                  ? AppColors.darkIconSecondary
                                  : const Color(
                                      0xFF697386,
                                    ), // 🟢 Dynamic Next Arrow
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    HomeEmployerViewController controller,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.darkBackground
          : Colors.white, // 🟢 Dynamic Sheet BG
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Filter Dashboard".tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.black87, // 🟢 Dynamic Title
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Presets
              _buildFilterOption("Today".tr, () {
                // 🟢 Added .tr
                controller.setQuickFilter("Today");
                Get.back();
              }, isDark: isDark),
              _buildFilterOption("This Week".tr, () {
                // 🟢 Added .tr
                controller.setQuickFilter("This Week");
                Get.back();
              }, isDark: isDark),
              _buildFilterOption("This Month".tr, () {
                // 🟢 Added .tr
                controller.setQuickFilter("This Month");
                Get.back();
              }, isDark: isDark),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Divider(
                  color: isDark
                      ? AppColors.darkDivider
                      : const Color(0xFFF3F4F6),
                  height: 1,
                ), // 🟢 Dynamic Divider
              ),

              // Custom Month
              _buildFilterOption(
                "Select Specific Month...".tr,
                () async {
                  // 🟢 Added .tr
                  Get.back();
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    controller.setMonthFilter(picked);
                  }
                },
                icon: LucideIcons.calendar,
                isDark: isDark,
              ),

              // Custom Range
              _buildFilterOption(
                "Custom Date Range...".tr,
                () async {
                  // 🟢 Added .tr
                  Get.back();
                  DateTimeRange? range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (range != null) {
                    controller.setQuickFilter(
                      "${range.start.day}/${range.start.month} - ${range.end.day}/${range.end.month}",
                    );
                  }
                },
                icon: LucideIcons.calendarRange,
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
    String label,
    VoidCallback onTap, {
    IconData? icon,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isDark
                    ? AppColors.darkIconSecondary
                    : const Color(0xFF697386),
              ), // 🟢 Dynamic List Icon
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic List Text
              ),
            ),
          ],
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
  final bool isDark; // 🟢 Pass Theme State

  const _RoundIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.showDot = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // 🟢 Clean transparent backing
      borderRadius: BorderRadius.circular(13),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : Colors.white, // 🟢 Dynamic Action Pill BG
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.transparent,
            ), // 🟢 Edge highlight for dark UI
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.3 : 0.07,
                ), // 🟢 Dynamic Shadow
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
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkSurfaceElevated
                            : Colors.white,
                        width: 1.5,
                      ), // 🟢 Dynamic Cutout
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
