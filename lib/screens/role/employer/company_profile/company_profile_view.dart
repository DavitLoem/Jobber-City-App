import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/role/employer/company_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/models/master_data_model.dart';
import 'package:jobber_city/models/role/employer/company_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../core/utils/token_storage.dart';
import '../../../../widgets/custom_form_textfield.dart';
import 'widgets/profile_section_card.dart.dart';

part 'company_profile_binding.dart';
part 'company_profile_controller.dart';

class CompanyProfileView extends GetView<CompanyProfileViewController> {
  const CompanyProfileView({super.key});

  // មុខងារបង្ហាញ BottomSheet សម្រាប់ជ្រើសរើសទិន្នន័យ (រក្សាទុកដូចដើម)
  void _showPicker<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) getName,
    required void Function(T) onSelected,
  }) {
    TextEditingController searchCtrl = TextEditingController();
    RxList<T> filteredItems = items.toList().obs;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.65,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                filteredItems.value = items
                    .where(
                      (item) => getName(
                        item,
                      ).toLowerCase().contains(value.toLowerCase()),
                    )
                    .toList();
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(getName(item)),
                      onTap: () {
                        onSelected(item);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Company Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 30),

              // ── ផ្នែកទី១: Basic Information ──
              ProfileSectionCard(
                title: "Company Identity",
                subtitle: "Tell us about your business",
                children: [
                  CustomFormTextField(
                    label: "Company Name *",
                    hint: "e.g. Jobber City Co., Ltd.",
                    controller: controller.companyNameController,
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Industry *",
                    hint: "Select your industry",
                    isDropdown: true,
                    controller: controller.industryCtrl,
                    onTap: () {
                      if (controller.industriesList.isEmpty) {
                        Get.snackbar("Notice", "Industries are loading.");
                        return;
                      }
                      _showPicker<MasterDataModel>(
                        context: context,
                        title: "Select Industry",
                        items: controller.industriesList
                            .cast<MasterDataModel>(),
                        getName: (item) => item.name,
                        onSelected: (item) {
                          controller.industryCtrl.text = item.name;
                          controller.selectedIndustryId.value = item.id;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Company Size *",
                    hint: "Select company size",
                    isDropdown: true,
                    controller: controller.companySizeCtrl,
                    onTap: () => _showPicker<String>(
                      context: context,
                      title: "Select Company Size",
                      items: controller.companySizes,
                      getName: (item) => item,
                      onSelected: (item) {
                        controller.companySizeCtrl.text = item;
                        controller.selectedCompanySize.value = item;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Description *",
                    hint: "Briefly describe your company (min 10 chars)...",
                    maxLines: 4,
                    controller: controller.descriptionCtrl,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── ផ្នែកទី២: Contact & Location ──
              ProfileSectionCard(
                title: "Contact & Location",
                subtitle: "Where can candidates find you?",
                children: [
                  CustomFormTextField(
                    label: "Contact Email *",
                    hint: "hr@company.com",
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.contactEmailController,
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Phone Number *",
                    hint: "+855 12 345 678",
                    keyboardType: TextInputType.phone,
                    controller: controller.contactPhoneController,
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Website (Optional)",
                    hint: "https://www.company.com",
                    controller: controller.websiteUrlController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormTextField(
                          label: "Province *",
                          hint: "Select Province",
                          isDropdown: true,
                          controller: controller.provinceCtrl,
                          onTap: () => _showPicker<LocationModel>(
                            context: context,
                            title: "Select Province",
                            items: controller.locationCtrl.provinces,
                            getName: (item) => item.nameEn,
                            onSelected: (item) {
                              controller.provinceCtrl.text = item.nameEn;
                              controller.selectedProvinceId.value = item.id
                                  .toString();
                              controller.districtCtrl.clear();
                              controller.selectedDistrictId.value = '';
                              controller.fetchDistricts(
                                controller.selectedProvinceId.value,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomFormTextField(
                          label: "District *",
                          hint: "Select District",
                          isDropdown: true,
                          controller: controller.districtCtrl,
                          onTap: () {
                            if (controller.selectedProvinceId.value.isEmpty) {
                              Get.snackbar(
                                "Notice",
                                "Please select a Province first",
                              );
                              return;
                            }
                            _showPicker<LocationModel>(
                              context: context,
                              title: "Select District",
                              items: controller.districtsList
                                  .cast<LocationModel>(),
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
                    label: "Address Detail *",
                    hint: "Street 123, Sangkat...",
                    maxLines: 2,
                    controller: controller.addressDetailController,
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space សម្រាប់ប៊ូតុងខាងក្រោម
            ],
          ),
        );
      }),
      // ── ប៊ូតុង Save ស្អិតជាប់ខាងក្រោម ──
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.saveProfile,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Save Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── ផ្នែករចនាការ Upload Logo ──
  Widget _buildHeaderSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.pickCompanyLogo,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    image: controller.companyLogoPath.value.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(
                              File(controller.companyLogoPath.value),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.companyLogoPath.value.isEmpty
                      ? const Icon(
                          Icons.business,
                          size: 35,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Upload Company Logo",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Recommended size: 500x500px",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
