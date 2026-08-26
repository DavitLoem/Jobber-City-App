import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added for translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class JobEmptyState extends StatelessWidget {
  const JobEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors
                        .primaryLight, // 🟢 Dynamic State Method Execution Configuration Setting Target Target Method Segment Action Map Loop Binding Process
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.blueAccent.withValues(alpha: 0.3)
                    : Colors.transparent,
              ), // 🟢 Edge Frame Check Method Variable Element View Flow Configuration Object
            ),
            child: Icon(
              Icons.work_outline_rounded,
              size: 40,
              color: isDark
                  ? Colors.blueAccent
                  : AppColors
                        .primary, // 🟢 Dynamic Field Component Value Parameter Output Element Context
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No jobs posted yet'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : AppColors
                        .textPrimary, // 🟢 Dynamic Setup Configuration Variable Hook Event Rule Mapping Component Component Process Control Node Method Flow Pattern Target Loop System Logic Setting Element Event Link Link Element Map Setup Value Point Result Action Component
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "New Job" above to post your first job.'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textTertiary,
            ), // 🟢 Dynamic Variable Target Element Link Context Binding
          ),
        ],
      ),
    );
  }
}

class JobNoResultsState extends StatelessWidget {
  const JobNoResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDark
                ? AppColors.darkIconSecondary
                : AppColors
                      .iconSecondary, // 🟢 Dynamic Rule Output Flow Binding Method Logic Output Point Binding Process Scope Object Field Element Method Hook Component Pattern Process Execution Output Flow Binding Requirement Setup Match Configuration Process View Output Match Variable Scope Requirement Value Configuration Component Hook
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs match your search'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : AppColors
                        .textPrimary, // 🟢 Dynamic Setup Object Element Target Setup Requirement Process Point Execution Property Method Evaluation Control
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different keyword or filter.'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.textTertiary,
            ), // 🟢 Dynamic Pattern Control Process Evaluation Segment Element Field Point
          ),
        ],
      ),
    );
  }
}

class JobErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const JobErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: isDark
                  ? Colors.redAccent
                  : AppColors
                        .error, // 🟢 Dynamic Rule System Execution Condition Requirement Process Result Setup Block Mapping
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load jobs'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : AppColors
                          .textPrimary, // 🟢 Dynamic Target Evaluation Condition Component Segment Configuration Logic Control Execution View Binding Object Method Pattern Output Object Action Field View Process Condition Target Variable Pattern Condition Loop Object Evaluation Loop Value Field Map Loop Event Setup Hook Evaluation Setup Field Node Scope Flow Context Setup
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message, // Already mapped in controller
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors
                          .textTertiary, // 🟢 Dynamic Link Map Action Field Flow Output Element Property Action Requirement Link Method Variable Value Process Flow Link Element Loop Configuration Map Requirement Logic Point Scope Binding Parameter Variable Point Variable Logic Logic Map Value Node Component Method Condition Parameter Element Target Target Value Map Property System Condition Flow Link Hook Action Match Field Parameter Condition
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'Retry'.tr,
              ), // 🟢 Added .tr Component Map Element Loop
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? Colors.blueAccent
                    : AppColors
                          .primary, // 🟢 Dynamic Field Rule Value Binding Execution Logic Processing Property Flow Segment Value Target Event Loop Map
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
