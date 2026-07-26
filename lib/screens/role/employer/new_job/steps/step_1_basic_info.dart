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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Basic Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Tell candidates what this position is about",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),

            // ── 1. Company Logo ──
            _buildCompanyLogo(),
            const SizedBox(height: 24),

            // ── 2. Job Title ──
            CustomFormTextField(
              label: "Job Title *",
              hint: "e.g. Senior Flutter Developer",
              controller: controller.titleCtrl,
            ),
            const SizedBox(height: 16),

            // ── 3. Location (Province & District ក្នុងជួរតែមួយ) ──
            Row(
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "Province *",
                    hint: "Select Province",
                    controller: controller.provinceCtrl,
                    isDropdown: true,
                    onTap: () {
                      if (controller.locationDataCtrl.provinces.isEmpty) return;

                      CustomBottomSheetPicker.show<LocationModel>(
                        title: "Select Province",
                        items: controller.locationDataCtrl.provinces,
                        getName: (item) => item.nameEn,
                        onSelected: (item) {
                          controller.provinceCtrl.text = item.nameEn;
                          controller.selectedProvinceId.value = item.id
                              .toString();

                          // លុបស្រុកចាស់ចោល ពេលរើសខេត្តថ្មី
                          controller.districtCtrl.clear();
                          controller.selectedDistrictId.value = '';

                          // ទាញយកស្រុកថ្មី
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
                    label: "District *",
                    hint: "Select District",
                    isDropdown: true,
                    controller: controller.districtCtrl,
                    onTap: () async {
                      if (controller.selectedProvinceId.value.isEmpty) {
                        Get.snackbar(
                          "Notice",
                          "Please select a Province first",
                        );
                        return;
                      }

                      // រង់ចាំទាញទិន្នន័យស្រុកពី Cache
                      final dists = await controller.locationDataCtrl
                          .getDistricts(controller.selectedProvinceId.value);

                      CustomBottomSheetPicker.show<LocationModel>(
                        title: "Select District",
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

            // ── 4. Category ──
            CustomFormTextField(
              label: "Category *",
              hint: "Select job category",
              isDropdown: true,
              controller: controller.categoryTextCtrl,
              onTap: () {
                if (controller.categoryDataCtrl.categories.isEmpty) return;

                CustomBottomSheetPicker.show<CategoryModel>(
                  title: "Select Category",
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

            // ── 5. Job Level ──
            CustomFormTextField(
              label: "Job Level *",
              hint: "Select level (e.g. Senior, Junior)",
              isDropdown: true,
              controller: controller.jobLevelCtrl,
              onTap: () async {
                final levels = await controller.masterDataCtrl.getMasterData(
                  endpoint: 'job-levels',
                );

                CustomBottomSheetPicker.show<MasterDataModel>(
                  title: "Select Job Level",
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
              label: "Work Type *",
              hint: "e.g. On-site, Remote, Hybrid",
              isDropdown: true,
              controller: controller.workTypeCtrl,
              onTap: () async {
                // ទាញទិន្នន័យពី Master Data
                final workTypes = await controller.masterDataCtrl.getMasterData(
                  endpoint: 'work-types',
                );

                CustomBottomSheetPicker.show<MasterDataModel>(
                  title: "Select Work Type",
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

            // ── 6. Employment Type & Headcount ──
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomFormTextField(
                    label: "Employment Type *",
                    hint: "e.g. Full-time",
                    isDropdown: true,
                    controller: controller.employmentTypeCtrl,
                    onTap: () async {
                      final empTypes = await controller.masterDataCtrl
                          .getMasterData(endpoint: 'employment-types');

                      CustomBottomSheetPicker.show<MasterDataModel>(
                        title: "Select Employment Type",
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
                    label: "Headcount *",
                    hint: "e.g. 2",
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

  // ── ផ្នែករចនា Company Logo ──
  Widget _buildCompanyLogo() {
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
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
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
                    : const Icon(
                        Icons.camera_alt_rounded,
                        size: 32,
                        color: AppColors.primary,
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Company Logo",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap to change logo for this job",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }
}
