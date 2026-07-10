import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/master_data_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/district_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/location_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/employer_job_model.dart';
import 'package:jobber_city/widgets/arrow_key_back.dart';

part 'detail_post_screen_binding.dart';
part 'detail_post_screen_controller.dart';

class DetailPostScreenView extends GetView<DetailPostScreenViewController> {
  const DetailPostScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Obx(() {
          final job = controller.job.value;
          if (job == null) {
            return Center(
              child: Text(
                'No job data available',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return _buildDetail(context, job);
        }),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, EmployerJobModel job) {
    final salaryLabel = job.minSalary == job.maxSalary
        ? '\$${job.minSalary}'
        : '\$${job.minSalary} - \$${job.maxSalary}';

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildSectionCard(
                  title: 'Job Information',
                  children: [
                    _detailRow(Icons.work_outline, 'Job Title', job.title),
                    _detailRow(
                      Icons.label_outline,
                      'Status',
                      job.status.isEmpty
                          ? 'Draft'
                          : job.status[0].toUpperCase() +
                                job.status.substring(1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Compensation',
                  children: [
                    _detailRow(Icons.attach_money, 'Salary', salaryLabel),
                    if (job.salaryPeriod.isNotEmpty)
                      _detailRow(
                        Icons.calendar_today,
                        'Salary Period',
                        job.salaryPeriod,
                      ),
                    _detailRow(
                      Icons.gavel,
                      'Negotiable',
                      job.isNegotiable ? 'Yes' : 'No',
                    ),
                    _detailRow(
                      Icons.people_outline,
                      'Vacancies',
                      '${job.headcount}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Requirements & Skills',
                  children: [
                    if (job.experience.isNotEmpty)
                      _detailRow(
                        Icons.trending_up,
                        'Experience',
                        job.experience,
                      ),
                    if (controller.skillNames.isNotEmpty)
                      ...controller.skillNames.map(
                        (skillName) =>
                            _detailRow(Icons.star_outline, '', skillName),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Schedule',
                  children: [
                    _detailRow(
                      Icons.calendar_view_day,
                      'Working Days',
                      job.workingDays,
                    ),
                    _detailRow(
                      Icons.access_time,
                      'Working Hours',
                      job.workingHours,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Benefits',
                  children: job.benefits
                          .where((b) => b.toLowerCase() != 'not specified')
                          .toList()
                          .isNotEmpty
                      ? job.benefits
                            .where((b) => b.toLowerCase() != 'not specified')
                            .map(
                              (b) =>
                                  _detailRow(Icons.check_circle_outline, '', b),
                            )
                            .toList()
                      : [
                          _detailRow(
                            Icons.check_circle_outline,
                            '',
                            'Not specified',
                          ),
                        ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Timeline',
                  children: [
                    _detailRow(
                      Icons.schedule,
                      'Posted On',
                      _formatDate(job.createdAt),
                    ),
                    if (job.closingDate.isNotEmpty)
                      _detailRow(
                        Icons.event_busy,
                        'Closing Date',
                        _formatDate(job.closingDate),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Category & Type',
                  children: [
                    _detailRow(
                      Icons.category_outlined,
                      'Category',
                      controller.categoryName.value.isEmpty
                          ? '-'
                          : controller.categoryName.value,
                    ),
                    _detailRow(
                      Icons.workspace_premium_outlined,
                      'Job Level',
                      controller.jobLevelName.value.isEmpty
                          ? '-'
                          : controller.jobLevelName.value,
                    ),
                    _detailRow(
                      Icons.location_city_outlined,
                      'Work Type',
                      controller.workTypeName.value.isEmpty
                          ? '-'
                          : controller.workTypeName.value,
                    ),
                    _detailRow(
                      Icons.business_center_outlined,
                      'Employment Type',
                      controller.employmentTypeName.value.isEmpty
                          ? '-'
                          : controller.employmentTypeName.value,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Education',
                  children: [
                    _detailRow(
                      Icons.school_outlined,
                      'Education Level',
                      controller.educationLevelName.value.isEmpty
                          ? '-'
                          : controller.educationLevelName.value,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Location',
                  children: [
                    _detailRow(
                      Icons.location_on_outlined,
                      'Province',
                      controller.provinceName.value.isEmpty
                          ? '-'
                          : controller.provinceName.value,
                    ),
                    _detailRow(
                      Icons.place_outlined,
                      'District',
                      controller.districtName.value.isEmpty
                          ? '-'
                          : controller.districtName.value,
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
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
              'Job Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
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
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
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
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.iconSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
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
