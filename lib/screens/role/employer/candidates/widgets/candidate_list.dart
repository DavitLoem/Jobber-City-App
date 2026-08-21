import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../candidates_view.dart';
import 'candidate_card.dart';
import 'candidate_shimmer.dart';

class CandidateList extends GetView<CandidatesViewController> {
  const CandidateList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final applicants = controller.applicants;
      final isSelectionMode = controller.isSelectionMode;
      final isLoadMore = controller.isLoadMore.value; // 🟢 ចាប់យកការ Load More

      if (isLoading) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, _) => const CandidateShimmer(),
        );
      }

      if (applicants.isEmpty) {
        // 🟢 ផ្តល់សមត្ថភាព Refresh សូម្បីតែបញ្ជីទទេ
        return RefreshIndicator(
          onRefresh: controller.refreshApplicants,
          color: const Color(0xFF4f7df7),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Center(
                child: Text(
                  "No candidates found for this status.",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                ),
              ),
            ],
          ),
        );
      }

      // 🟢 រុំជាមួយ RefreshIndicator និង NotificationListener
      return RefreshIndicator(
        onRefresh: controller.refreshApplicants,
        color: const Color(0xFF4f7df7),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // 🟢 បើអូសជិតដល់ក្រោម (សល់ 50 pixels) ហៅ loadMore
            if (!isLoadMore &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 50) {
              controller.loadMoreApplicants();
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            // 🟢 បូក 1 បើសិនជាកំពុង Load More ដើម្បីគូរ Loading ខាងក្រោម
            itemCount: applicants.length + (isLoadMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              // 🟢 គូរ Loading វិលៗនៅក្រោមគេ
              if (index == applicants.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF4f7df7)),
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
