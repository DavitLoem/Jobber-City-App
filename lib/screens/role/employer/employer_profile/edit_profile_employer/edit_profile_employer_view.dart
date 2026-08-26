import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../controllers/location_controller.dart';
import '../../../../../controllers/master_data_controller.dart';
import '../../../../../core/api/services/role/employer/company_profile_services.dart';
import '../../../../../models/location_model.dart';
import '../../../../../models/role/employer/company_model.dart';
import '../employer_profile_view.dart';

part 'edit_profile_employer_binding.dart';
part 'edit_profile_employer_controller.dart';

class EditProfileEmployerView
    extends GetView<EditProfileEmployerViewController> {
  const EditProfileEmployerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ), // 🟢 Dynamic Sub-icon
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.updateProfile,
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    )
                  : Text(
                      "Save".tr, // 🟢 Added .tr
                      style: TextStyle(
                        color: isDark
                            ? Colors.blueAccent
                            : AppColors.primary, // 🟢 Dynamic Action Text
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ១. ផ្នែកប្តូររូបភាព Cover និង Logo ──
            _buildImageEditor(isDark), // 🟢 Passed Theme State

            const SizedBox(height: 30),

            // ── ២. ផ្នែកទម្រង់បញ្ចូលព័ត៌មាន (Form Fields) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    "Basic Information".tr,
                    isDark,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Company Name".tr, // 🟢 Added .tr
                    hint: "e.g. Tech Job Co., Ltd".tr, // 🟢 Added .tr
                    icon: LucideIcons.building,
                    textController: controller.companyNameCtrl,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: "Industry".tr, // 🟢 Added .tr
                    hint: "Select Industry".tr, // 🟢 Added .tr
                    icon: LucideIcons.briefcase,
                    value: controller.selectedIndustryId,
                    isDark: isDark,
                    itemsBuilder: () {
                      final list =
                          controller.masterCtrl.masterDataCache['industries'] ??
                          [];
                      return list
                          .map(
                            (ind) => DropdownMenuItem<String>(
                              value: ind.id,
                              child: Text(
                                ind.name,
                              ), // Assume Translated by MasterData
                            ),
                          )
                          .toList();
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: "Company Size".tr, // 🟢 Added .tr
                    hint: "Select Size".tr, // 🟢 Added .tr
                    icon: LucideIcons.users,
                    value: controller.selectedCompanySize,
                    isDark: isDark,
                    itemsBuilder: () => controller.companySizeList
                        .map(
                          (size) => DropdownMenuItem(
                            value: size,
                            child: Text(
                              "@size Employees".trParams({'size': size}),
                            ), // 🟢 Added .trParams
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    "Contact Information".tr,
                    isDark,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Email Address".tr, // 🟢 Added .tr
                    hint: "e.g. contact@company.com",
                    icon: LucideIcons.mail,
                    textController: controller.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Phone Number".tr, // 🟢 Added .tr
                    hint: "e.g. 012 345 678",
                    icon: LucideIcons.phone,
                    textController: controller.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Website (Optional)".tr, // 🟢 Added .tr
                    hint: "e.g. www.techjob.com",
                    icon: LucideIcons.globe,
                    textController: controller.websiteCtrl,
                    keyboardType: TextInputType.url,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    "Location Details".tr,
                    isDark,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Province".tr, // 🟢 Added .tr
                          hint: "Select Province".tr, // 🟢 Added .tr
                          value: controller.selectedProvinceId,
                          isDark: isDark,
                          itemsBuilder: () => controller.locationCtrl.provinces
                              .map(
                                (prov) => DropdownMenuItem<String>(
                                  value: prov.id,
                                  child: Text(
                                    prov.nameEn,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          label: "District".tr, // 🟢 Added .tr
                          hint: "Select District".tr, // 🟢 Added .tr
                          value: controller.selectedDistrictId,
                          isDark: isDark,
                          itemsBuilder: () => controller.districtsList
                              .map(
                                (dist) => DropdownMenuItem<String>(
                                  value: dist.id,
                                  child: Text(
                                    dist.nameEn,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Address Detail".tr, // 🟢 Added .tr
                    hint: "House number, Street, etc.".tr, // 🟢 Added .tr
                    icon: LucideIcons.mapPin,
                    textController: controller.addressCtrl,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    "About Company".tr,
                    isDark,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Company Description".tr, // 🟢 Added .tr
                    hint:
                        "Tell candidates about your company's mission, vision, and culture..."
                            .tr, // 🟢 Added .tr
                    maxLines: 5,
                    textController: controller.descCtrl,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ── មុខងារជំនួយ (Helper Widgets) ──
  // ==========================================

  Widget _buildImageEditor(bool isDark) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ── ផ្ទាំង Cover ──
          GestureDetector(
            onTap: () {
              // មុខងារប្តូរ Cover
            },
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4f7df7), Color(0xFF8faaf9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.camera,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // ── 🎯 ផ្ទាំង Logo ──
          Positioned(
            bottom: -5,
            child: GestureDetector(
              onTap: controller.pickAndUploadLogo,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : Colors.white, // 🟢 Dynamic Wrapping Circle
                      shape: BoxShape.circle,
                    ),
                    child: Obx(
                      () => CircleAvatar(
                        radius: 45,
                        backgroundColor: isDark
                            ? AppColors.darkInputBackground
                            : const Color(0xFFF0F4FF), // 🟢 Dynamic Avatar BG

                        backgroundImage: controller.logoImage.value != null
                            ? FileImage(controller.logoImage.value!)
                                  as ImageProvider
                            : (controller.existingLogoUrl.value.isNotEmpty
                                  ? NetworkImage(
                                          controller.existingLogoUrl.value,
                                        )
                                        as ImageProvider
                                  : null),

                        child: controller.isUploadingLogo.value
                            ? CircularProgressIndicator(
                                color: isDark
                                    ? Colors.blueAccent
                                    : AppColors.primary, // 🟢 Dynamic Spinner
                              )
                            : (controller.logoImage.value == null &&
                                      controller.existingLogoUrl.value.isEmpty
                                  ? Icon(
                                      LucideIcons.building,
                                      size: 40,
                                      color: isDark
                                          ? Colors.blueAccent
                                          : AppColors
                                                .primary, // 🟢 Dynamic Icon Placeholder
                                    )
                                  : null),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 4, right: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.blueAccent
                          : AppColors.primary, // 🟢 Dynamic Button
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ), // Clean outline
                    ),
                    child: const Icon(
                      LucideIcons.pencil,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark
            ? Colors.white
            : Colors.black87, // 🟢 Dynamic Section Title
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController textController,
    required bool isDark,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextSecondary
                : Colors.grey.shade700, // 🟢 Dynamic Label
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ), // 🟢 Dynamic Input Text
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
              fontSize: 15,
            ), // 🟢 Dynamic Hint Text
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: isDark
                        ? AppColors.darkIconSecondary
                        : Colors.grey.shade400,
                    size: 20,
                  )
                : null,
            filled: true,
            fillColor: isDark
                ? AppColors.darkInputBackground
                : Colors.grey.shade50, // 🟢 Dynamic Form Field BG
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ), // 🟢 Dynamic Outline
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ), // 🟢 Dynamic Outline
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.blueAccent
                    : AppColors.primary, // 🟢 Dynamic Highlight
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    IconData? icon,
    required RxString value,
    required List<DropdownMenuItem<String>> Function() itemsBuilder,
    required bool isDark,
    void Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextSecondary
                : Colors.grey.shade700, // 🟢 Dynamic Label
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final items = itemsBuilder();

          String? currentValue = value.value.isEmpty ? null : value.value;
          bool valueExists = items.any((item) => item.value == currentValue);
          if (!valueExists) currentValue = null;

          return DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: currentValue,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item.value,
                // Re-wrap the text to ensure it listens to the theme colors
                child: Text(
                  (item.child as Text).data ?? '',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) value.value = newValue;
              if (onChanged != null) {
                onChanged(newValue);
              }
            },
            dropdownColor: isDark
                ? AppColors.darkSurfaceElevated
                : Colors.white, // 🟢 Dynamic Dropdown Overlay
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
                fontSize: 15,
              ), // 🟢 Dynamic Hint Text
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : Colors.grey.shade400,
                      size: 20,
                    )
                  : null,
              filled: true,
              fillColor: isDark
                  ? AppColors.darkInputBackground
                  : Colors.grey.shade50, // 🟢 Dynamic Dropdown Default View BG
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200,
                ), // 🟢 Dynamic Border
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200,
                ), // 🟢 Dynamic Border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.blueAccent
                      : AppColors.primary, // 🟢 Dynamic Action Color
                  width: 1.5,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
