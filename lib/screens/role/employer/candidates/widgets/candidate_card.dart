import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/candidate_detail_view.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/widgets/cv_viewer_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CandidateCard extends StatelessWidget {
  final ApplicantModel applicant;
  const CandidateCard({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.2 : 0.02, // 🟢 Updated opacity
            ), // 🟢 Adjusted shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.grey.shade200,
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.fullName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Applied: @date".trParams({
                        'date': _formatDate(applicant.appliedAt),
                      }), // 🟢 Added .trParams
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (applicant.yearsOfExperience > 0)
                _buildSkillChip(
                  "@years Yrs Exp".trParams({
                    'years': applicant.yearsOfExperience.toString(),
                  }),
                  isDark,
                  isHighlight: true,
                ),
              ...applicant.skills
                  .take(3)
                  .map((s) => _buildSkillChip(s, isDark)),
              if (applicant.skills.length > 3)
                _buildSkillChip("+${applicant.skills.length - 3}", isDark),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
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
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade200,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "CV",
                  ), // Usually no translation needed for CV
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const CandidateDetailView(),
                      arguments: applicant,
                    );
                  },
                  style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                  ? const Color(0xFFE0E7FF).withValues(
                      alpha: 0.1,
                    ) // 🟢 Updated opacity
                  : const Color(0xFFE0E7FF))
            : (isDark
                  ? AppColors.darkSurfaceElevated
                  : const Color(0xFFF0F4FF)), // 🟢 Dynamic Chip BG
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isHighlight
              ? (isDark ? Colors.indigoAccent : const Color(0xFF3730A3))
              : AppColors.primary, // 🟢 Dynamic Chip Text
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date".tr; // 🟢 Added .tr
    return "${date.day}/${date.month}/${date.year}";
  }
}
