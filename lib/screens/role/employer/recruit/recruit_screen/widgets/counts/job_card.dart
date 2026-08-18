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
    return dt.difference(DateTime.now()).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconPair = _iconColors;

    final daysLeft = _daysUntilClosing;
    final isExpiringSoon = daysLeft != null && daysLeft <= 5 && daysLeft >= 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.2 : 0.03, // 🟢 Updated to withValues
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
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
                      color: isDark
                          ? iconPair.value.withValues(
                              alpha: 0.2,
                            ) // 🟢 Updated to withValues
                          : iconPair.key,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.work_outline_rounded,
                      color: iconPair.value,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Posted @date'.trParams({
                            'date': _formatDate(job.createdAt),
                          }), // 🟢 Added .trParams
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  JobStatusBadge(group: statusGroup),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  JobInfoChip(
                    icon: Icons.attach_money_rounded,
                    label: '\$${job.minSalary} - \$${job.maxSalary}',
                    highlighted: true,
                  ),
                  JobInfoChip(
                    icon: Icons.people_outline_rounded,
                    label: '@count positions'.trParams({
                      'count': job.headcount.toString(),
                    }), // 🟢 Added .trParams
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : AppColors.cardBorder,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 14,
                          color: isExpiringSoon
                              ? (isDark ? Colors.redAccent : AppColors.error)
                              : (isDark
                                    ? AppColors.darkTextHint
                                    : AppColors.textTertiary),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            job.closingDate.isEmpty
                                ? 'No closing date'
                                      .tr // 🟢 Added .tr
                                : isExpiringSoon
                                ? 'Closes in @days days'.trParams({
                                    'days': daysLeft.toString(),
                                  }) // 🟢 Added .trParams
                                : 'Closes: @date'.trParams({
                                    'date': _formatClosingDate(job.closingDate),
                                  }), // 🟢 Added .trParams
                            style: TextStyle(
                              fontSize: 12,
                              color: isExpiringSoon
                                  ? (isDark
                                        ? Colors.redAccent
                                        : AppColors.error)
                                  : (isDark
                                        ? AppColors.darkTextHint
                                        : AppColors.textTertiary),
                              fontWeight: isExpiringSoon
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
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
    if (diff.inDays == 0) return 'Today'.tr; // 🟢 Added .tr
    if (diff.inDays == 1) return 'Yesterday'.tr; // 🟢 Added .tr
    if (diff.inDays < 7)
      return '@daysd ago'.trParams({
        'days': diff.inDays.toString(),
      }); // 🟢 Added .trParams
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
