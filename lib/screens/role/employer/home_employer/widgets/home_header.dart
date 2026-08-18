import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../home_employer_view.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeEmployerViewController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: Colors.transparent,
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
                            : Colors.white,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkCardBorder
                              : Colors.transparent,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: isDark ? 0.15 : 0.35, // 🟢 Updated opacity
                            ),
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
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    LucideIcons.building,
                                    color: Color(0xFF4f7df7),
                                  ),
                            )
                          : const Icon(
                              LucideIcons.building,
                              color: AppColors.primary,
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
                                : const Color(0xFF697386),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          companyName, // 🎯 បង្ហាញឈ្មោះពិតប្រាកដ
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.bodyLarge?.color,
                            height: 1.2,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              // Right: actions ទុកដដែល[cite: 7]
              Row(
                children: [
                  _RoundIconButton(
                    icon: LucideIcons.search,
                    iconColor: isDark
                        ? AppColors.darkTextSecondary
                        : const Color(0xFF697386),
                    isDark: isDark,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _RoundIconButton(
                    icon: LucideIcons.bell,
                    iconColor: theme.textTheme.bodyLarge?.color ?? Colors.black,
                    isDark: isDark,
                    onTap: () {},
                    showDot: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Here's your hiring overview today.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF697386),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    HomeEmployerViewController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Filter Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Presets
              _buildFilterOption("Today", () {
                controller.setQuickFilter("Today");
                Get.back();
              }),
              _buildFilterOption("This Week", () {
                controller.setQuickFilter("This Week");
                Get.back();
              }),
              _buildFilterOption("This Month", () {
                controller.setQuickFilter("This Month");
                Get.back();
              }),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Divider(color: Color(0xFFF3F4F6), height: 1),
              ),

              // Custom Month
              _buildFilterOption("Select Specific Month...", () async {
                Get.back();
                // បង្ហាញ DatePicker ឱ្យរើសថ្ងៃ រួចទាញយកតែខែ
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.setMonthFilter(picked);
                }
              }, icon: LucideIcons.calendar),

              // Custom Range
              _buildFilterOption("Custom Date Range...", () async {
                Get.back();
                // បង្ហាញ DateRangePicker
                DateTimeRange? range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) {
                  // កាត់យកទម្រង់ខ្លី ឧ. "Aug 15 - Aug 20"
                  controller.setQuickFilter(
                    "${range.start.day}/${range.start.month} - ${range.end.day}/${range.end.month}",
                  );
                }
              }, icon: LucideIcons.calendarRange),
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: const Color(0xFF697386)),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
  final bool isDark;

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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.3 : 0.07, // 🟢 Updated opacity
                ),
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
                      ),
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
