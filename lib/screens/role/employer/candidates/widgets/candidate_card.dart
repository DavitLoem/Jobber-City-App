import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/screens/role/employer/candidate_detail/widgets/cv_viewer_view.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../routes/app_routes.dart';
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
    // 🟢 ២. រុំកាតជាមួយ GestureDetector ដើម្បីចាប់ការចុច
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // 🟢 ៣. ផ្លាស់ប្តូរពណ៌ផ្ទៃ និងស៊ុមពេលកំពុង Select
          color: isSelected
              ? const Color(0xFF4f7df7).withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4f7df7) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── រូបថតបេក្ខជន ──
                Stack(
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
                    // 🟢 ៤. បង្ហាញសញ្ញា Checkbox លើរូបថតពេល Select
                    if (isSelected)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF4f7df7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(applicant.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Applied for: ${applicant.jobTitle.isNotEmpty ? applicant.jobTitle : 'Unknown Job'}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
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
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Applied: ${_formatDate(applicant.appliedAt)}",
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

            if (applicant.status.toLowerCase() == 'interview' &&
                applicant.interviewSchedule != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.calendarClock,
                      size: 16,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Interview: ${_formatInterviewDate(applicant.interviewSchedule!['date'])}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // 🟢 បន្ថែមប៊ូតុង Edit នៅទីនេះ
                    GestureDetector(
                      onTap: () {
                        // 🎯 បើក Modal សម្រាប់ Edit និងបញ្ជូនទិន្នន័យបេក្ខជនទៅឱ្យវា
                        Get.bottomSheet(
                          EditScheduleBottomSheet(applicant: applicant),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          LucideIcons.pencil,
                          size: 14,
                          color: Color(0xFF059669),
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
                ...applicant.skills.take(3).map((s) => _buildSkillChip(s)),
                if (applicant.yearsOfExperience > 0)
                  _buildSkillChip(
                    '${applicant.yearsOfExperience} Yrs Exp',
                    isHighlight: true,
                  ),
                if (applicant.skills.isEmpty &&
                    applicant.yearsOfExperience == 0)
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
                    icon: const Icon(
                      LucideIcons.fileText,
                      size: 16,
                    ), // បង្រួម Icon បន្តិច
                    label: const Text(
                      "View CV",
                      style: TextStyle(fontSize: 13),
                    ), // បង្រួមអក្សរបន្តិច
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
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
                const SizedBox(width: 8), // បង្រួញចន្លោះពី 12 មក 8
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
                        fontSize: 13, // បង្រួមអក្សរបន្តិច
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // បន្ថែមចន្លោះ
                // 🎯 ទីតាំងប៊ូតុង Chat ថ្មី
                InkWell(
                  onTap: () {
                    // ទាញយក Controller មកប្រើ
                    final controller = Get.find<CandidatesViewController>();
                    // ហៅអនុគមន៍ដោយបោះ Object applicant ទាំងមូលទៅឱ្យ
                    controller.startChatWithSeeker(applicant);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 44, // ទទឹងរាងការ៉េ
                    height: 44, // កម្ពស់ស្មើនឹងប៊ូតុងខាងលើ
                    decoration: BoxDecoration(
                      color: const Color(0xFF4f7df7).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF4f7df7).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.messageSquare, // រូបភាពសារ
                      color: Color(0xFF4f7df7),
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

  // ... (អនុគមន៍ជំនួយ _buildSkillChip, _buildStatusBadge, _formatDate, _formatInterviewDate រក្សាទុកដដែលដូចចាស់) ...
  Widget _buildSkillChip(String label, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFE0E7FF) : const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isHighlight
              ? const Color(0xFF3730A3)
              : const Color(0xFF4f7df7),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label = status.toUpperCase();

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        label = 'NEW';
        break;
      case 'shortlisted':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'interview':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'hired':
        bgColor = Colors.teal.shade50;
        textColor = Colors.teal.shade700;
        break;
      case 'rejected':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
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
    if (date == null) return "Unknown date";
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return "$diff days ago";
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
