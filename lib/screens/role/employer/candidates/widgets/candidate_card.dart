import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/widgets/cv_viewer_view.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../routes/app_routes.dart';
import 'edit_schedule_bottom_sheet.dart';

class CandidateCard extends StatelessWidget {
  final ApplicantModel applicant;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CandidateCard({
    super.key,
    required this.applicant,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(
                  alpha: isDark ? 0.15 : 0.05,
                ) // 🟢 Dynamic Highlight
              : (isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.white), // 🟢 Dynamic Base BG
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200), // 🟢 Dynamic Border
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.2 : 0.02,
              ), // 🟢 Dynamic Shadow
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark
                          ? AppColors.darkInputBackground
                          : Colors.grey.shade200, // 🟢 Dynamic Avatar BG
                      backgroundImage:
                          applicant.profileImageUrl != null &&
                              applicant.profileImageUrl!.isNotEmpty
                          ? NetworkImage(applicant.profileImageUrl!)
                          : null,
                      child:
                          applicant.profileImageUrl == null ||
                              applicant.profileImageUrl!.isEmpty
                          ? Icon(
                              LucideIcons.user,
                              color: isDark
                                  ? AppColors.darkIconSecondary
                                  : Colors.grey,
                            )
                          : null,
                    ),
                    if (isSelected)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkSurfaceElevated
                                  : Colors.white,
                              width: 2,
                            ), // Clean outline
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              applicant.fullName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black87, // 🟢 Dynamic Text
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(
                            applicant.status,
                            isDark,
                          ), // 🟢 Passed Theme State
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Applied for: @job".trParams({
                          'job': applicant.jobTitle.isNotEmpty
                              ? applicant.jobTitle
                              : 'Unknown Job'.tr,
                        }), // 🟢 Added .trParams
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.grey.shade600, // 🟢 Dynamic Subtext
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendar,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : Colors.grey.shade400, // 🟢 Dynamic Sub-icon
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Applied: @date".trParams({
                              'date': _formatDate(applicant.appliedAt),
                            }), // 🟢 Added .trParams
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : Colors.grey.shade500, // 🟢 Dynamic Subtext
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (applicant.status.toLowerCase() == 'interview' &&
                applicant.interviewSchedule != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(
                    alpha: isDark ? 0.15 : 0.05,
                  ), // 🟢 Dynamic BG Opacity
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.success.withValues(
                      alpha: isDark ? 0.4 : 0.3,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.calendarClock,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Interview: @date".trParams({
                          'date': _formatInterviewDate(
                            applicant.interviewSchedule!['date'],
                          ),
                        }), // 🟢 Added .trParams
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          EditScheduleBottomSheet(applicant: applicant),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          LucideIcons.pencil,
                          size: 14,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...applicant.skills
                    .take(3)
                    .map((s) => _buildSkillChip(s, isDark)),
                if (applicant.yearsOfExperience > 0)
                  _buildSkillChip(
                    '@exp Yrs Exp'.trParams({
                      'exp': applicant.yearsOfExperience.toString(),
                    }), // 🟢 Added .trParams
                    isDark,
                    isHighlight: true,
                  ),
                if (applicant.skills.isEmpty &&
                    applicant.yearsOfExperience == 0)
                  Text(
                    "No skills or experience provided".tr, // 🟢 Added .tr
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : Colors.grey.shade400, // 🟢 Dynamic Subtext
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                thickness: 1,
                color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
              ), // 🟢 Dynamic Divider
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        applicant.resumeUrl != null &&
                            applicant.resumeUrl!.isNotEmpty
                        ? () {
                            Get.to(
                              () => CvViewerView(
                                pdfUrl: applicant.resumeUrl!,
                                candidateName: applicant.fullName,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(LucideIcons.fileText, size: 16),
                    label: Text(
                      "View CV".tr, // 🟢 Added .tr
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: applicant.resumeUrl != null
                            ? AppColors.primary
                            : (isDark
                                  ? AppColors.darkCardBorder
                                  : Colors.grey), // 🟢 Dynamic Border
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.candidateDetail,
                        arguments: applicant.applicationId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "View Profile".tr, // 🟢 Added .tr
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    final controller = Get.find<CandidatesViewController>();
                    controller.startChatWithSeeker(applicant);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? 0.15 : 0.1,
                      ), // 🟢 Dynamic Opacity
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.messageSquare,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(
    String label,
    bool isDark, {
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlight
            ? (isDark
                  ? const Color(0xFF3730A3).withValues(alpha: 0.3)
                  : const Color(0xFFE0E7FF))
            : (isDark
                  ? AppColors.darkInputBackground
                  : const Color(0xFFF0F4FF)), // 🟢 Dynamic BG
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isHighlight
              ? (isDark ? const Color(0xFF818CF8) : const Color(0xFF3730A3))
              : (isDark
                    ? Colors.blueAccent
                    : AppColors.primary), // 🟢 Dynamic Text
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color bgColor;
    Color textColor;
    String label = status.toUpperCase();

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50;
        textColor = isDark ? Colors.orangeAccent : Colors.orange.shade700;
        label = 'NEW'.tr; // 🟢 Added .tr
        break;
      case 'shortlisted':
        bgColor = isDark
            ? Colors.blueAccent.withValues(alpha: 0.15)
            : Colors.blue.shade50;
        textColor = isDark ? Colors.blueAccent : Colors.blue.shade700;
        break;
      case 'interview':
        bgColor = isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green.shade50;
        textColor = isDark ? Colors.greenAccent : Colors.green.shade700;
        break;
      case 'hired':
        bgColor = isDark
            ? Colors.tealAccent.withValues(alpha: 0.15)
            : Colors.teal.shade50;
        textColor = isDark ? Colors.tealAccent : Colors.teal.shade700;
        break;
      case 'rejected':
        bgColor = isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50;
        textColor = isDark ? Colors.redAccent : Colors.red.shade700;
        break;
      default:
        bgColor = isDark ? AppColors.darkInputBackground : Colors.grey.shade100;
        textColor = isDark ? AppColors.darkTextSecondary : Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date".tr; // 🟢 Added .tr
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return "Today".tr; // 🟢 Added .tr
    if (diff == 1) return "Yesterday".tr; // 🟢 Added .tr
    return "@diff days ago".trParams({
      'diff': diff.toString(),
    }); // 🟢 Added .trParams
  }

  String _formatInterviewDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'TBD'.tr; // 🟢 Added .tr
    try {
      if (!dateStr.endsWith('Z')) dateStr += 'Z';
      final date = DateTime.parse(dateStr).toLocal();

      int hour12 = date.hour % 12;
      if (hour12 == 0) hour12 = 12;
      final String amPm = date.hour >= 12 ? 'PM'.tr : 'AM'.tr; // 🟢 Added .tr
      final String minute = date.minute.toString().padLeft(2, '0');

      return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} at $hour12:$minute $amPm";
    } catch (_) {
      return dateStr?.split('T').first ?? 'TBD'.tr;
    }
  }
}
