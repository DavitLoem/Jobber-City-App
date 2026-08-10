import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../candidates_view.dart';
import 'candidate_card.dart';
import 'candidate_shimmer.dart';

class CandidateList extends GetView<CandidatesViewController> {
  // 🎯 ១. លុប final String status; និង required this.status ចេញ
  const CandidateList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 🎯 ២. លុបលក្ខខណ្ឌដែលឆែក status ចាស់ៗចេញ

      // បង្ហាញ Shimmer ពេលកំពុង Load API
      if (controller.isLoading.value) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, _) => const CandidateShimmer(),
        );
      }

      // បង្ហាញ UI ទទេ ពេលគ្មានទិន្នន័យ
      if (controller.applicants.isEmpty) {
        return Center(
          child: Text(
            "No candidates found for this status.",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        );
      }

      // បង្ហាញបញ្ជីទិន្នន័យពិត
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
