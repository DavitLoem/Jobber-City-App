import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Logo + greeting[cite: 11]
              Obx(() {
                final profile = controller.companyProfile.value;
                final companyName = profile?.companyName ?? 'Company Name';
                final hasLogo =
                    profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty;

                return Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4F7DF7,
                            ).withValues(alpha: 0.35),
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
                          : const Icon(
                              LucideIcons.building,
                              color: Color(0xFF4f7df7),
                            ),
                    ),
                    const SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Welcome back,",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF697386),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          companyName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1F36),
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
                    iconColor: const Color(0xFF697386),
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => _RoundIconButton(
                      icon: LucideIcons.bell,
                      iconColor: const Color(0xFF1A1F36),
                      onTap: () {
                        // លោតទៅកាន់ទំព័រ Notification
                        Get.toNamed(AppRoutes.notification);
                      },
                      // 🎯 កំណត់លក្ខខណ្ឌទីនេះ៖ បើមានសារមិនទាន់អាន (hasUnread == true) វានឹងបង្ហាញ Dot
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
              const Text(
                "Overview",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1A1F36),
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 🟢 Filter Pill with Arrows
              Obx(
                () => Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.isMonthFilter.value)
                        GestureDetector(
                          onTap: controller.prevMonth,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Icon(
                              LucideIcons.chevronLeft,
                              size: 16,
                              color: Color(0xFF697386),
                            ),
                          ),
                        ),

                      GestureDetector(
                        onTap: () =>
                            _showFilterBottomSheet(context, controller),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: controller.isMonthFilter.value ? 4 : 14,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                controller.filterLabel.value,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4F7DF7),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                LucideIcons.chevronDown,
                                size: 14,
                                color: Color(0xFF4F7DF7),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (controller.isMonthFilter.value)
                        GestureDetector(
                          onTap: controller.nextMonth,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: Color(0xFF697386),
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

  const _RoundIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
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
