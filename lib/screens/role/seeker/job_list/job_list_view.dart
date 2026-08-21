import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_feed_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/job_list/widgets/job_card_vertical.dart';

import '../home_seeker/widgets/job_ui_utils.dart';
import '../home_seeker/widgets/shimmer_box.dart';

part 'job_list_binding.dart';
part 'job_list_controller.dart';

class JobListView extends GetView<JobListViewController> {
  const JobListView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ទាញយក Category Controller មកប្រើ
    final categoryCtrl = Get.put(CategoryController());

    // ឆែកមើលបើទទេ ហៅ API ទាញយក Category ម្តងទៀត
    if (categoryCtrl.categories.isEmpty) {
      categoryCtrl.fetchCategories();
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.pageTitle.value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => controller.fetchJobs(isRefresh: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 ១. បង្ហាញ Category Filter តែនៅពេលវាជា Recent Jobs ប៉ុណ្ណោះ
            Obx(() {
              if (controller.listType.value == 'recent') {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: _buildCategoryFilter(categoryCtrl),
                );
              }
              return const SizedBox.shrink();
            }),

            // 🎯 ២. ផ្នែកបញ្ជីការងារ (Infinite Scroll)
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // អូសដល់ក្រោមសល់ 100 pixels ទាញយកបន្ត
                  if (!controller.isLoadingMore.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 100) {
                    controller.fetchJobs();
                  }
                  return false;
                },
                child: Obx(() => _buildJobContent()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ផ្នែក UI សម្រាប់ Category Filter ───
  Widget _buildCategoryFilter(CategoryController categoryCtrl) {
    return SizedBox(
      height: 38,
      child: Obx(() {
        // បង្ហាញ Shimmer ពេលកំពុង Load Categories
        if (categoryCtrl.isLoading.value && categoryCtrl.categories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ShimmerBox(
              width: double.infinity,
              height: 38,
              borderRadius: 20,
            ),
          );
        }

        final currentSelectedId = controller.selectedCategoryId.value;

        // បន្ថែមជម្រើស "All" នៅខាងដើមបញ្ជី[cite: 4]
        final allItem = {'id': '', 'name': 'All'};
        final items = [
          allItem,
          ...categoryCtrl.categories.map((c) => {'id': c.id, 'name': c.name}),
        ];

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = currentSelectedId == item['id'];

            return GestureDetector(
              onTap: () => controller.onCategorySelected(item['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBorder,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  item['name']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ─── ផ្នែក UI សម្រាប់បញ្ជីការងារ ───
  Widget _buildJobContent() {
    // ករណីកំពុង Load ដំបូង
    if (controller.isLoading.value && controller.jobs.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (_, _) => const ShimmerBox(
          width: double.infinity,
          height: 168,
          borderRadius: 20,
        ),
      );
    }

    // ករណីគ្មានទិន្នន័យ
    if (controller.jobs.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: Get.height * 0.2),
          JobUiUtils.buildInlineEmptyState('No jobs found'),
        ],
      );
    }

    // ករណីមានទិន្នន័យ
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount:
          controller.jobs.length + (controller.hasMoreData.value ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        // រង្វង់ Loading នៅចុងបញ្ជី
        if (index == controller.jobs.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final job = controller.jobs[index];
        return JobCardVertical(
          job: job,
          onTap: () {
            Get.toNamed(AppRoutes.jobDetail, arguments: job)?.then((
              updatedJob,
            ) {
              if (updatedJob != null) {
                int i = controller.jobs.indexOf(job);
                if (i != -1) controller.jobs[i] = updatedJob;
              }
            });
          },
          onBookmarkTap: () => controller.toggleSaveJob(index),
        );
      },
    );
  }
}
