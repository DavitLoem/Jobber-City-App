import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/candidate_detail_view.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/widgets/cv_viewer_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'edit_schedule_bottom_sheet.dart';

class CandidateCard extends StatelessWidget {
  final ApplicantModel applicant;
  // 🟢 ១. បន្ថែម Parameters ថ្មីសម្រាប់ Selection Mode
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (រូបថត និង ឈ្មោះ) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    applicant.profileImageUrl != null &&
                        applicant.profileImageUrl!.isNotEmpty
                    ? NetworkImage(applicant.profileImageUrl!)
                    : null,
                child:
                    applicant.profileImageUrl == null ||
                        applicant.profileImageUrl!.isEmpty
                    ? const Icon(LucideIcons.user, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Applied for: ${applicant.jobTitle.isNotEmpty ? applicant.jobTitle : 'Unknown Job'}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(applicant.appliedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── 🎯 ផ្នែក Skills និង Experience ជាមួយការការពារ ──
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // បង្ហាញជំនាញយ៉ាងច្រើន ៣ ប៉ុណ្ណោះ
              ...applicant.skills.take(3).map((s) => _buildSkillChip(s)),

              // បង្ហាញឆ្នាំបទពិសោធន៍ លុះត្រាតែធំជាង ០
              if (applicant.yearsOfExperience > 0)
                _buildSkillChip(
                  '${applicant.yearsOfExperience} Yrs Exp',
                  isHighlight: true,
                ),

              // បង្ហាញអត្ថបទនេះបើអត់មានទាំង២ទាល់តែសោះ
              if (applicant.skills.isEmpty && applicant.yearsOfExperience == 0)
                Text(
                  "No skills or experience provided",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ),

          // ── Actions (ប៊ូតុងខាងក្រោម) ──
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
                  icon: const Icon(LucideIcons.fileText, size: 18),
                  label: const Text("View CV"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4f7df7),
                    side: BorderSide(
                      color: applicant.resumeUrl != null
                          ? const Color(0xFF4f7df7)
                          : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // 🎯 ហៅទំព័រ Detail View ដោយប្រើ GetX
                    debugPrint("👉 Button View Profile Tapped!");
                    Get.to(
                      () => const CandidateDetailView(),
                      binding: BindingsBuilder(() {
                        Get.put(CandidateDetailViewController());
                      }),
                      arguments: applicant,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4f7df7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "View Profile",
                    style: TextStyle(
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

  // ជំនួយគូរ Chip
  Widget _buildSkillChip(String label, {bool isHighlight = false}) {
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

  // ជំនួយថ្ងៃខែ
  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date".tr; // 🟢 Added .tr
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatInterviewDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'TBD';
    try {
      if (!dateStr.endsWith('Z')) dateStr += 'Z';
      final date = DateTime.parse(dateStr).toLocal();
      return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr!.split('T').first;
    }
  }
}
