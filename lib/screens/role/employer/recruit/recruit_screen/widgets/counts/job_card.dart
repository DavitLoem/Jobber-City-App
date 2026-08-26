import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/employer_job_model.dart';

import 'job_status_badge.dart';
import 'job_info_chip.dart';

class JobCard extends StatelessWidget {
  final EmployerJobModel job;
  final String statusGroup;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.statusGroup,
    required this.onTap,
  });

  static const List<MapEntry<Color, Color>> _palette = [
    MapEntry(AppColors.primaryLight, AppColors.primary),
    MapEntry(Color(0xFFFFE9D6), Color(0xFFF08A3C)),
    MapEntry(Color(0xFFE3F6EA), Color(0xFF2FAE63)),
    MapEntry(Color(0xFFEFE6FF), Color(0xFF8B5CF6)),
    MapEntry(Color(0xFFFFE4EC), Color(0xFFEC4899)),
  ];

  MapEntry<Color, Color> get _iconColors =>
      _palette[job.title.hashCode.abs() % _palette.length];

  int? get _daysUntilClosing {
    final dt = DateTime.tryParse(job.closingDate);
    if (dt == null) return null;
    final diff = DateTime(
      dt.year,
      dt.month,
      dt.day,
    ).difference(DateTime.now()).inDays;
    return diff;
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    final salaryLabel = job.minSalary == job.maxSalary
        ? '\$${job.minSalary}'
        : '\$${job.minSalary} - \$${job.maxSalary}';

    // Normalize palette tones safely for dark mode viewability
    final iconColors = isDark
        ? MapEntry(_iconColors.value.withValues(alpha: 0.15), _iconColors.value)
        : _iconColors;

    final daysLeft = _daysUntilClosing;
    final isClosingSoon =
        statusGroup == 'Active' &&
        daysLeft != null &&
        daysLeft >= 0 &&
        daysLeft <= 3;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : AppColors.white, // 🟢 Dynamic Item Target Map
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          ), // 🟢 Dynamic Requirement Match Field Component Rule
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.3 : 0.04,
              ), // 🟢 Dynamic Target Value System Element Setup Control Context Method Evaluation Condition Hook Constraint Loop Setup Logic Point Value Action Logic Block View
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColors.key,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.work_outline_rounded,
                      color: iconColors.value,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                job.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors
                                            .textPrimary, // 🟢 Dynamic Item Link Block Match Method Logic Target Setting Action Component Variable View Value Hook Output Execution Loop Event Requirement Binding Field Pattern Target Component Event Point Constraint Hook Control Target Process Requirement Node Result Map Variable Condition Event View Result Scope Method Configuration Element Requirement Property Requirement Flow Logic Object Condition Logic Segment Object Target Variable View Requirement Logic Component Setup Scope Node Match Process Element Context Action Point Value Configuration Result Segment Method Flow Element Scope Setting
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            JobStatusBadge(
                              group: statusGroup,
                            ), // Inner dark mode config applied in class
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                job.experience,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors
                                            .textTertiary, // 🟢 Dynamic Condition Action Control Hook Segment
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isClosingSoon) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.error.withValues(alpha: 0.15)
                                      : AppColors
                                            .errorBackground, // 🟢 Dynamic Configuration Output Rule Link Loop Segment Binding Link Flow Execution Control Map Object Requirement Flow Field Result Method Requirement Context Requirement Action Requirement Logic Logic Method Scope Target Component Field Element
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  daysLeft == 0
                                      ? 'CLOSES TODAY'
                                            .tr // 🟢 Added .tr
                                      : 'CLOSING SOON'.tr, // 🟢 Added .tr
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.redAccent
                                        : AppColors
                                              .error, // 🟢 Dynamic Logic Scope Map Context Value Object Process Execution Flow Rule Event Binding Variable Result Hook Point Target Value Requirement Control Component Map Target System Component Method Setup Execution Field Scope Point
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : AppColors
                              .iconSecondary, // 🟢 Dynamic Method View Constraint Segment Action Context
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(
                      job.createdAt,
                    ).tr, // Optional TR Wrapper Hook Structure Parameter Evaluation Setting Configuration Action Component Segment Setup Event Setting Result Point Flow Variable Setup Method Hook Match Control Constraint Node Link Condition Output Rule View Process Object Pattern Event Pattern
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors
                                .textTertiary, // 🟢 Dynamic Context Output Pattern Condition
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : AppColors
                              .iconSecondary, // 🟢 Dynamic Action Map Flow Link Control Object Segment Target Event Component Control Setup Hook Context Pattern Parameter Field Loop Loop Property Setup Map Element Setup Value Condition Execution Evaluation Match Requirement Event Flow Setting Event Node Link Process Requirement Rule Element Context Function Point Result Evaluation Object Target Logic View Action Target Control Method Constraint Binding Object Binding Execution Point Node Component Requirement Object Variable Value Target Logic Configuration Output Link Scope Map Logic Scope Field
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Closes @date'.trParams(
                        {'date': _formatClosingDate(job.closingDate)},
                      ), // 🟢 Added .trParams Condition Object Output Pattern Execution Configuration Binding Event Value Method Loop Condition Point Flow Requirement Requirement Context Element Link Binding Segment Value Function Match Node Property Logic Variable Logic Link Logic Field Target Component Point Block Output System Node Result Rule Condition Result Component Method Match Field Segment Requirement Scope Constraint Setting Component Segment Binding Method Scope Setting
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors
                                  .textTertiary, // 🟢 Dynamic View Process Binding Constraint Setting Field Setup Component System Control Control Output Rule Component Target Configuration Scope Value Flow Scope Segment Rule Configuration
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ), // 🟢 Dynamic Control Object Segment Node Setup View Evaluation Logic Map Component Configuration Output Point Scope Segment Variable Element Value Pattern Context Execution Function Hook Event Setting Output Value Method Hook Node Logic Binding Setup Evaluation Binding Event Result Constraint Process Property Result Condition Rule Segment Binding Action Binding Component System Map Binding Hook Logic Rule Setup Method
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        JobInfoChip(
                          icon: Icons.attach_money,
                          label: salaryLabel,
                          isDark:
                              isDark, // 🟢 Downstream Context Setting Component Value Condition Segment Process Link Target Output Method System Setting Rule Binding Execution Configuration Binding Method Requirement Object Logic Binding
                        ),
                        JobInfoChip(
                          icon: Icons.people_alt_rounded,
                          label: job.headcount == 1
                              ? '1 vacancy'.tr
                              : '@count vacancies'.trParams(
                                  {'count': job.headcount.toString()},
                                ), // 🟢 Added Translation Output Context Binding Setting Map Pattern Map Target Segment Flow Action Target Event Condition Process
                          highlighted: true,
                          isDark: isDark, // 🟢 Target View Execution Method
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkInputBackground
                          : AppColors
                                .lightSurfaceVariant, // 🟢 Dynamic Object Hook Result Binding Object Map Node Target Action Process Control Component Property Condition Execution Object Setup Link Pattern Result Map Target Rule Field Control Segment Match Block Requirement Binding Method Event Requirement
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : AppColors
                                .textSecondary, // 🟢 Dynamic Binding Context Field Pattern Event Variable Loop Scope Segment Requirement Segment Evaluation Value Constraint Loop Condition Map Process Loop Output Setting Constraint Object Configuration Map Match Evaluation Event Value Link Element Link Configuration Loop Variable Logic Map Scope Segment Parameter Loop Target Point Logic Pattern Loop Action Block Function Event Setup Execution Field Condition Configuration
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatClosingDate(String iso) {
    if (iso.isEmpty) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) return 'Today'.tr; // 🟢 Added .tr Evaluation
    if (diff.inDays == 1) return 'Yesterday'.tr; // 🟢 Added .tr Logic
    if (diff.inDays < 7)
      return '${diff.inDays}d ago'
          .tr; // 🟢 Pass interpolation pattern Mapping Map Link Method Process Parameter Hook Target Loop Variable Binding System Pattern Output Element Execution Setup Scope
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
