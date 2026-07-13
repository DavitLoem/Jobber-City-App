import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// Small icon + label pair used for meta info inside a job card
/// (salary, vacancies, etc).
class JobInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;

  const JobInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlighted ? AppColors.primary : AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: highlighted ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
