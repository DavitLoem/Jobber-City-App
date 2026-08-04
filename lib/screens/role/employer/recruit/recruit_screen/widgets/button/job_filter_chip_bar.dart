import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// Horizontal scrollable status filter (All / Active / Paused / Draft / Closed)
/// with a live count badge on each chip.
class JobFilterChipBar extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Map<String, int> counts;
  final ValueChanged<String> onSelect;

  const JobFilterChipBar({
    super.key,
    required this.options,
    required this.selected,
    required this.counts,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: options.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final label = options[index];
            final count = counts[label] ?? 0;
            final isSelected = selected == label;
            return _FilterChip(
              label: label,
              count: count,
              isSelected: isSelected,
              onTap: () => onSelect(label),
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chipUnselected,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.shadowBlue,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.chipUnselectedText,
          ),
        ),
      ),
    );
  }
}
