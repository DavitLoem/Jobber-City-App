import 'package:flutter/material.dart';
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
    Color iconBgColor = const Color(0xFFEEF2FF);
    Color iconColor = const Color(0xFF4F7DF7);
    IconData iconData = LucideIcons.bell;

    // 🎯 ១. ទាញយក Type និង Message មកធ្វើជាអក្សរតូចទាំងអស់ ដើម្បីងាយស្រួលផ្ទៀងផ្ទាត់
    final String type = widget.notification.type.toLowerCase();
    final String message = widget.notification.message.toLowerCase();

    // 🎯 ២. កំណត់លក្ខខណ្ឌដ៏ឆ្លាតវៃតាមប្រភេទ និងអត្ថន័យនៃសារ
    if (type == 'new_application') {
      // មានអ្នកដាក់ពាក្យថ្មី (Employer)
      iconBgColor = const Color(0xFFEEF2FF); // លឿង/ខៀវខ្ចី
      iconColor = const Color(0xFF4F7DF7);
      iconData = LucideIcons.fileText;
    } else if (type == 'interview_update') {
      // ផ្លាស់ប្តូរថ្ងៃសម្ភាសន៍
      iconBgColor = const Color(0xFFF3E8FF); // ស្វាយស្រាល
      iconColor = const Color(0xFFA855F7);
      iconData = LucideIcons.calendarClock;
    } else if (type == 'status_update') {
      // 🎯 ឆែកមើលពាក្យគន្លឹះក្នុង Message សម្រាប់ Status នីមួយៗ
      if (message.contains('interview')) {
        iconBgColor = const Color(0xFFF3E8FF); // ស្វាយស្រាល
        iconColor = const Color(0xFFA855F7);
        iconData = LucideIcons.users;
      } else if (message.contains('hired') || message.contains('accepted')) {
        iconBgColor = const Color(0xFFF0FDF4); // បៃតងស្រាល
        iconColor = const Color(0xFF16A34A);
        iconData = LucideIcons.award;
      } else if (message.contains('rejected') ||
          message.contains('unsuccessful')) {
        iconBgColor = const Color(0xFFFEF2F2); // ក្រហមស្រាល
        iconColor = const Color(0xFFDC2626);
        iconData = LucideIcons.xCircle;
      } else if (message.contains('shortlisted')) {
        iconBgColor = const Color(0xFFFFF7ED); // ទឹកក្រូចស្រាល
        iconColor = const Color(0xFFEA580C);
        iconData = LucideIcons.bookmark;
      } else if (message.contains('reviewed')) {
        iconBgColor = const Color(0xFFF0F9FF); // ខៀវស្រាល
        iconColor = const Color(0xFF0284C7);
        iconData = LucideIcons.eye;
      } else {
        // Default Pending ឬ Status ផ្សេងៗ
        iconBgColor = const Color(0xFFF8FAFC); // ប្រផេះស្រាល
        iconColor = const Color(0xFF64748B);
        iconData = LucideIcons.refreshCcw;
      }
    } else if (type == 'system_alert') {
      iconBgColor = const Color(0xFFFEF2F2);
      iconColor = const Color(0xFFDC2626);
      iconData = LucideIcons.alertTriangle;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ), // 🟢 ធ្វើឱ្យកោងល្មមស្អាត (Minimal)
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.0,
        ), // 🟢 ស៊ុមស្តើងជាងមុនបន្តិច
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
          onTap: widget.onTap,
          child: Padding(
            // 🎯 កែប្រែ Padding ឱ្យហាប់ណែនល្អ ពេលវាកំពុងបិទ (បន្ថយ vertical ពី 16 មក 14)
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 46, // 🎯 បង្រួម Icon បន្តិចឱ្យស៊ីនឹងកម្ពស់អក្សរ
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
                            widget.notification.title,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B), // ពណ៌ខ្មៅស្រាល (Slate)
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
                              color: Colors.grey.shade500,
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
                          color: const Color(0xFF4F7DF7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "New",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // 🟢 ព្រួញត្រូវបានរៀបចំផ្ទៃចុចឱ្យសមរម្យ ការពារការចុចខុស
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
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),

                // 🎯 ពេលបិទ គឺលាក់បាត់ឈឹង, ពេលបើក គឺរុញចុះក្រោមយ៉ាងរលូន
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut, // ធ្វើឱ្យចលនាបិទបើកមានភាពទន់ភ្លន់
                  alignment: Alignment.topCenter,
                  child: _isExpanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            widget.notification.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
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

  // 🟢 អនុគមន៍បំប្លែងម៉ោង (Timezone Fix ដូចមុន)
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
    final month = months[localDate.month - 1];
    final year = localDate.year;

    int hourInt = localDate.hour;
    final ampm = hourInt >= 12 ? 'PM' : 'AM';
    if (hourInt > 12) hourInt -= 12;
    if (hourInt == 0) hourInt = 12;

    final hour = hourInt.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$day $month, $year | $hour:$minute $ampm';
  }
}
