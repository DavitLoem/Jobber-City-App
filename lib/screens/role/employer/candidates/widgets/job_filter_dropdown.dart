import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../candidates_view.dart';

class JobFilterDropdown extends GetView<CandidatesViewController> {
  const JobFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark
          ? AppColors.darkSurfaceElevated
          : Colors.white, // 🟢 Dynamic Component BG
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: InkWell(
        onTap: () =>
            _showJobBottomSheet(context, isDark), // 🟢 Passed Theme Value
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkInputBackground
                : Colors.grey.shade50, // 🟢 Dynamic Field Area BG
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
            ), // 🟢 Dynamic Border
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.briefcase,
                size: 20,
                color: isDark
                    ? AppColors.darkIconSecondary
                    : Colors.grey.shade500, // 🟢 Dynamic Icon
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Text(
                    controller.selectedJobDisplayName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white
                          : Colors.black87, // 🟢 Dynamic Text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(
                LucideIcons.chevronDown,
                size: 20,
                color: isDark
                    ? AppColors.darkTextTertiary
                    : Colors.grey.shade400, // 🟢 Dynamic Icon
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJobBottomSheet(BuildContext context, bool isDark) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackground
              : Colors.white, // 🟢 Dynamic BottomSheet BG
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Job Post".tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Colors.black87, // 🟢 Dynamic Title
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors.black54, // 🟢 Dynamic Sub-icon
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
            ), // 🟢 Dynamic Divider

            Expanded(
              child: Obx(() {
                if (controller.isJobsLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _buildJobTile(
                      jobId: 'all',
                      displayName: 'All Jobs'.tr, // 🟢 Added .tr
                      status: 'active',
                      isSelected:
                          controller.selectedJobId.value == 'all' ||
                          controller.selectedJobId.value.isEmpty,
                      isDark: isDark,
                    ),
                    Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: isDark
                          ? AppColors.darkDivider
                          : Colors.grey.shade300,
                    ),

                    ...controller.postedJobs.map((job) {
                      return _buildJobTile(
                        jobId: job.jobId,
                        displayName: job.displayName,
                        status: job.status,
                        isSelected: controller.selectedJobId.value == job.jobId,
                        isDark: isDark,
                      );
                    }),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildJobTile({
    required String jobId,
    required String displayName,
    required String status,
    required bool isSelected,
    required bool isDark,
  }) {
    final bool isClosed = status.toLowerCase() != 'active' && jobId != 'all';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      tileColor: isSelected
          ? (isDark
                ? Colors.blueAccent.withValues(alpha: 0.15)
                : const Color(
                    0xFF4f7df7,
                  ).withValues(alpha: 0.05)) // 🟢 Dynamic Selected Highlight
          : Colors.transparent,
      title: Text(
        displayName,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isClosed
              ? (isDark ? AppColors.darkTextSecondary : Colors.grey.shade500)
              : (isSelected
                    ? (isDark ? Colors.blueAccent : const Color(0xFF4f7df7))
                    : (isDark
                          ? Colors.white
                          : Colors.black87)), // 🟢 Dynamic Item Label
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: isDark ? Colors.blueAccent : const Color(0xFF4f7df7),
            ) // 🟢 Dynamic Trailing Label
          : null,
      onTap: () {
        Get.back();
        if (controller.selectedJobId.value != jobId) {
          controller.selectedJobId.value = jobId;
          controller.fetchApplicants();
        }
      },
    );
  }
}
