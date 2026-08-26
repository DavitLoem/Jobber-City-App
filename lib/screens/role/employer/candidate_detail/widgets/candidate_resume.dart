import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/widgets/cv_viewer_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CandidateResume extends StatelessWidget {
  final ApplicantModel applicant;

  const CandidateResume({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Resume / CV".tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.error.withValues(alpha: 0.15)
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.fileText,
                  color: isDark ? Colors.redAccent : Colors.red.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.resumeFilename != null &&
                              applicant.resumeFilename!.isNotEmpty
                          ? applicant.resumeFilename!
                          : "Applicant_Resume.pdf",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "PDF Document".tr,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
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
                  foregroundColor: isDark ? Colors.white : AppColors.primary,
                  side: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : AppColors.primary.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("View".tr),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
