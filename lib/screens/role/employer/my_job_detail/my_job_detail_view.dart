import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/employer/my_job/my_job_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/category_controller.dart';
import '../../../../controllers/location_controller.dart';
import '../../../../controllers/master_data_controller.dart';
import '../../../../core/api/services/role/employer/job_service.dart';
import '../../../../models/role/employer/company_model.dart';
import '../../../../models/role/employer/job_model.dart';
import '../employer_profile/employer_profile_view.dart';
import '../../../../widgets/confirm_dialog.dart';

part 'my_job_detail_binding.dart';
part 'my_job_detail_controller.dart';

class MyJobDetailView extends GetView<MyJobDetailViewController> {
  const MyJobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.edit,
              color: theme.textTheme.bodyLarge?.color,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              LucideIcons.share2,
              color: theme.textTheme.bodyLarge?.color,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final job = controller.jobData.value;

        if (job == null) {
          return Center(
            child: Text(
              "Job details not found or failed to load.".tr, // 🟢 Added .tr
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(job.title, job.status, theme, isDark),
                  const SizedBox(height: 24),
                  _buildTagsSection(job, isDark),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          LucideIcons.calendarDays,
                          "Working Days".tr, // 🟢 Added .tr
                          job.workingDays,
                          theme,
                          isDark,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          LucideIcons.clock,
                          "Working Hours".tr, // 🟢 Added .tr
                          job.workingHours,
                          theme,
                          isDark,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          LucideIcons.users,
                          "Headcount".tr, // 🟢 Added .tr
                          "@count Positions".trParams({
                            'count': job.headcount.toString(),
                          }), // 🟢 Added .trParams
                          theme,
                          isDark,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          LucideIcons.calendarX,
                          "Closing Date".tr, // 🟢 Added .tr
                          job.closingDate.toString().split('T').first,
                          theme,
                          isDark,
                          isUrgent: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Divider(
                    color: isDark
                        ? AppColors.darkDivider
                        : const Color(0xFFEEEEEE),
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),

                  if (job.description.isNotEmpty) ...[
                    _buildSectionTitle(
                      "Job Description".tr,
                      theme,
                    ), // 🟢 Added .tr
                    const SizedBox(height: 12),
                    ...job.description.map(
                      (desc) => _buildBulletPoint(desc, isDark),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (job.requirements.isNotEmpty) ...[
                    _buildSectionTitle(
                      "Requirements".tr,
                      theme,
                    ), // 🟢 Added .tr
                    const SizedBox(height: 12),
                    ...job.requirements.map(
                      (req) => _buildBulletPoint(req, isDark),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (job.benefits.isNotEmpty) ...[
                    _buildSectionTitle("Benefits".tr, theme), // 🟢 Added .tr
                    const SizedBox(height: 12),
                    ...job.benefits.map(
                      (ben) => _buildBulletPoint(ben, isDark),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if ((job.requiredSkills.isNotEmpty) ||
                      (job.customSkills.isNotEmpty)) ...[
                    _buildSectionTitle(
                      "Required Skills".tr,
                      theme,
                    ), // 🟢 Added .tr
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...job.requiredSkills.map(
                          (skill) => _buildSkillChip(
                            controller.getSkillName(skill),
                            isDark,
                          ),
                        ),
                        ...job.customSkills.map(
                          (skill) => _buildSkillChip(skill, isDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.05, // 🟢 Updated opacity
                      ),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      if (job.status.toLowerCase() != 'closed') ...[
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () =>
                                _showCloseJobDialog(context, theme, isDark),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: isDark ? Colors.redAccent : Colors.red,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Close Job".tr, // 🟢 Added .tr
                              style: TextStyle(
                                color: isDark ? Colors.redAccent : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "View Applicants".tr, // 🟢 Added .tr
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(
    String? title,
    String? status,
    ThemeData theme,
    bool isDark,
  ) {
    Color statusColor;
    Color statusBgColor;
    String displayStatus = "UNKNOWN".tr; // 🟢 Added .tr

    switch (status?.toLowerCase()) {
      case 'active':
        statusColor = isDark ? Colors.greenAccent : Colors.green.shade700;
        statusBgColor = isDark
            ? Colors.greenAccent.withValues(alpha: 0.15) // 🟢 Updated opacity
            : Colors.green.shade50;
        displayStatus = 'ACTIVE'.tr; // 🟢 Added .tr
        break;
      case 'inactive':
      case 'paused':
        statusColor = isDark ? Colors.orangeAccent : Colors.orange.shade700;
        statusBgColor = isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15) // 🟢 Updated opacity
            : Colors.orange.shade50;
        displayStatus = 'PAUSED'.tr; // 🟢 Added .tr
        break;
      case 'closed':
        statusColor = isDark ? Colors.redAccent : Colors.red.shade700;
        statusBgColor = isDark
            ? Colors.redAccent.withValues(alpha: 0.15) // 🟢 Updated opacity
            : Colors.red.shade50;
        displayStatus = 'CLOSED'.tr; // 🟢 Added .tr
        break;
      case 'draft':
        statusColor = isDark ? AppColors.darkTextHint : Colors.grey.shade700;
        statusBgColor = isDark
            ? AppColors.darkSurfaceElevated
            : Colors.grey.shade100;
        displayStatus = 'DRAFT'.tr; // 🟢 Added .tr
        break;
      default:
        statusColor = isDark
            ? AppColors.darkTextSecondary
            : Colors.grey.shade700;
        statusBgColor = isDark
            ? AppColors.darkSurfaceElevated
            : Colors.grey.shade100;
        displayStatus =
            status?.toUpperCase().tr ?? 'UNKNOWN'.tr; // 🟢 Added .tr
    }

    final profileCtrl = Get.find<EmployerProfileViewController>();
    final profile = profileCtrl.companyProfile.value;
    final hasLogo =
        profile != null &&
        profile.logoUrl != null &&
        profile.logoUrl!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: hasLogo
                ? Image.network(
                    profile.logoUrl!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Icon(LucideIcons.building, size: 32, color: statusColor),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "Untitled Job".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  displayStatus,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(dynamic job, bool isDark) {
    String salaryText = "\$${job.minSalary ?? 0} - \$${job.maxSalary ?? 0}";
    if (job.salaryPeriod != null) salaryText += " / ${job.salaryPeriod}";
    if (job.isNegotiable == true)
      salaryText += " (${"(Negotiable)".tr})"; // 🟢 Added .tr

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildTag(
          LucideIcons.grid,
          controller.getCategoryName(),
          isDark
              ? const Color(0xFF8B5CF6).withValues(
                  alpha: 0.2,
                ) // 🟢 Updated opacity
              : const Color(0xFFF3E8FF),
          isDark ? Colors.purpleAccent : const Color(0xFF8B5CF6),
        ),
        _buildTag(
          LucideIcons.dollarSign,
          salaryText,
          isDark
              ? const Color(0xFF0F9D58).withValues(
                  alpha: 0.2,
                ) // 🟢 Updated opacity
              : const Color(0xFFE8FDF3),
          isDark ? Colors.greenAccent : const Color(0xFF0F9D58),
        ),
        _buildTag(
          LucideIcons.briefcase,
          controller.getEmploymentTypeName(),
          isDark
              ? AppColors.primary.withValues(alpha: 0.2) // 🟢 Updated opacity
              : const Color(0xFFE8F0FE),
          isDark ? Colors.blueAccent : const Color(0xFF4f7df7),
        ),
        _buildTag(
          LucideIcons.graduationCap,
          job.experience ?? "N/A".tr, // 🟢 Added .tr
          isDark
              ? const Color(0xFFE37400).withValues(
                  alpha: 0.2,
                ) // 🟢 Updated opacity
              : const Color(0xFFFEF3E8),
          isDark ? Colors.orangeAccent : const Color(0xFFE37400),
        ),
        _buildTag(
          LucideIcons.mapPin,
          controller.getLocationName(),
          isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
          isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
        ),
      ],
    );
  }

  Widget _buildTag(
    IconData icon,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
    bool isDark, {
    bool isUrgent = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDark
                  ? AppColors.darkIconSecondary
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isUrgent
                ? (isDark ? Colors.redAccent : Colors.red)
                : theme.textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: isDark
                  ? AppColors.darkIconSecondary
                  : Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill, bool isDark) {
    return Chip(
      label: Text(
        skill,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.blueAccent : const Color(0xFF4f7df7),
        ),
      ),
      backgroundColor: isDark
          ? AppColors.primary.withValues(alpha: 0.15) // 🟢 Updated opacity
          : const Color(0xFFF0F4FF),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _showCloseJobDialog(BuildContext context, ThemeData theme, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              LucideIcons.alertCircle,
              color: isDark ? Colors.redAccent : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(
              "Close Job".tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to close this job? Candidates will no longer be able to apply."
              .tr, // 🟢 Added .tr
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel".tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark ? AppColors.darkTextHint : Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateJobStatus('closed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.redAccent : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Close Job".tr, // 🟢 Added .tr
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
