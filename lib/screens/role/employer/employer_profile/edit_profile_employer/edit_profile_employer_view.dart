import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          // 🎯 រុំ Obx ដើម្បីបង្ហាញ Loading ពេលចុច Save
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
                        color: Color(0xFF4f7df7),
                      ),
                    )
                  : const Text(
                      "Save",
                      style: TextStyle(
                        color: Color(0xFF4f7df7),
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
            _buildImageEditor(),

            const SizedBox(height: 30),

            // ── ២. ផ្នែកទម្រង់បញ្ចូលព័ត៌មាន (Form Fields) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Basic Information"),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Company Name",
                    hint: "e.g. Tech Job Co., Ltd",
                    icon: LucideIcons.building,
                    textController:
                        controller.companyNameCtrl, // 🎯 ភ្ជាប់ Controller
                  ),
                  const SizedBox(height: 16),

                  // 🎯 ប្រើប្រាស់ Dropdown សម្រាប់វាលដែលត្រូវការ ID
                  _buildDropdownField(
                    label: "Industry",
                    hint: "Select Industry",
                    icon: LucideIcons.briefcase,
                    value: controller.selectedIndustryId,
                    itemsBuilder: () {
                      final list =
                          controller.masterCtrl.masterDataCache['industries'] ??
                          [];
                      return list
                          .map(
                            (ind) => DropdownMenuItem<String>(
                              value: ind.id,
                              child: Text(ind.name),
                            ),
                          )
                          .toList();
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: "Company Size",
                    hint: "Select Size",
                    icon: LucideIcons.users,
                    value: controller.selectedCompanySize,
                    itemsBuilder: () => controller.companySizeList
                        .map(
                          (size) => DropdownMenuItem(
                            value: size,
                            child: Text("$size Employees"),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Contact Information"),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Email Address",
                    hint: "e.g. contact@company.com",
                    icon: LucideIcons.mail,
                    textController: controller.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Phone Number",
                    hint: "e.g. 012 345 678",
                    icon: LucideIcons.phone,
                    textController: controller.phoneCtrl,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Website (Optional)",
                    hint: "e.g. www.techjob.com",
                    icon: LucideIcons.globe,
                    textController: controller.websiteCtrl,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Location Details"),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Province",
                          hint: "Select Province",
                          value: controller.selectedProvinceId,
                          itemsBuilder: () => controller.locationCtrl.provinces
                              .map(
                                (prov) => DropdownMenuItem<String>(
                                  value: prov.id,
                                  child: Text(
                                    prov.nameEn,
                                    overflow: TextOverflow.ellipsis, // 👈 Added
                                    maxLines: 1, // 👈 Added
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          label: "District",
                          hint: "Select District",
                          value: controller.selectedDistrictId,
                          itemsBuilder: () => controller.districtsList
                              .map(
                                (dist) => DropdownMenuItem<String>(
                                  value: dist.id,
                                  child: Text(
                                    dist.nameEn,
                                    overflow: TextOverflow.ellipsis, // 👈 Added
                                    maxLines: 1, // 👈 Added
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
                    label: "Address Detail",
                    hint: "House number, Street, etc.",
                    icon: LucideIcons.mapPin,
                    textController: controller.addressCtrl,
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("About Company"),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: "Company Description",
                    hint:
                        "Tell candidates about your company's mission, vision, and culture...",
                    maxLines: 5,
                    textController: controller.descCtrl,
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

  Widget _buildImageEditor() {
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
              onTap: controller.pickAndUploadLogo, // ឥឡូវនេះអាចចុចបាន 100%
              behavior: HitTestBehavior.opaque, // ធានាថាចាប់ការចុចបានល្អ
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Obx(
                      () => CircleAvatar(
                        radius: 45,
                        backgroundColor: const Color(0xFFF0F4FF),

                        // 🎯 ឆែករូបថ្មីសិន បើគ្មានចាំឆែករូបចាស់ (URL)
                        backgroundImage: controller.logoImage.value != null
                            ? FileImage(controller.logoImage.value!)
                                  as ImageProvider
                            : (controller.existingLogoUrl.value.isNotEmpty
                                  ? NetworkImage(
                                          controller.existingLogoUrl.value,
                                        )
                                        as ImageProvider
                                  : null),

                        // 🎯 ឆែក Loading និង Icon
                        child: controller.isUploadingLogo.value
                            ? const CircularProgressIndicator(
                                color: Color(0xFF4f7df7),
                              )
                            : (controller.logoImage.value == null &&
                                      controller.existingLogoUrl.value.isEmpty
                                  ? const Icon(
                                      LucideIcons.building,
                                      size: 40,
                                      color: Color(0xFF4f7df7),
                                    )
                                  : null),
                      ),
                    ),
                  ),
                  // Icon កាមេរ៉ាតូចលើ Logo
                  Container(
                    margin: const EdgeInsets.only(bottom: 4, right: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4f7df7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // 🎯 Update ទទួលយក TextEditingController
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController textController,
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
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey.shade400, size: 20)
                : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4f7df7),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🎯 ១. អាប់ដេត Widget Dropdown
  Widget _buildDropdownField({
    required String label,
    required String hint,
    IconData? icon,
    required RxString value,
    required List<DropdownMenuItem<String>> Function() itemsBuilder,
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
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final items = itemsBuilder();

          String? currentValue = value.value.isEmpty ? null : value.value;
          bool valueExists = items.any((item) => item.value == currentValue);
          if (!valueExists) currentValue = null;

          return DropdownButtonFormField<String>(
            isExpanded:
                true, // 👈 បន្ថែមបន្ទាត់នេះជាដាច់ខាត ដើម្បីដោះស្រាយការ Overflow
            initialValue: currentValue,
            items: items,
            onChanged: (newValue) {
              if (newValue != null) value.value = newValue;
              if (onChanged != null) {
                onChanged(newValue);
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.grey.shade400, size: 20)
                  : null,
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4f7df7),
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
