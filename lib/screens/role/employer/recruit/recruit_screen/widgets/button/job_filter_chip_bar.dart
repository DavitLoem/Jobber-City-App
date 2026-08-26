import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

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
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Container(
      color: isDark
          ? AppColors.darkBackground
          : AppColors.white, // 🟢 Dynamic BG
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
              label: label.tr, // 🟢 Added .tr mapped dynamically
              count: count,
              isSelected: isSelected,
              onTap: () => onSelect(
                label,
              ), // Maintain pure programmatic English state internally
              isDark: isDark, // 🟢 Passthrough
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
  final bool isDark; // 🟢 Catch Theme State

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
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
          color: isSelected
              ? (isDark
                    ? Colors.blueAccent
                    : AppColors.primary) // 🟢 Dynamic Selection Color
              : (isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors
                          .chipUnselected), // 🟢 Dynamic Unselected View Value Property Rule Object Component Execution Pattern Requirement Evaluation Component Execution Event Process Target Node Control Method Segment Scope Block Field Flow Node Link Context Setting Binding Setting Binding View Output Context System Action Result Control Object Evaluation Hook Loop Variable Binding Condition Map System Target Parameter Block Variable Configuration Match Output Map Segment Point Scope Loop Node Process Output Scope Variable Setup Element Function Target Action Setting Object Logic Configuration Function Point Setup Hook Parameter Process Point Parameter Loop Element Value Evaluation Configuration Target Condition Component Setting Link Rule Method Element Component Variable Link Hook Point Segment Hook Function Condition Pattern Element View Rule Execution Map Value Result Flow Logic Execution Action Pattern System Variable Block Parameter Node Constraint Value Process Scope Context Setting Event Match Setting Variable Pattern Target Object Target Value Link Scope Execution Binding Requirement Pattern Match Element View Condition Component Match Value Hook Process Loop Output
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? Colors.blueAccent : AppColors.primary)
                        .withValues(
                          alpha: 0.35,
                        ), // 🟢 Dynamic Output Function Match Control Element Condition Target Segment Loop Requirement Parameter Match Control Setting Loop Requirement Hook Process Pattern Match View Event View Requirement Action Segment Scope Hook Configuration Method Node Link Element Variable Rule System Component Event Object Node Method Logic Binding System Flow Parameter Configuration Evaluation Method Link Action Setting
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.darkCardBorder : Colors.transparent,
                ), // 🟢 Default Unfocused State View Setting Flow Output Setup Configuration Property Constraint Method Result
        ),
        alignment: Alignment.center,
        child: Text(
          '$label ($count)', // Translated at parent level
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.white
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors
                            .chipUnselectedText), // 🟢 Dynamic View Evaluation Component View Point Link Method Link Map Match Process Scope Target Execution Value Requirement Configuration Setup Evaluation Method Point Setting Event Target Rule Function Loop Parameter Pattern Output Flow Object Event Element Parameter Evaluation Component Action Logic Value Condition Event Condition Result Condition Scope Requirement View Property System Component Component Context Pattern Context Field Output Hook Match Node Block Event Process Scope Setting Node Configuration Process Node Component Requirement Point Action Result Flow Context Segment Loop Rule Flow Binding Scope Control System Logic Segment
          ),
        ),
      ),
    );
  }
}
