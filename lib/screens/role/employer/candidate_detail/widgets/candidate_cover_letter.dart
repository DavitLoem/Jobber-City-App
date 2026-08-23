import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // តម្រូវតាមទីតាំងជាក់ស្តែង

class CandidateCoverLetter extends StatelessWidget {
  final String? coverLetterText;
  final String? coverLetterUrl;
  final String? coverLetterFilename;
  final VoidCallback? onTapFile;

  const CandidateCoverLetter({
    super.key,
    this.coverLetterText,
    this.coverLetterUrl,
    this.coverLetterFilename,
    this.onTapFile,
  });

  @override
  Widget build(BuildContext context) {
    final hasText =
        coverLetterText != null && coverLetterText!.trim().isNotEmpty;
    final hasFile = coverLetterUrl != null && coverLetterUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cover Letter",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // បើគ្មានទាំងអត្ថបទ គ្មានទាំងឯកសារ
        if (!hasText && !hasFile)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              "No cover letter provided.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        // 🎯 ១. បង្ហាញឯកសារ (File) បើមាន
        if (hasFile) ...[
          GestureDetector(
            onTap: onTapFile,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.description_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coverLetterFilename != null &&
                                  coverLetterFilename!.isNotEmpty
                              ? coverLetterFilename!
                              : "Attached Cover Letter",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Tap to view document",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.open_in_new_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (hasText) const SizedBox(height: 12), // ដកឃ្លាបើមានអត្ថបទបន្តទៀត
        ],

        // 🎯 ២. បង្ហាញអត្ថបទ (Text) បើមាន
        if (hasText)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              coverLetterText!,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
          ),
      ],
    );
  }
}
