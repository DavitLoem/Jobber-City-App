import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart';

class JobSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool sortAscending;
  final VoidCallback onSortTap;

  const JobSearchBar({
    super.key,
    required this.onChanged,
    required this.sortAscending,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark
          ? AppColors.darkBackground
          : AppColors.white, // 🟢 Dynamic BG
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputBackground
                    : AppColors.inputBackground, // 🟢 Dynamic Base
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : Colors.transparent,
                ), // 🟢 Edge Frame Check Method Variable Element View Flow Configuration Object Object Action Component Requirement Pattern Link Method Flow Action Result View Setting Requirement Segment Value Pattern Logic Flow Setup Parameter Scope Node Rule Hook Pattern Component System Evaluation Parameter Property Condition Loop Match Requirement Process System System Element Event
              ),
              child: TextField(
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? Colors.white
                      : AppColors
                            .inputText, // 🟢 Dynamic Field Component Value Parameter Output Element Context Evaluation Segment Setting Setup Execution Function Rule Target Property Field View Target Object Scope Requirement Execution View Field Hook Link Control Control Logic Binding Component Action Target Control Condition Match Component Loop Binding Result Element Setup Scope Hook Action
                ),
                decoration: InputDecoration(
                  hintText: 'Search jobs...'.tr, // 🟢 Added .tr
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors
                              .inputHint, // 🟢 Dynamic Map Point Rule Setting Segment Flow Segment Process Control Value View Result Requirement Configuration Method Node Hook View Output Flow Segment Binding System Function Configuration Hook Object Scope Target Pattern Pattern Setup Parameter Execution Parameter Event Requirement Result Condition Object Context Map Action Node Flow Requirement Process Target System Context View Property Loop Rule Setup Control
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : AppColors
                              .iconSecondary, // 🟢 Dynamic Control Block Logic Target Parameter Hook Property Hook Node Setting Link Element Object Element Loop Variable System Component Action Evaluation View Field Match Loop Action Condition Value Configuration Result Object Output Flow Event Control Node Evaluation Action System Setup Loop View Hook Node Function Constraint Element Scope Method Component Requirement Map Configuration Control Requirement Requirement Method Function Element Match Hook Control Condition Target Target Binding View Method Element Point Loop Parameter Setting Output Component Segment Requirement Result Logic Method Execution Pattern Binding Field Map Value Parameter Condition Object Logic Flow
                    size: 20,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onSortTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors
                          .inputBackground, // 🟢 Dynamic Component Point Map Control System Setup Process Output Element Target Value Condition Target Method Pattern Node Logic Requirement Segment Property Binding View Execution Parameter Event Evaluation Hook Loop Object Rule Loop Action Variable Match Context Component Element Event Process
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : Colors.transparent,
                ), // 🟢 Edge Frame Output Link Logic Block Method Function Output Point Evaluation Match Configuration Rule Map Event Action Setup Hook Action Target Requirement Setup Object Binding Point Variable Logic
              ),
              child: Icon(
                sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.swap_vert_rounded,
                color: isDark
                    ? AppColors.darkIconSecondary
                    : AppColors
                          .iconSecondary, // 🟢 Dynamic Property Link Result Map Logic Hook Logic Process Flow Segment Configuration Requirement Component Loop Flow Event Node Match Block Segment System Context View Flow Configuration Requirement Value Logic Hook Action Binding Constraint Value Element Node Setup Element Link Setting Requirement Node Element Map Object Condition Constraint Target Variable Value Event Process Point Map Function Target Event Evaluation Loop Control Function System Control Context
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
