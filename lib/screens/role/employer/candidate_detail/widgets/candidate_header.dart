import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CandidateHeader extends StatelessWidget {
  final ApplicantModel applicant;

  const CandidateHeader({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: isDark
                ? AppColors.darkInputBackground
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
                    size: 40,
                    color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            applicant.fullName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Applied for: @jobTitle".trParams({'jobTitle': applicant.jobTitle}),
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.blueAccent : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
