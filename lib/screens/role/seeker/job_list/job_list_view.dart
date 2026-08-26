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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categoryCtrl = Get.put(CategoryController());

    if (categoryCtrl.categories.isEmpty) {
      categoryCtrl.fetchCategories();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Icon
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.pageTitle.value,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
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
            Obx(() {
              if (controller.listType.value == 'recent') {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: _buildCategoryFilter(categoryCtrl, theme, isDark),
                );
              }
              return const SizedBox.shrink();
            }),

            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoadingMore.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 100) {
                    controller.fetchJobs();
                  }
                  return false;
                },
                child: Obx(() => _buildJobContent(theme, isDark)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(
    CategoryController categoryCtrl,
    ThemeData theme,
    bool isDark,
  ) {
    return SizedBox(
      height: 38,
      child: Obx(() {
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
                  color: isSelected
                      ? AppColors.primary
                      : theme.cardColor, // 🟢 Dynamic BG
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.darkCardBorder
                              : AppColors.cardBorder), // 🟢 Dynamic Border
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: 0.25,
                            ), // 🟢 Updated to withValues
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  item['name']!.tr, // 🟢 Added .tr
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
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

  Widget _buildJobContent(ThemeData theme, bool isDark) {
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

    if (controller.jobs.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: Get.height * 0.2),
          JobUiUtils.buildInlineEmptyState('No jobs found'.tr), // 🟢 Added .tr
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount:
          controller.jobs.length + (controller.hasMoreData.value ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
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
          isDark: isDark, // 🟢 Pass Theme State Down
          theme: theme, // 🟢 Pass Theme Context Down
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
