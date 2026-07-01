import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/core/api/services/role/district_services.dart';
import 'package:jobber_city/core/api/services/role/location_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/district_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/company_profile/widget/custom_card.dart';
import 'package:jobber_city/screens/role/employer/company_profile/widget/custom_dropdown_textfield.dart';
import 'package:jobber_city/widgets/custom_textfield.dart';
import 'package:jobber_city/widgets/custom_button.dart';
import 'package:jobber_city/models/role/employer/company_model.dart';
import 'package:jobber_city/core/api/services/role/employer/company_services.dart';
import 'package:jobber_city/core/api/services/role/category_services.dart';
import 'package:jobber_city/models/role/category_model.dart';
import 'package:jobber_city/models/role/location_model.dart';

part 'company_profile_binding.dart';
part 'company_profile_controller.dart';

class CompanyProfileView extends GetView<CompanyProfileViewController> {
  const CompanyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Company Profile",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildImageLogo(),
                    const SizedBox(height: 30),
                    _buildCard(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => CustomButton(
          text: controller.isLoading.value ? "Saving..." : "Save Profile",
          onPressed: controller.isLoading.value
              ? () {}
              : controller.submitCompanyProfile,
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Column(
      children: [
        CustomCard(
          title: "Basic Information",
          icon: Icons.business,
          children: [
            CustomTextfield(
              hintText: "Company Name",
              controller: controller.companyNameController,
              prefixIcon: Icons.business,
            ),
            const SizedBox(height: 15),
            Obx(
              () => CustomDropdownTextfield(
                hint: controller.industriesList.isEmpty
                    ? "Loading..."
                    : "Select Industry",
                icon: Icons.category,
                value: controller.selectedIndustryId.value.isNotEmpty
                    ? controller.selectedIndustryId.value
                    : null,
                items: controller.industriesList
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedIndustryId.value = v!,
              ),
            ),
            const SizedBox(height: 15),
            CustomTextfield(
              hintText: "Description",
              controller: controller.descriptionController,
              prefixIcon: Icons.description,
            ),
          ],
        ),
        const SizedBox(height: 15),
        CustomCard(
          title: "Contact Details",
          icon: Icons.contact_mail,
          children: [
            CustomTextfield(
              hintText: "Contact Email",
              controller: controller.contactEmailController,
              prefixIcon: Icons.email,
              readOnly: true,
            ),
            const SizedBox(height: 15),
            CustomTextfield(
              hintText: "Phone",
              controller: controller.contactPhoneController,
              prefixIcon: Icons.phone,
            ),
          ],
        ),
        const SizedBox(height: 15),
        CustomCard(
          title: "Location Details",
          icon: Icons.location_on,
          children: [
            Obx(
              () => CustomDropdownTextfield(
                hint: "Select Province",
                icon: Icons.map,
                value: controller.selectedProvinceId.value.isNotEmpty
                    ? controller.selectedProvinceId.value
                    : null,
                items: controller.provincesList
                    .map(
                      (p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.nameEn)),
                    )
                    .toList(),
                onChanged: (v) => controller.onProvinceChanged(v),
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => CustomDropdownTextfield(
                hint: controller.selectedProvinceId.value.isEmpty
                    ? "Select Province first"
                    : "Select District",
                icon: Icons.location_city,
                value: controller.selectedDistrictId.value.isNotEmpty
                    ? controller.selectedDistrictId.value
                    : null,
                items: controller.districtsList
                    .map(
                      (d) =>
                          DropdownMenuItem(value: d.id, child: Text(d.nameEn)),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedDistrictId.value = v!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Center _buildImageLogo() {
    return Center(
      child: Column(
        children: [
          Obx(
            () => Container(
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
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: controller.pickCompanyLogo,
            icon: const Icon(Icons.upload_rounded),
            label: const Text("Upload Company Logo"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
