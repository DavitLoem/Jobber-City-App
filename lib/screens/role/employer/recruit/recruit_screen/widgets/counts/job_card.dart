import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/employer_job_model.dart';

import 'job_status_badge.dart';
import 'job_info_chip.dart';

/// A single job posting card for the "My Jobs" list.
///
/// Presentational only — takes the model + a pre-computed status group
/// (Active/Paused/Draft/Closed) and an onTap callback. All formatting
/// lives here so the parent screen stays a thin layout shell.
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

  // A small rotating pastel palette so cards read as distinct at a glance,
  // the way icon/category colors do in a real job board — without
  // depending on a category field the API doesn't provide.
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
    final salaryLabel = job.minSalary == job.maxSalary
        ? '\$${job.minSalary}'
        : '\$${job.minSalary} - \$${job.maxSalary}';
    final iconColors = _iconColors;
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            JobStatusBadge(group: statusGroup),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                job.experience,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textTertiary,
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
                                  color: AppColors.errorBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  daysLeft == 0
                                      ? 'CLOSES TODAY'
                                      : 'CLOSING SOON',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.error,
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
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.iconSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(job.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: AppColors.iconSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Closes ${_formatClosingDate(job.closingDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
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
                        ),
                        JobInfoChip(
                          icon: Icons.people_alt_rounded,
                          label:
                              '${job.headcount} vacanc${job.headcount == 1 ? 'y' : 'ies'}',
                          highlighted: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.lightSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
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
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
