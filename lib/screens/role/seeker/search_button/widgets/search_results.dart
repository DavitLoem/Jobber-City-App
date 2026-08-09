import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/job_list/widgets/job_card_vertical.dart'; // ត្រូវប្រាកដថា Path ត្រឹមត្រូវ[cite: 14]

import '../search_button_controller.dart';

class SearchResults extends GetView<SearchButtonViewController> {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSearching.value && controller.searchResults.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.searchResults.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No jobs found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try searching for different keywords',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!controller.isLoadingMore.value &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 100) {
            controller.performSearch();
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount:
              controller.searchResults.length +
              (controller.hasMoreData.value ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == controller.searchResults.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            final job = controller.searchResults[index];

            return JobCardVertical(
              job: job,
              onTap: () {
                controller.saveRecentSearch(controller.searchController.text);
                Get.toNamed(AppRoutes.jobDetail, arguments: job)?.then((
                  updatedJob,
                ) {
                  if (updatedJob != null) {
                    int i = controller.searchResults.indexOf(job);
                    if (i != -1) controller.searchResults[i] = updatedJob;
                  }
                });
              },
              onBookmarkTap: () {
                job.isSaved = !job.isSaved;
                controller.searchResults.refresh();
              },
            );
          },
        ),
      );
    });
  }
}
