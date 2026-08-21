import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../search_button_controller.dart';

class ActiveFilterChips extends GetView<SearchButtonViewController> {
  const ActiveFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ទាញយក Controllers ដើម្បីយកឈ្មោះរបស់ ID នីមួយៗ
    final categoryCtrl = Get.find<CategoryController>();
    final locationCtrl = Get.find<LocationController>();
    final masterDataCtrl = Get.find<MasterDataController>();

    return Obx(() {
      // បើអត់មាន Filter ទេ មិនបាច់បង្ហាញរបារនេះឡើយ
      if (controller.activeFiltersCount.value == 0) {
        return const SizedBox.shrink();
      }

      List<Widget> chips = [];

      // អនុគមន៍ជំនួយសម្រាប់គូរ Chip នីមួយៗ
      Widget buildChip(String label, String filterType) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () =>
                    controller.removeFilter(filterType), // 🎯 ហៅមុខងារលុប
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      }

      // ១. Category
      if (controller.selectedCategoryId.value != null) {
        final cat = categoryCtrl.categories.firstWhereOrNull(
          (c) => c.id.toString() == controller.selectedCategoryId.value,
        );
        if (cat != null) chips.add(buildChip(cat.name.toString(), 'category'));
      }

      // ២. Location (Province)
      if (controller.selectedProvinceId.value != null) {
        final prov = locationCtrl.provinces.firstWhereOrNull(
          (p) => p.id.toString() == controller.selectedProvinceId.value,
        );
        if (prov != null) {
          chips.add(buildChip(prov.nameEn.toString(), 'province'));
        }
      }

      // ៣. Salary Range
      if (controller.minSalary.value != null ||
          controller.maxSalary.value != null) {
        double min = controller.minSalary.value ?? 100;
        double max = controller.maxSalary.value ?? 3000;
        String label = max >= 3000
            ? '\$${min.toInt()} - \$3000+'
            : '\$${min.toInt()} - \$${max.toInt()}';
        chips.add(buildChip(label, 'salary'));
      }

      // ៤. Employment Type
      if (controller.selectedEmploymentTypeId.value != null) {
        final name = masterDataCtrl.getMasterDataName(
          'employment-types',
          controller.selectedEmploymentTypeId.value!,
        );
        chips.add(buildChip(name, 'employmentType'));
      }

      // ៥. Industry
      if (controller.selectedIndustryId.value != null) {
        final name = masterDataCtrl.getMasterDataName(
          'industries',
          controller.selectedIndustryId.value!,
        );
        chips.add(buildChip(name, 'industry'));
      }

      // ៦. Job Level
      if (controller.selectedJobLevelId.value != null) {
        final name = masterDataCtrl.getMasterDataName(
          'job-levels',
          controller.selectedJobLevelId.value!,
        );
        chips.add(buildChip(name, 'jobLevel'));
      }

      if (chips.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 48,
        padding: const EdgeInsets.only(top: 14),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, index) => chips[index],
        ),
      );
    });
  }
}
