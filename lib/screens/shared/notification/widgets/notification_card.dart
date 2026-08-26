import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../models/notification_model.dart';

class NotificationCard extends StatefulWidget {
  final NotificationItemModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    Color baseColor = AppColors.primary;
    IconData iconData = LucideIcons.bell;

    // 🎯 ១. ទាញយក Type និង Message មកធ្វើជាអក្សរតូចទាំងអស់ ដើម្បីងាយស្រួលផ្ទៀងផ្ទាត់
    final String type = widget.notification.type.toLowerCase();
    final String message = widget.notification.message.toLowerCase();

    // 🎯 ២. កំណត់លក្ខខណ្ឌដ៏ឆ្លាតវៃតាមប្រភេទ និងអត្ថន័យនៃសារ
    // 🟢 Refactored to calculate Base Color once, allowing clean alpha adjustments for Dark Mode support
    if (type == 'new_application') {
      baseColor = AppColors.primary;
      iconData = LucideIcons.fileText;
    } else if (type == 'interview_update') {
      baseColor = const Color(0xFFA855F7); // Purple
      iconData = LucideIcons.calendarClock;
    } else if (type == 'status_update') {
      if (message.contains('interview')) {
        baseColor = const Color(0xFFA855F7);
        iconData = LucideIcons.users;
      } else if (message.contains('hired') || message.contains('accepted')) {
        baseColor = AppColors.success;
        iconData = LucideIcons.award;
      } else if (message.contains('rejected') ||
          message.contains('unsuccessful')) {
        baseColor = AppColors.error;
        iconData = LucideIcons.xCircle;
      } else if (message.contains('shortlisted')) {
        baseColor = const Color(0xFFEA580C); // Orange
        iconData = LucideIcons.bookmark;
      } else if (message.contains('reviewed')) {
        baseColor = const Color(0xFF0284C7); // Light Blue
        iconData = LucideIcons.eye;
      } else {
        baseColor = const Color(0xFF64748B); // Slate
        iconData = LucideIcons.refreshCcw;
      }
    } else if (type == 'system_alert') {
      baseColor = AppColors.error;
      iconData = LucideIcons.alertTriangle;
    }

    // 🟢 Derive the background block and icon color automatically based on Theme
    final Color iconBgColor = baseColor.withValues(alpha: isDark ? 0.2 : 0.1);
    final Color iconColor = baseColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : Colors.grey.shade200, // 🟢 Dynamic Border
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.2 : 0.02,
            ), // 🟢 Dynamic Shadow
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
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconData, color: iconColor, size: 22),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget
                                .notification
                                .title
                                .tr, // 🟢 Apply translations if Title maps match backend definitions
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B), // 🟢 Dynamic Title
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDateTime(widget.notification.createdAt),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : Colors
                                        .grey
                                        .shade500, // 🟢 Dynamic Date String
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!widget.notification.isRead)
                      Container(
                        margin: const EdgeInsets.only(left: 6, right: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "New".tr, // 🟢 Added .tr
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 8,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: 18,
                          color: isDark
                              ? AppColors.darkIconSecondary
                              : Colors.grey.shade400, // 🟢 Dynamic Chevron
                        ),
                      ),
                    ),
                  ],
                ),

                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: _isExpanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            widget
                                .notification
                                .message
                                .tr, // 🟢 Apply translations if messages match backend enums
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : Colors
                                        .grey
                                        .shade600, // 🟢 Dynamic Message text
                              height: 1.5,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '';

    DateTime utcDate = date;
    if (!date.isUtc) {
      utcDate = DateTime.utc(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
      );
    }

    final localDate = utcDate.toLocal();

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = localDate.day.toString().padLeft(2, '0');
    final month =
        months[localDate.month - 1].tr; // 🟢 Added .tr to Month String
    final year = localDate.year;

    int hourInt = localDate.hour;
    final ampm = hourInt >= 12 ? 'PM'.tr : 'AM'.tr; // 🟢 Added .tr
    if (hourInt > 12) hourInt -= 12;
    if (hourInt == 0) hourInt = 12;

    final hour = hourInt.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$day $month, $year | $hour:$minute $ampm';
  }
}
