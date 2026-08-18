import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

import '../candidates_view.dart';
import 'candidate_card.dart';
import 'candidate_shimmer.dart';

class CandidateList extends GetView<CandidatesViewController> {
  const CandidateList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, _) => const CandidateShimmer(),
        );
      }

      if (controller.applicants.isEmpty) {
        return Center(
          child: Text(
            "No candidates found for this status.".tr, // 🟢 Added .tr
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey.shade500, // 🟢 Dynamic Text
              fontSize: 15,
            ),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: controller.applicants.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return CandidateCard(applicant: controller.applicants[index]);
        },
      );
    });
  }
}
