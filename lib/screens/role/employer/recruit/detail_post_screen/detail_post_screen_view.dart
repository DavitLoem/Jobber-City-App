import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/location_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/employer_job_model.dart';
import 'package:jobber_city/widgets/arrow_key_back.dart';

part 'detail_post_screen_binding.dart';
part 'detail_post_screen_controller.dart';

class DetailPostScreenView extends GetView<DetailPostScreenViewController> {
  const DetailPostScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground, // 🟢 Dynamic BG
      body: SafeArea(
        child: Obx(() {
          final job = controller.job.value;
          if (job == null) {
            return Center(
              child: Text(
                'No job data available'.tr, // 🟢 Added .tr
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ), // 🟢 Dynamic Subtext
              ),
            );
          }
          return _buildDetail(context, job, isDark);
        }),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, EmployerJobModel job, bool isDark) {
    final salaryLabel = job.minSalary == job.maxSalary
        ? '\$${job.minSalary}'
        : '\$${job.minSalary} - \$${job.maxSalary}';

    return Column(
      children: [
        _buildHeader(isDark),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildSectionCard(
                  title: 'Job Information'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    _detailRow(
                      Icons.work_outline,
                      'Job Title'.tr,
                      job.title,
                      isDark,
                    ),
                    _detailRow(
                      Icons.label_outline,
                      'Status'.tr, // 🟢 Added .tr
                      job.status.isEmpty
                          ? 'Draft'
                                .tr // 🟢 Added .tr
                          : (job.status[0].toUpperCase() +
                                    job.status.substring(1))
                                .tr, // 🟢 Added .tr wrapper
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Compensation'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    _detailRow(
                      Icons.attach_money,
                      'Salary'.tr,
                      salaryLabel,
                      isDark,
                    ),
                    if (job.salaryPeriod.isNotEmpty)
                      _detailRow(
                        Icons.calendar_today,
                        'Salary Period'.tr, // 🟢 Added .tr
                        job.salaryPeriod.tr, // 🟢 Map known strings
                        isDark,
                      ),
                    _detailRow(
                      Icons.gavel,
                      'Negotiable'.tr, // 🟢 Added .tr
                      job.isNegotiable ? 'Yes'.tr : 'No'.tr, // 🟢 Added .tr
                      isDark,
                    ),
                    _detailRow(
                      Icons.people_outline,
                      'Vacancies'.tr, // 🟢 Added .tr
                      '${job.headcount}',
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Requirements & Skills'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    if (job.experience.isNotEmpty)
                      _detailRow(
                        Icons.trending_up,
                        'Experience'.tr, // 🟢 Added .tr
                        job.experience.tr,
                        isDark,
                      ),
                    if (controller.skillNames.isNotEmpty)
                      ...controller.skillNames.map(
                        (skillName) => _detailRow(
                          Icons.star_outline,
                          '',
                          skillName,
                          isDark,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Schedule'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    _detailRow(
                      Icons.calendar_view_day,
                      'Working Days'.tr, // 🟢 Added .tr
                      job.workingDays.tr,
                      isDark,
                    ),
                    _detailRow(
                      Icons.access_time,
                      'Working Hours'.tr, // 🟢 Added .tr
                      job.workingHours.tr,
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Benefits'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children:
                      job.benefits
                          .where((b) => b.toLowerCase() != 'not specified')
                          .toList()
                          .isNotEmpty
                      ? job.benefits
                            .where((b) => b.toLowerCase() != 'not specified')
                            .map(
                              (b) => _detailRow(
                                Icons.check_circle_outline,
                                '',
                                b,
                                isDark,
                              ),
                            )
                            .toList()
                      : [
                          _detailRow(
                            Icons.check_circle_outline,
                            '',
                            'Not specified'.tr, // 🟢 Added .tr
                            isDark,
                          ),
                        ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Timeline'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    _detailRow(
                      Icons.schedule,
                      'Posted On'.tr, // 🟢 Added .tr
                      _formatDate(job.createdAt),
                      isDark,
                    ),
                    if (job.closingDate.isNotEmpty)
                      _detailRow(
                        Icons.event_busy,
                        'Closing Date'.tr, // 🟢 Added .tr
                        _formatDate(job.closingDate),
                        isDark,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Category & Type'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    _detailRow(
                      Icons.category_outlined,
                      'Category'.tr, // 🟢 Added .tr
                      controller.categoryName.value.isEmpty
                          ? '-'
                          : controller.categoryName.value.tr,
                      isDark,
                    ),
                    _detailRow(
                      Icons.workspace_premium_outlined,
                      'Job Level'.tr, // 🟢 Added .tr
                      controller.jobLevelName.value.isEmpty
                          ? '-'
                          : controller.jobLevelName.value.tr,
                      isDark,
                    ),
                    _detailRow(
                      Icons.location_city_outlined,
                      'Work Type'.tr, // 🟢 Added .tr
                      controller.workTypeName.value.isEmpty
                          ? '-'
                          : controller.workTypeName.value.tr,
                      isDark,
                    ),
                    _detailRow(
                      Icons.business_center_outlined,
                      'Employment Type'.tr, // 🟢 Added .tr
                      controller.employmentTypeName.value.isEmpty
                          ? '-'
                          : controller.employmentTypeName.value.tr,
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Education'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    _detailRow(
                      Icons.school_outlined,
                      'Education Level'.tr, // 🟢 Added .tr
                      controller.educationLevelName.value.isEmpty
                          ? '-'
                          : controller.educationLevelName.value.tr,
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Location'.tr, // 🟢 Added .tr
                  isDark: isDark,
                  children: [
                    _detailRow(
                      Icons.location_on_outlined,
                      'Province'.tr, // 🟢 Added .tr
                      controller.provinceName.value.isEmpty
                          ? '-'
                          : controller.provinceName.value.tr,
                      isDark,
                    ),
                    _detailRow(
                      Icons.place_outlined,
                      'District'.tr, // 🟢 Added .tr
                      controller.districtName.value.isEmpty
                          ? '-'
                          : controller.districtName.value.tr,
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : AppColors.white, // 🟢 Dynamic BG
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05,
            ), // 🟢 Dynamic Shadow
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const ArrowKeyBack(),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Job Details'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : AppColors.textPrimary, // 🟢 Dynamic Title
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.white, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
        ), // 🟢 Dynamic Card Border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05,
            ), // 🟢 Dynamic Shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? Colors.white
                    : AppColors.textPrimary, // 🟢 Dynamic Subtitle
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isDark
                ? AppColors.darkIconSecondary
                : AppColors.iconSecondary,
          ), // 🟢 Dynamic Icon
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                    ), // 🟢 Dynamic Row Label
                  ),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ), // 🟢 Dynamic Row Value
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '-';
    try {
      final dt = DateTime.tryParse(iso);
      if (dt == null) return '-';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '-';
    }
  }
}
