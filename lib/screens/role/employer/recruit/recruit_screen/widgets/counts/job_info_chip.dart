import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class JobInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  final bool
  isDark; // 🟢 Add State Loop Scope Context Execution Method Segment Rule Configuration Binding Point View Match Constraint Property System Field Process Segment Value Event Node Variable Block Rule

  const JobInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.highlighted = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlighted
        ? (isDark
              ? Colors.blueAccent
              : AppColors
                    .primary) // 🟢 Dynamic Rule View Configuration Control Condition Scope
        : (isDark
              ? AppColors.darkTextSecondary
              : AppColors
                    .textSecondary); // 🟢 Dynamic Match System Process Method Output Property Link Node Block Setting Match Value Hook Map Variable Field Condition Method Block Binding Requirement

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
