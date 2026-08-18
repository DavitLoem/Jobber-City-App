import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';
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

  bool get _isDark {
    final mode = controller.themeController.themeMode.value;
    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
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
                      style: const TextStyle(
                        color: AppColors.primary,
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
            _buildImageEditor(isDark),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    "Basic Information".tr,
                    theme,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Company Name".tr, // 🟢 Added .tr
                    hint: "e.g. Tech Job Co., Ltd".tr, // 🟢 Added .tr
                    icon: LucideIcons.building,
                    textController: controller.companyNameCtrl,
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: "Industry".tr, // 🟢 Added .tr
                    hint: "Select Industry".tr, // 🟢 Added .tr
                    icon: LucideIcons.briefcase,
                    value: controller.selectedIndustryId,
                    theme: theme,
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
                              ), // 🟢 Typically dynamic data
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
                    theme: theme,
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
                    theme,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Email Address".tr, // 🟢 Added .tr
                    hint:
                        "e.g. contact@company.com", // Usually emails don't need translation
                    icon: LucideIcons.mail,
                    textController: controller.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Phone Number".tr, // 🟢 Added .tr
                    hint: "e.g. 012 345 678",
                    icon: LucideIcons.phone,
                    textController: controller.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Website (Optional)".tr, // 🟢 Added .tr
                    hint: "e.g. www.techjob.com",
                    icon: LucideIcons.globe,
                    textController: controller.websiteCtrl,
                    keyboardType: TextInputType.url,
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    "Location Details".tr,
                    theme,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Province".tr, // 🟢 Added .tr
                          hint: "Select Province".tr, // 🟢 Added .tr
                          value: controller.selectedProvinceId,
                          theme: theme,
                          isDark: isDark,
                          onChanged: controller.onProvinceChanged,
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
                          theme: theme,
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
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("About Company".tr, theme), // 🟢 Added .tr
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Company Description".tr, // 🟢 Added .tr
                    hint:
                        "Tell candidates about your company's mission, vision, and culture..."
                            .tr, // 🟢 Added .tr
                    maxLines: 5,
                    textController: controller.descCtrl,
                    theme: theme,
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

  Widget _buildImageEditor(bool isDark) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColors.primary.withValues(
                            alpha: 0.8,
                          ), // 🟢 Updated opacity
                          AppColors.primary.withValues(
                            alpha: 0.4,
                          ), // 🟢 Updated opacity
                        ]
                      : [const Color(0xFF4f7df7), const Color(0xFF8faaf9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.3,
                    ), // 🟢 Updated opacity
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
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Obx(
                      () => CircleAvatar(
                        radius: 45,
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceElevated
                            : const Color(0xFFF0F4FF),
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
                            ? const CircularProgressIndicator(
                                color: AppColors.primary,
                              )
                            : (controller.logoImage.value == null &&
                                      controller.existingLogoUrl.value.isEmpty
                                  ? const Icon(
                                      LucideIcons.building,
                                      size: 40,
                                      color: AppColors.primary,
                                    )
                                  : null),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 4, right: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 2,
                      ),
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

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController textController,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? AppColors.darkInputText : AppColors.inputText,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
              fontSize: 15,
            ),
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
                : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
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
    void Function(String?)? onChanged,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
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
            value: currentValue,
            items: items,
            onChanged: (newValue) {
              if (newValue != null) value.value = newValue;
              if (onChanged != null) {
                onChanged(newValue);
              }
            },
            dropdownColor: theme.cardColor,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
                fontSize: 15,
              ),
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
                  : Colors.grey.shade50,
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
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
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
