import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../candidates_view.dart';
import 'candidate_card.dart';
import 'candidate_shimmer.dart';

class CandidateList extends GetView<CandidatesViewController> {
  final String status;
  const CandidateList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ១. បង្ហាញ Shimmer ពេលកំពុង Load API
      if (controller.isLoading.value &&
          controller.currentStatus.value == status) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, _) => const CandidateShimmer(),
        );
      }

      // ២. បង្ហាញ UI ទទេ ពេលគ្មានទិន្នន័យ
      if (controller.applicants.isEmpty ||
          controller.currentStatus.value != status) {
        return Center(
          child: Text(
            "No candidates found for this status.",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        );
      }

      // ៣. បង្ហាញបញ្ជីទិន្នន័យពិត
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: controller.applicants.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final applicant = controller.applicants[index];
          return CandidateCard(applicant: applicant);
        },
      );
    });
  }
}
