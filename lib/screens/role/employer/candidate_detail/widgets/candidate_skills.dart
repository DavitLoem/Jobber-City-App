import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';

class CandidateSkills extends StatelessWidget {
  final ApplicantModel applicant;

  const CandidateSkills({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Skills & Experience",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (applicant.yearsOfExperience > 0)
              _buildChip(
                "${applicant.yearsOfExperience} Yrs Exp",
                isHighlight: true,
              ),
            ...applicant.skills.map((s) => _buildChip(s)),
            if (applicant.skills.isEmpty && applicant.yearsOfExperience == 0)
              Text(
                "No specific skills provided.",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFE0E7FF) : const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: isHighlight ? const Color(0xFF3730A3) : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
