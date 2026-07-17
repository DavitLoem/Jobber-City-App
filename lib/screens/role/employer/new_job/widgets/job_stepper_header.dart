import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobStepperHeader extends StatelessWidget {
  final int currentStep;

  const JobStepperHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> steps = [
      {'title': 'Basic Info', 'icon': LucideIcons.info},
      {'title': 'Salary', 'icon': LucideIcons.banknote},
      {'title': 'Details', 'icon': LucideIcons.fileText},
      {'title': 'Schedule', 'icon': LucideIcons.calendar},
    ];

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // បង្កើត Item (រង្វង់) និង Line (បន្ទាត់) ឆ្លាស់គ្នា
        children: List.generate(steps.length * 2 - 1, (index) {
          // ── ប្រសិនបើជួរទីតាំងជាលេខសេស = បង្ហាញបន្ទាត់ភ្ជាប់ ──
          if (index % 2 != 0) {
            final stepIndex = index ~/ 2;
            final isLineCompleted = currentStep > stepIndex;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 18,
                ), // រំកិលចុះក្រោមឱ្យចំកណ្តាលរង្វង់
                height: 2,
                color: isLineCompleted
                    ? AppColors.primary
                    : Colors.grey.shade200,
              ),
            );
          }

          // ── ប្រសិនបើជួរទីតាំងជាលេខគូ = បង្ហាញរង្វង់ Icon ──
          final stepIndex = index ~/ 2;
          final isActive = currentStep == stepIndex;
          final isCompleted = currentStep > stepIndex;

          // កំណត់ពណ៌ទៅតាមស្ថានភាពនៃជំហាន
          Color iconColor;
          Color circleColor;
          Color borderColor;

          if (isCompleted) {
            iconColor = Colors.white;
            circleColor = AppColors.primary;
            borderColor = AppColors.primary;
          } else if (isActive) {
            iconColor = AppColors.primary;
            circleColor = AppColors.primary.withValues(alpha: 0.1);
            borderColor = AppColors.primary;
          } else {
            // មិនទាន់ទៅដល់
            iconColor = Colors.grey.shade400;
            circleColor = Colors.white;
            borderColor = Colors.grey.shade300;
          }

          return SizedBox(
            width: 65, // ទំហំថេរដើម្បីកុំឱ្យអក្សររុញគ្នា
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // រង្វង់ Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: isActive ? 2 : 1.5,
                    ),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_rounded
                        : steps[stepIndex]['icon'],
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 8),
                // អក្សរខាងក្រោម
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    steps[stepIndex]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive || isCompleted
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isActive || isCompleted
                          ? AppColors.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
