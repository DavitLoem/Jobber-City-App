import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CandidateInterview extends StatelessWidget {
  final ApplicantModel applicant;

  const CandidateInterview({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (applicant.status.toLowerCase() != 'interview' ||
        applicant.interviewSchedule == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Interview Details".tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.success.withValues(alpha: isDark ? 0.4 : 0.3),
            ),
          ),
          child: Column(
            children: [
              _buildInterviewRow(
                LucideIcons.calendarClock,
                "Date & Time".tr,
                _formatDate(applicant.interviewSchedule!['date']),
                isDark,
              ),
              const SizedBox(height: 12),
              _buildInterviewRow(
                LucideIcons.mapPin,
                "Location / Link".tr,
                applicant.interviewSchedule!['location'] ?? 'TBD'.tr,
                isDark,
              ),
              if (applicant.interviewSchedule!['message'] != null &&
                  applicant.interviewSchedule!['message']
                      .toString()
                      .isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 1,
                    color: isDark ? AppColors.darkDivider : Colors.black12,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      LucideIcons.messageSquare,
                      size: 18,
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        applicant.interviewSchedule!['message'],
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInterviewRow(
    IconData icon,
    String title,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkIconSecondary : Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'TBD'.tr;
    try {
      if (!dateStr.endsWith('Z')) dateStr += 'Z';
      final date = DateTime.parse(dateStr).toLocal();

      int hour12 = date.hour % 12;
      if (hour12 == 0) hour12 = 12;
      final String amPm = date.hour >= 12 ? 'PM'.tr : 'AM'.tr;
      final String minute = date.minute.toString().padLeft(2, '0');

      return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} at $hour12:$minute $amPm";
    } catch (_) {
      return dateStr?.split('T').first ?? 'TBD'.tr;
    }
  }
}
