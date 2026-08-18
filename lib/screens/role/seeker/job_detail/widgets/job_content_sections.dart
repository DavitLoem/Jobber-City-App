import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../job_detail_view.dart';

class JobContentSections extends GetView<JobDetailController> {
  const JobContentSections({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final job = controller.job.value;
      if (job == null) return const Center(child: CircularProgressIndicator());

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: [
              _statChip(
                icon: Icons.payments_rounded,
                label: "\$${job.minSalary} - \$${job.maxSalary}",
                highlight: true,
                isDark: isDark,
              ),
              _statChip(
                icon: Icons.work_outline_rounded,
                label: job.employmentType.tr, // 🟢 Added .tr
                isDark: isDark,
              ),
              _statChip(
                icon: Icons.apartment_rounded,
                label: job.workType.tr, // 🟢 Added .tr
                isDark: isDark,
              ),
              _statChip(
                icon: Icons.badge_rounded,
                label: job.experience.isNotEmpty
                    ? job.experience.tr
                    : "Any Exp".tr, // 🟢 Added .tr
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 16),
          _buildJobInfoCard(job, isDark),

          const SizedBox(height: 18),
          _buildSectionTitle("Job Description".tr, theme), // 🟢 Added .tr
          const SizedBox(height: 8),
          _buildTextList(job.description, isDark),

          const SizedBox(height: 24),
          _buildSectionTitle("Requirements".tr, theme), // 🟢 Added .tr
          const SizedBox(height: 10),
          _buildTextList(job.requirements, isDark),

          const SizedBox(height: 24),
          _buildSectionTitle("Benefits".tr, theme), // 🟢 Added .tr
          const SizedBox(height: 12),
          _buildBenefits(job.benefits, isDark),
        ],
      );
    });
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    bool highlight = false,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: highlight
            ? (isDark
                  ? AppColors.primary.withValues(
                      alpha: 0.2,
                    ) // 🟢 Updated opacity
                  : AppColors.primaryLight)
            : (isDark
                  ? AppColors.darkSurfaceElevated
                  : AppColors.lightSurfaceVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textTertiary),
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
                color: highlight
                    ? AppColors.primary
                    : (isDark ? Colors.white : AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobInfoCard(dynamic job, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _infoRow(
            Icons.calendar_month_rounded,
            "Working Days".tr, // 🟢 Added .tr
            job.workingDays.toString().tr, // 🟢 Added .tr
            isDark,
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.access_time_rounded,
            "Working Hours".tr, // 🟢 Added .tr
            job.workingHours ?? "N/A".tr, // 🟢 Added .tr
            isDark,
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.people_alt_rounded,
            "Headcount".tr, // 🟢 Added .tr
            "@count Position(s)".trParams({
              'count': job.headcount.toString(),
            }), // 🟢 Used .trParams
            isDark,
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.history_rounded,
            "Posted Date".tr, // 🟢 Added .tr
            _formatDate(job.createdAt),
            isDark,
          ),
          const SizedBox(height: 14),
          _infoRow(
            Icons.event_busy_rounded,
            "Closing Date".tr, // 🟢 Added .tr
            _formatDate(job.closingDate),
            isDark,
            isAlert: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
    bool isDark, {
    bool isAlert = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textTertiary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textTertiary,
          ),
        ),
        const Spacer(),
        Text(
          value.isNotEmpty ? value : "N/A".tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isAlert
                ? (isDark ? Colors.redAccent : Colors.red)
                : (isDark ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A".tr; // 🟢 Added .tr
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildSectionTitle(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildTextList(List<String> items, bool isDark) {
    if (items.isEmpty) {
      return Text(
        "No details provided.".tr, // 🟢 Added .tr
        style: TextStyle(
          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
        ),
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
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textTertiary,
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

  Widget _buildBenefits(List<String> benefits, bool isDark) {
    if (benefits.isEmpty) {
      return Text(
        "No specific benefits.".tr, // 🟢 Added .tr
        style: TextStyle(
          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
        ),
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
            color: isDark
                ? Colors.greenAccent.withValues(
                    alpha: 0.15,
                  ) // 🟢 Updated opacity
                : AppColors.successBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: isDark ? Colors.greenAccent : AppColors.success,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  benefit,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.greenAccent : AppColors.success,
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
