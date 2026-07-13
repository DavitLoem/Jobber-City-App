import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/role/employer/company_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/models/master_data_model.dart';
import 'package:jobber_city/models/role/employer/company_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/company_profile/widget/custom_card.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';

part 'company_profile_binding.dart';
part 'company_profile_controller.dart';

class CompanyProfileView extends GetView<CompanyProfileViewController> {
  const CompanyProfileView({super.key});

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
                        Get.back(); // បិទ BottomSheet ពេលរើសរួច
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
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          "Company Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        // បង្ហាញ Loading ពេលកំពុងទាញយកទិន្នន័យដំបូង (Initial Data)
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildLogoUpload(),
              const SizedBox(height: 20),

              CustomCard(
                title: "Basic Information",
                icon: Icons.business,
                children: [
                  CustomTextfield(
                    hintText: "Company Name",
                    prefixIcon: Icons.apartment,
                    controller: controller.companyNameController,
                  ),
                  const SizedBox(height: 15),

                  // 🟢 ប្រអប់ Industry ដែលអាចចុចរើសបានពី API
                  CustomTextfield(
                    hintText: "Select Industry",
                    prefixIcon: Icons.category_outlined,
                    suffixIcon: Icons.keyboard_arrow_down,
                    controller: controller.industryCtrl,
                    readOnly: true,
                    onTap: () {
                      if (controller.industriesList.isEmpty) {
                        Get.snackbar(
                          "Notice",
                          "Industries are loading or failed to load.",
                        );
                        return;
                      }
                      // ប្រើ MasterDataModel ជំនួស IndustryModel
                      _showPicker<MasterDataModel>(
                        context: context,
                        title: "Select Industry",
                        // Cast ទៅជា List<MasterDataModel> ឱ្យប្រាកដ
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
                  const SizedBox(height: 15),

                  CustomTextfield(
                    hintText: "Company Size",
                    prefixIcon: Icons.group_outlined,
                    suffixIcon: Icons.keyboard_arrow_down,
                    controller: controller.companySizeCtrl,
                    readOnly: true,
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
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: controller.descriptionCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Company Description (Min 10 characters)...",
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),

              CustomCard(
                title: "Contact & Location",
                icon: Icons.contact_mail_outlined,
                children: [
                  CustomTextfield(
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                    controller: controller.contactEmailController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    hintText: "Phone Number",
                    prefixIcon: Icons.phone_outlined,
                    controller: controller.contactPhoneController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    hintText: "Website URL (Optional)",
                    prefixIcon: Icons.language_outlined,
                    controller: controller.websiteUrlController,
                  ),
                  const SizedBox(height: 15),

                  // 🟢 ប្រអប់ Province
                  CustomTextfield(
                    hintText: "Select Province",
                    prefixIcon: Icons.map_outlined,
                    suffixIcon: Icons.keyboard_arrow_down,
                    controller: controller.provinceCtrl,
                    readOnly: true,
                    onTap: () => _showPicker<LocationModel>(
                      context: context,
                      title: "Select Province",
                      // 🎯 ទាញយកបញ្ជីខេត្តចេញពី Global Location Controller ផ្ទាល់
                      items: controller.locationCtrl.provinces,
                      getName: (item) => item.nameEn,
                      onSelected: (item) {
                        controller.provinceCtrl.text = item.nameEn;
                        controller.selectedProvinceId.value = item.id
                            .toString();

                        // លុបស្រុកចាស់ចោល ពេលគាត់ដូរខេត្តថ្មី
                        controller.districtCtrl.clear();
                        controller.selectedDistrictId.value = '';

                        // ហៅទាញយកស្រុករបស់ខេត្តថ្មីនេះ
                        controller.fetchDistricts(
                          controller.selectedProvinceId.value,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🟢 ប្រអប់ District
                  CustomTextfield(
                    hintText: "Select District",
                    prefixIcon: Icons.location_city_outlined,
                    suffixIcon: Icons.keyboard_arrow_down,
                    controller: controller.districtCtrl,
                    readOnly: true,
                    onTap: () {
                      if (controller.selectedProvinceId.value.isEmpty) {
                        Get.snackbar(
                          "Notice",
                          "Please select a Province first",
                        );
                        return;
                      }

                      // ប្រើ LocationModel ជំនួស DistrictModel
                      _showPicker<LocationModel>(
                        context: context,
                        title: "Select District",
                        items: controller.districtsList.cast<LocationModel>(),
                        getName: (item) => item.nameEn,
                        onSelected: (item) {
                          controller.districtCtrl.text = item.nameEn;
                          controller.selectedDistrictId.value = item.id
                              .toString();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  CustomTextfield(
                    hintText: "Address Detail",
                    prefixIcon: Icons.home_outlined,
                    controller: controller.addressDetailController,
                  ),
                ],
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: controller.isLoading.value
                      ? "Saving..."
                      : "Save Profile",
                  onPressed: controller.isLoading.value
                      ? () {}
                      : controller.saveProfile,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLogoUpload() {
    return Center(
      child: Column(
        children: [
          _LogoTapScale(
            onTap: controller.pickCompanyLogo,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
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
                          size: 40,
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
          const SizedBox(height: 12),
          const Text(
            "Upload Company Logo",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoTapScale extends StatefulWidget {
  const _LogoTapScale({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_LogoTapScale> createState() => _LogoTapScaleState();
}

class _LogoTapScaleState extends State<_LogoTapScale> {
  double _scale = 1.0;
  void _setScale(double value) => setState(() => _scale = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setScale(0.92),
      onTapUp: (_) => _setScale(1.0),
      onTapCancel: () => _setScale(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
