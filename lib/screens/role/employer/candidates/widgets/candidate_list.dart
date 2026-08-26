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
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final applicants = controller.applicants;
      final isSelectionMode = controller.isSelectionMode;
      final isLoadMore = controller.isLoadMore.value;

      if (isLoading) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, _) => const CandidateShimmer(),
        );
      }

      if (applicants.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.refreshApplicants,
          color: AppColors.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Center(
                child: Text(
                  "No candidates found for this status.".tr, // 🟢 Added .tr
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade500, // 🟢 Dynamic Text
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshApplicants,
        color: AppColors.primary,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoadMore &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 50) {
              controller.loadMoreApplicants();
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: applicants.length + (isLoadMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == applicants.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final applicant = applicants[index];
              final isSelected = controller.selectedApplicantIds.contains(
                applicant.applicationId,
              );

              return CandidateCard(
                applicant: applicant,
                isSelected: isSelected,
                onTap: () {
                  if (isSelectionMode) {
                    controller.toggleSelection(applicant.applicationId);
                  }
                },
                onLongPress: () {
                  controller.toggleSelection(applicant.applicationId);
                },
              );
            },
          ),
        ),
      );
    });
  }
}
