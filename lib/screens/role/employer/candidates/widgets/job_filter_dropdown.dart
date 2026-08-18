import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../candidates_view.dart';

class JobFilterDropdown extends GetView<CandidatesViewController> {
  const JobFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: InkWell(
        onTap: () => _showJobBottomSheet(context, isDark, theme),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkInputBackground
                : Colors.grey.shade50, // 🟢 Dynamic Box BG
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
            ), // 🟢 Dynamic Border
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.briefcase,
                color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Text(
                    controller
                        .selectedJobDisplayName, // Already translated in controller
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(
                LucideIcons.chevronDown,
                color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJobBottomSheet(BuildContext context, bool isDark, ThemeData theme) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Job".tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Divider(
              color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isJobsLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildJobTile(
                      jobId: 'all',
                      displayName: 'All Jobs'.tr, // 🟢 Added .tr
                      status: 'active',
                      isSelected:
                          controller.selectedJobId.value == 'all' ||
                          controller.selectedJobId.value.isEmpty,
                      isDark: isDark,
                      theme: theme,
                    ),
                    ...controller.postedJobs.map((job) {
                      return _buildJobTile(
                        jobId: job.jobId,
                        displayName: job.displayName,
                        status: job.status,
                        isSelected: controller.selectedJobId.value == job.jobId,
                        isDark: isDark,
                        theme: theme,
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
    required ThemeData theme,
  }) {
    final bool isClosed = status.toLowerCase() != 'active' && jobId != 'all';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      tileColor: isSelected
          ? AppColors.primary.withValues(
              alpha: isDark ? 0.15 : 0.05, // 🟢 Updated opacity
            ) // 🟢 Dynamic Selection Tint
          : Colors.transparent,
      title: Text(
        displayName,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isClosed
              ? (isDark
                    ? AppColors.darkTextDisabled
                    : Colors.grey.shade500) // 🟢 Dynamic Text Colors
              : (isSelected
                    ? AppColors.primary
                    : theme.textTheme.bodyLarge?.color),
        ),
      ),
      subtitle: jobId != 'all'
          ? Text(
              isClosed ? "Closed".tr : "Active".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 12,
                color: isClosed
                    ? Colors.redAccent
                    : (isDark ? Colors.greenAccent : Colors.green),
              ),
            )
          : null,
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
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
