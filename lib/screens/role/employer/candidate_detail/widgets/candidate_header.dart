import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CandidateHeader extends StatelessWidget {
  final ApplicantModel applicant;

  const CandidateHeader({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                applicant.profileImageUrl != null &&
                    applicant.profileImageUrl!.isNotEmpty
                ? NetworkImage(applicant.profileImageUrl!)
                : null,
            child:
                applicant.profileImageUrl == null ||
                    applicant.profileImageUrl!.isEmpty
                ? const Icon(LucideIcons.user, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            applicant.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Applied for: ${applicant.jobTitle}",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
