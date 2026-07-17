import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/employer/job_post_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/employer_job_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/recruit/recruit_screen/widgets/button/job_filter_chip_bar.dart';
import 'package:jobber_city/screens/role/employer/recruit/recruit_screen/widgets/button/job_search_bar.dart';
import 'package:jobber_city/screens/role/employer/recruit/recruit_screen/widgets/counts/job_card.dart';
import 'package:jobber_city/screens/role/employer/recruit/recruit_screen/widgets/counts/job_list_states.dart';

import 'widgets/recruit_app_header.dart';

part 'recruit_screen_binding.dart';
part 'recruit_screen_controller.dart';

class RecruitScreenView extends GetView<RecruitScreenViewController> {
  const RecruitScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceVariant,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => RecruitAppHeader(
                totalJobs: controller.jobs.length,
                onNewJob: _onNewJob,
              ),
            ),
            Obx(
              () => JobSearchBar(
                onChanged: (v) => controller.searchQuery.value = v,
                sortAscending: controller.sortAscending.value,
                onSortTap: controller.toggleSortOrder,
              ),
            ),
            Obx(
              () => JobFilterChipBar(
                options: RecruitScreenViewController.filterOptions,
                selected: controller.selectedFilter.value,
                counts: controller.statusCounts
                  ..['All'] = controller.jobs.length,
                onSelect: controller.setFilter,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(child: _buildJobList()),
          ],
        ),
      ),
    );
  }

  Future<void> _onNewJob() async {
    final posted = await Get.toNamed(AppRoutes.postJob);
    if (posted == true) {
      controller.refreshJobs();
    }
  }

  Widget _buildJobList() {
    return Obx(() {
      if (controller.isLoading.value && controller.jobs.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.errorMessage.value.isNotEmpty && controller.jobs.isEmpty) {
        return JobErrorState(
          message: controller.errorMessage.value,
          onRetry: controller.fetchJobs,
        );
      }

      if (controller.jobs.isEmpty) {
        return const JobEmptyState();
      }

      final list = controller.filteredJobs;

      if (list.isEmpty) {
        return const JobNoResultsState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshJobs,
        color: AppColors.primary,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final job = list[index];
            return JobCard(
              job: job,
              statusGroup: controller.statusGroup(job.status),
              onTap: () => Get.toNamed(AppRoutes.detailPost, arguments: job),
            );
          },
        ),
      );
    });
  }
}
