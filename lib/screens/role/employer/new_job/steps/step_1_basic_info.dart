import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/category_model.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/models/master_data_model.dart';
import 'package:jobber_city/widgets/custom_bottom_sheet_picker.dart';
import 'package:jobber_city/widgets/custom_form_textfield.dart';

import '../../employer_profile/employer_profile_view.dart';
import '../new_job_view.dart';

class Step1BasicInfo extends GetView<NewJobViewController> {
  const Step1BasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : Colors.white, // 🟢 Dynamic Step Form BG
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
          ), // 🟢 Dynamic Border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Basic Information".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Section Title
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Tell candidates what this position is about".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade500,
              ), // 🟢 Dynamic Subtext
            ),
            const SizedBox(height: 24),

            _buildCompanyLogo(isDark), // 🟢 Pass Theme Context
            const SizedBox(height: 24),

            CustomFormTextField(
              label: "Job Title *".tr, // 🟢 Added .tr
              hint: "e.g. Senior Flutter Developer".tr, // 🟢 Added .tr
              controller: controller.titleCtrl,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "Province *".tr, // 🟢 Added .tr
                    hint: "Select Province".tr, // 🟢 Added .tr
                    controller: controller.provinceCtrl,
                    isDropdown: true,
                    onTap: () {
                      if (controller.locationDataCtrl.provinces.isEmpty) return;

                      CustomBottomSheetPicker.show<LocationModel>(
                        title: "Select Province".tr, // 🟢 Added .tr
                        items: controller.locationDataCtrl.provinces,
                        getName: (item) => item
                            .nameEn, // Ideally dynamically handled by model translations if active
                        onSelected: (item) {
                          controller.provinceCtrl.text = item.nameEn;
                          controller.selectedProvinceId.value = item.id
                              .toString();

                          controller.districtCtrl.clear();
                          controller.selectedDistrictId.value = '';

                          controller.locationDataCtrl.getDistricts(
                            item.id.toString(),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormTextField(
                    label: "District *".tr, // 🟢 Added .tr
                    hint: "Select District".tr, // 🟢 Added .tr
                    isDropdown: true,
                    controller: controller.districtCtrl,
                    onTap: () async {
                      if (controller.selectedProvinceId.value.isEmpty) {
                        Get.snackbar(
                          "Notice".tr, // 🟢 Added .tr
                          "Please select a Province first".tr, // 🟢 Added .tr
                          backgroundColor: isDark
                              ? Colors.orangeAccent.withValues(alpha: 0.15)
                              : Colors.orangeAccent,
                          colorText: isDark
                              ? Colors.orangeAccent
                              : Colors.white,
                        );
                        return;
                      }

                      final dists = await controller.locationDataCtrl
                          .getDistricts(controller.selectedProvinceId.value);

                      CustomBottomSheetPicker.show<LocationModel>(
                        title: "Select District".tr, // 🟢 Added .tr
                        items: dists,
                        getName: (item) => item.nameEn,
                        onSelected: (item) {
                          controller.districtCtrl.text = item.nameEn;
                          controller.selectedDistrictId.value = item.id
                              .toString();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Category *".tr, // 🟢 Added .tr
              hint: "Select job category".tr, // 🟢 Added .tr
              isDropdown: true,
              controller: controller.categoryTextCtrl,
              onTap: () {
                if (controller.categoryDataCtrl.categories.isEmpty) return;

                CustomBottomSheetPicker.show<CategoryModel>(
                  title: "Select Category".tr, // 🟢 Added .tr
                  items: controller.categoryDataCtrl.categories,
                  getName: (item) => item.name,
                  onSelected: (item) {
                    controller.categoryTextCtrl.text = item.name;
                    controller.selectedCategoryId.value = item.id.toString();
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Job Level *".tr, // 🟢 Added .tr
              hint: "Select level (e.g. Senior, Junior)".tr, // 🟢 Added .tr
              isDropdown: true,
              controller: controller.jobLevelCtrl,
              onTap: () async {
                final levels = await controller.masterDataCtrl.getMasterData(
                  endpoint: 'job-levels',
                );

                CustomBottomSheetPicker.show<MasterDataModel>(
                  title: "Select Job Level".tr, // 🟢 Added .tr
                  items: levels,
                  getName: (item) => item.name,
                  onSelected: (item) {
                    controller.jobLevelCtrl.text = item.name;
                    controller.selectedJobLevelId.value = item.id;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            CustomFormTextField(
              label: "Work Type *".tr, // 🟢 Added .tr
              hint: "e.g. On-site, Remote, Hybrid".tr, // 🟢 Added .tr
              isDropdown: true,
              controller: controller.workTypeCtrl,
              onTap: () async {
                final workTypes = await controller.masterDataCtrl.getMasterData(
                  endpoint: 'work-types',
                );

                CustomBottomSheetPicker.show<MasterDataModel>(
                  title: "Select Work Type".tr, // 🟢 Added .tr
                  items: workTypes,
                  getName: (item) => item.name,
                  onSelected: (item) {
                    controller.workTypeCtrl.text = item.name;
                    controller.selectedWorkTypeId.value = item.id;
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomFormTextField(
                    label: "Employment Type *".tr, // 🟢 Added .tr
                    hint: "e.g. Full-time".tr, // 🟢 Added .tr
                    isDropdown: true,
                    controller: controller.employmentTypeCtrl,
                    onTap: () async {
                      final empTypes = await controller.masterDataCtrl
                          .getMasterData(endpoint: 'employment-types');

                      CustomBottomSheetPicker.show<MasterDataModel>(
                        title: "Select Employment Type".tr, // 🟢 Added .tr
                        items: empTypes,
                        getName: (item) => item.name,
                        onSelected: (item) {
                          controller.employmentTypeCtrl.text = item.name;
                          controller.selectedEmploymentTypeId.value = item.id;
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: CustomFormTextField(
                    label: "Headcount *".tr, // 🟢 Added .tr
                    hint: "e.g. 2".tr, // 🟢 Added .tr
                    keyboardType: TextInputType.number,
                    controller: controller.headcountCtrl,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(bool isDark) {
    final profileCtrl = Get.find<EmployerProfileViewController>();
    final profile = profileCtrl.companyProfile.value;
    final hasLogo =
        profile != null &&
        profile.logoUrl != null &&
        profile.logoUrl!.isNotEmpty;
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputBackground
                    : AppColors.primary.withValues(alpha: 0.1), // 🟢 Dynamic BG
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.blueAccent
                      : AppColors.primary.withValues(
                          alpha: 0.2,
                        ), // 🟢 Dynamic Border
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: hasLogo
                    ? Image.network(
                        profile.logoUrl!,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.camera_alt_rounded,
                        size: 32,
                        color: isDark
                            ? Colors.blueAccent
                            : AppColors.primary, // 🟢 Dynamic Placeholder Icon
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Company Logo".tr, // 🟢 Added .tr
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Section
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap to change logo for this job".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade500,
              ), // 🟢 Dynamic Subtext
            ),
          ],
        ),
      ],
    );
  }
}
