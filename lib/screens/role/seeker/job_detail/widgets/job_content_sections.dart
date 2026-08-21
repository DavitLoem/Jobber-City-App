import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../job_detail_view.dart';

class JobContentSections extends GetView<JobDetailController> {
  const JobContentSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final job = controller.job.value;
      if (job == null) return const Center(child: CircularProgressIndicator());

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎯 ១. កែសម្រួល Grid មកនៅត្រឹម ៤ ប្រអប់ (ទាញឱ្យវារាងវែងដូចប៊ូតុង)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5, // ធ្វើឱ្យប្រអប់មានរាងផ្តេក (Horizontal)
            children: [
              _statChip(
                icon: Icons.payments_rounded,
                label: "\$${job.minSalary} - \$${job.maxSalary}",
                highlight: true,
              ),
              _statChip(
                icon: Icons.work_outline_rounded,
                label: job.employmentType,
              ),
              _statChip(icon: Icons.apartment_rounded, label: job.workType),
              _statChip(
                icon: Icons.badge_rounded,
                label: job.experience.isNotEmpty ? job.experience : "Any Exp",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🎯 ២. បន្ថែមកាតថ្មីដែលរៀបចំបញ្ជីដូចទៅនឹង Employer View
          _buildJobInfoCard(job),

          const SizedBox(height: 18),
          _buildSectionTitle("Job Description"),
          const SizedBox(height: 8),
          _buildTextList(job.description),

          const SizedBox(height: 24),
          _buildSectionTitle("Requirements"),
          const SizedBox(height: 10),
          _buildTextList(job.requirements),

          const SizedBox(height: 24),
          _buildSectionTitle("Benefits"),
          const SizedBox(height: 12),
          _buildBenefits(job.benefits),
        ],
      );
    });
  }

  // 🎯 កែសម្រួល Chip ឱ្យបង្ហាញ Icon និង Text ទន្ទឹមគ្នា (Row)
  Widget _statChip({
    required IconData icon,
    required String label,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primaryLight
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight ? AppColors.primary : AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🎯 ៣. កាតបង្ហាញព័ត៌មានលម្អិត
  Widget _buildJobInfoCard(dynamic job) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // ពណ៌ប្រផេះស្រាល
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _infoRow(
            Icons.calendar_month_rounded,
            "Working Days",
            job.workingDays,
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.access_time_rounded,
            "Working Hours",
            job.workingHours ?? "N/A",
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.people_alt_rounded,
            "Headcount",
            "${job.headcount} Position(s)",
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.history_rounded,
            "Posted Date",
            _formatDate(job.createdAt),
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.event_busy_rounded,
            "Closing Date",
            _formatDate(job.closingDate),
            isAlert: true,
          ),
        ],
      ),
    );
  }

  // 🎯 Widget ជំនួយសម្រាប់គូរជួរនីមួយៗនៅក្នុងកាត
  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool isAlert = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 13.5, color: AppColors.textTertiary),
        ),
        const Spacer(),
        Text(
          value.isNotEmpty ? value : "N/A",
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isAlert ? Colors.redAccent : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // 🎯 អនុគមន៍កាត់យកតែថ្ងៃខែឆ្នាំ (YYYY-MM-DD)
  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";

    // បំប្លែង DateTime ទៅជាទម្រង់ YYYY-MM-DD
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextList(List<String> items) {
    if (items.isEmpty) {
      return const Text(
        "No details provided.",
        style: TextStyle(color: AppColors.textTertiary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBenefits(List<String> benefits) {
    if (benefits.isEmpty) {
      return const Text(
        "No specific benefits.",
        style: TextStyle(color: AppColors.textTertiary),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: benefits.map((benefit) {
        return Container(
          constraints: BoxConstraints(maxWidth: Get.width - 40),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.successBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  benefit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
