import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';

class CandidateSkills extends StatelessWidget {
  final ApplicantModel applicant;

  const CandidateSkills({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Skills & Experience".tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (applicant.yearsOfExperience > 0)
              _buildChip(
                "@exp Yrs Exp".trParams({
                  'exp': applicant.yearsOfExperience.toString(),
                }),
                isDark,
                isHighlight: true,
              ),
            ...applicant.skills.map((s) => _buildChip(s, isDark)),
            if (applicant.skills.isEmpty && applicant.yearsOfExperience == 0)
              Text(
                "No specific skills provided.".tr,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isDark, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight
            ? (isDark
                  ? const Color(0xFF3730A3).withValues(alpha: 0.3)
                  : const Color(0xFFE0E7FF))
            : (isDark
                  ? AppColors.darkInputBackground
                  : const Color(0xFFF0F4FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: isHighlight
              ? (isDark ? const Color(0xFF818CF8) : const Color(0xFF3730A3))
              : (isDark ? Colors.blueAccent : AppColors.primary),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
