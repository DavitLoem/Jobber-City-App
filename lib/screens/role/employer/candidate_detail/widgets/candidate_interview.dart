import 'package:flutter/material.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CandidateInterview extends StatelessWidget {
  final ApplicantModel applicant;

  const CandidateInterview({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    // បង្ហាញកាតនេះ លុះត្រាតែ Status គាត់គឺ interview និងមានទិន្នន័យ
    if (applicant.status.toLowerCase() != 'interview' ||
        applicant.interviewSchedule == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Interview Details",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              _buildInterviewRow(
                LucideIcons.calendarClock,
                "Date & Time",
                _formatDate(applicant.interviewSchedule!['date']),
              ),
              const SizedBox(height: 12),
              _buildInterviewRow(
                LucideIcons.mapPin,
                "Location / Link",
                applicant.interviewSchedule!['location'] ?? 'TBD',
              ),
              if (applicant.interviewSchedule!['message'] != null &&
                  applicant.interviewSchedule!['message']
                      .toString()
                      .isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Colors.black12),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      LucideIcons.messageSquare,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        applicant.interviewSchedule!['message'],
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInterviewRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // អនុគមន៍កាត់ម៉ោង UTC ឱ្យចេញរាងស្អាតបន្តិច
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'TBD';
    try {
      if (!dateStr.endsWith('Z')) dateStr += 'Z';
      final date = DateTime.parse(dateStr).toLocal();

      // បំប្លែងម៉ោងទៅជាទម្រង់ 12 ម៉ោង និងរក AM/PM
      int hour12 = date.hour % 12;
      if (hour12 == 0) hour12 = 12;
      final String amPm = date.hour >= 12 ? 'PM' : 'AM';
      final String minute = date.minute.toString().padLeft(2, '0');

      return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} at $hour12:$minute $amPm";
    } catch (_) {
      return dateStr?.split('T').first ?? 'TBD';
    }
  }
}
