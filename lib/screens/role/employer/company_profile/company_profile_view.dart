import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/role/employer/company_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';
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

  bool get _isDark {
    final mode = controller.themeController.themeMode.value;
    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  void _showPicker<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) getName,
    required void Function(T) onSelected,
  }) {
    TextEditingController searchCtrl = TextEditingController();
    RxList<T> filteredItems = items.toList().obs;
    final isDark = _isDark; // 🟢 Theme Check

    Get.bottomSheet(
      Container(
        height: Get.height * 0.65,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackground
              : Colors.white, // 🟢 Dynamic BG
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              title.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: searchCtrl,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: "Search...".tr, // 🟢 Added .tr
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : Colors.grey.shade100, // 🟢 Dynamic Search Box BG
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
                      title: Text(
                        getName(
                          item,
                        ).tr, // Optional tr depending on the item data
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
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
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic Scaffold BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Company Profile".tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
            height: 1,
          ), // 🟢 Dynamic Divider
        ),
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(isDark), // 🟢 Passed Theme State
              const SizedBox(height: 30),

              // ── ផ្នែកទី១: Basic Information ──
              ProfileSectionCard(
                title: "Company Identity".tr, // 🟢 Added .tr
                subtitle: "Tell us about your business".tr, // 🟢 Added .tr
                children: [
                  CustomFormTextField(
                    label: "Company Name *".tr, // 🟢 Added .tr
                    hint: "e.g. Jobber City Co., Ltd.".tr, // 🟢 Added .tr
                    controller: controller.companyNameController,
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Industry *".tr, // 🟢 Added .tr
                    hint: "Select your industry".tr, // 🟢 Added .tr
                    isDropdown: true,
                    controller: controller.industryCtrl,
                    onTap: () {
                      if (controller.industriesList.isEmpty) {
                        Get.snackbar("Notice".tr, "Industries are loading.".tr);
                        return;
                      }
                      _showPicker<MasterDataModel>(
                        context: context,
                        title: "Select Industry".tr, // 🟢 Added .tr
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
                    label: "Company Size *".tr, // 🟢 Added .tr
                    hint: "Select company size".tr, // 🟢 Added .tr
                    isDropdown: true,
                    controller: controller.companySizeCtrl,
                    onTap: () => _showPicker<String>(
                      context: context,
                      title: "Select Company Size".tr, // 🟢 Added .tr
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
                    label: "Description *".tr, // 🟢 Added .tr
                    hint: "Briefly describe your company (min 10 chars)..."
                        .tr, // 🟢 Added .tr
                    maxLines: 4,
                    controller: controller.descriptionCtrl,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── ផ្នែកទី២: Contact & Location ──
              ProfileSectionCard(
                title: "Contact & Location".tr, // 🟢 Added .tr
                subtitle: "Where can candidates find you?".tr, // 🟢 Added .tr
                children: [
                  CustomFormTextField(
                    label: "Contact Email *".tr, // 🟢 Added .tr
                    hint: "hr@company.com",
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.contactEmailController,
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Phone Number *".tr, // 🟢 Added .tr
                    hint: "+855 12 345 678",
                    keyboardType: TextInputType.phone,
                    controller: controller.contactPhoneController,
                  ),
                  const SizedBox(height: 16),
                  CustomFormTextField(
                    label: "Website (Optional)".tr, // 🟢 Added .tr
                    hint: "https://www.company.com",
                    controller: controller.websiteUrlController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormTextField(
                          label: "Province *".tr, // 🟢 Added .tr
                          hint: "Select Province".tr, // 🟢 Added .tr
                          isDropdown: true,
                          controller: controller.provinceCtrl,
                          onTap: () => _showPicker<LocationModel>(
                            context: context,
                            title: "Select Province".tr, // 🟢 Added .tr
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
                          label: "District *".tr, // 🟢 Added .tr
                          hint: "Select District".tr, // 🟢 Added .tr
                          isDropdown: true,
                          controller: controller.districtCtrl,
                          onTap: () {
                            if (controller.selectedProvinceId.value.isEmpty) {
                              Get.snackbar(
                                "Notice".tr, // 🟢 Added .tr
                                "Please select a Province first"
                                    .tr, // 🟢 Added .tr
                              );
                              return;
                            }
                            _showPicker<LocationModel>(
                              context: context,
                              title: "Select District".tr, // 🟢 Added .tr
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
                    label: "Address Detail *".tr, // 🟢 Added .tr
                    hint: "Street 123, Sangkat...".tr, // 🟢 Added .tr
                    maxLines: 2,
                    controller: controller.addressDetailController,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── ផ្នែកទី៣: Settings ──
              ProfileSectionCard(
                title: "Settings".tr, // 🟢 Added .tr
                subtitle: "Customize your experience".tr, // 🟢 Added .tr
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      "Appearance".tr,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onTap: () => _showAppearanceBottomSheet(),
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? AppColors.darkDivider
                        : Colors.grey.shade200,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.g_translate_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      "Language".tr,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onTap: () => _showLanguageBottomSheet(),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
      // ── ប៊ូតុង Save ស្អិតជាប់ខាងក្រោម ──
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackground
              : Colors.white, // 🟢 Dynamic Bottom Sheet BG
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: isDark
                      ? AppColors.darkSurfaceElevated
                      : Colors.grey.shade300,
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
                    : Text(
                        "Save Profile".tr, // 🟢 Added .tr
                        style: const TextStyle(
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
  Widget _buildHeaderSection(bool isDark) {
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
                    color: isDark
                        ? AppColors.darkInputBackground
                        : Colors.white, // 🟢 Dynamic BG
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? 0.4 : 0.2,
                      ),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: isDark ? 0.2 : 0.08,
                        ),
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
                    border: Border.all(
                      color: isDark ? AppColors.darkBackground : Colors.white,
                      width: 2,
                    ), // 🟢 Dynamic Icon Border
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
          Text(
            "Upload Company Logo".tr, // 🟢 Added .tr
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Recommended size: 500x500px".tr, // 🟢 Added .tr
            style: TextStyle(
              color: isDark ? AppColors.darkTextTertiary : Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showAppearanceBottomSheet() {
    Get.bottomSheet(
      Obx(() {
        final isDark = _isDark;
        final bgColor = isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark
            ? AppColors.darkTextHint
            : AppColors.textHint;
        final dividerColor = isDark
            ? AppColors.darkDivider
            : Colors.grey.withValues(alpha: 0.3);

        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Appearance'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your preferred color scheme'.tr,
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThemeOption(
                    title: 'Light'.tr,
                    mode: ThemeMode.light,
                    mockup: const _PhoneMockup(style: _MockupStyle.light),
                    isDark: isDark,
                  ),
                  _buildThemeOption(
                    title: 'Dark'.tr,
                    mode: ThemeMode.dark,
                    mockup: const _PhoneMockup(style: _MockupStyle.dark),
                    isDark: isDark,
                  ),
                  _buildThemeOption(
                    title: 'System'.tr,
                    mode: ThemeMode.system,
                    mockup: const _PhoneMockup(style: _MockupStyle.system),
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _buildThemeOption({
    required String title,
    required ThemeMode mode,
    required Widget mockup,
    required bool isDark,
  }) {
    final isSelected = controller.themeController.themeMode.value == mode;

    final textActiveColor = isDark ? Colors.white : Colors.black87;
    final textInactiveColor = isDark
        ? AppColors.darkTextHint
        : AppColors.textHint;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTheme(mode),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              mockup,
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? textActiveColor : textInactiveColor,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    Get.bottomSheet(
      Obx(() {
        final isDark = _isDark;
        final bgColor = isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark
            ? AppColors.darkTextHint
            : AppColors.textHint;
        final dividerColor = isDark
            ? AppColors.darkDivider
            : Colors.grey.withValues(alpha: 0.3);

        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Language'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your preferred language'.tr,
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLanguageOption(
                    title: 'English',
                    flagEmoji: '🇺🇸',
                    accentColor: const Color(0xFF2F80ED),
                    locale: const Locale('en', 'US'),
                    isDark: isDark,
                  ),
                  _buildLanguageOption(
                    title: 'ភាសាខ្មែរ',
                    flagEmoji: '🇰🇭', // Fixed flag emoji
                    accentColor: const Color(0xFFEB5757),
                    locale: const Locale('km', 'KH'),
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String flagEmoji,
    required Color accentColor,
    required Locale locale,
    required bool isDark,
  }) {
    final isSelected = Get.locale?.languageCode == locale.languageCode;

    final textActiveColor = isDark ? Colors.white : Colors.black87;
    final textInactiveColor = isDark
        ? AppColors.darkTextHint
        : AppColors.textHint;

    return Expanded(
      child: InkWell(
        onTap: () {
          controller.changeLanguage(
            locale.languageCode,
            locale.countryCode ?? '',
          );
          Get.back();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Text(flagEmoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? textActiveColor : textInactiveColor,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MockupStyle { light, dark, system }

class _PhoneMockup extends StatelessWidget {
  final _MockupStyle style;
  const _PhoneMockup({required this.style});

  @override
  Widget build(BuildContext context) {
    const double width = 96;
    const double height = 170;
    const radius = 18.0;

    if (style != _MockupStyle.system) {
      final isDark = style == _MockupStyle.dark;
      return _phoneShell(
        width: width,
        height: height,
        radius: radius,
        child: _mockupContent(isDark: isDark),
      );
    }

    return _phoneShell(
      width: width,
      height: height,
      radius: radius,
      child: Stack(
        children: [
          ClipRect(
            clipper: _HalfClipper(right: false),
            child: _mockupContent(isDark: false),
          ),
          ClipRect(
            clipper: _HalfClipper(right: true),
            child: _mockupContent(isDark: true),
          ),
        ],
      ),
    );
  }

  Widget _phoneShell({
    required double width,
    required double height,
    required double radius,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 3),
        child: child,
      ),
    );
  }

  Widget _mockupContent({required bool isDark}) {
    final bg = isDark ? const Color(0xFF141414) : const Color(0xFFF2F2F5);
    final barColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.08);
    final dotColor = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.black.withValues(alpha: 0.15);

    Widget bar({required double width, Color? color}) => Container(
      height: 8,
      width: width,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: color ?? barColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );

    Widget dotRow() => Row(
      children: [
        _dot(dotColor: const Color(0xFF4CD97B)),
        const SizedBox(width: 4),
        _dot(dotColor: const Color(0xFFF2C94C)),
        const SizedBox(width: 4),
        _dot(dotColor: const Color(0xFFEB5757)),
      ],
    );

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(dotColor: dotColor, size: 5),
                const SizedBox(width: 3),
                _dot(dotColor: dotColor, size: 5),
              ],
            ),
          ),
          const SizedBox(height: 8),
          bar(width: 40, color: const Color(0xFFE0397C)),
          const SizedBox(height: 2),
          bar(width: 60, color: const Color(0xFFF2545B)),
          const SizedBox(height: 6),
          dotRow(),
          const SizedBox(height: 8),
          bar(width: 70),
          bar(width: 50),
          const SizedBox(height: 6),
          bar(width: 34, color: const Color(0xFF2F80ED)),
          const SizedBox(height: 2),
          bar(width: 48, color: const Color(0xFF2FC5D2)),
        ],
      ),
    );
  }

  Widget _dot({required Color dotColor, double size = 7}) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
  );
}

class _HalfClipper extends CustomClipper<Rect> {
  final bool right;
  _HalfClipper({required this.right});

  @override
  Rect getClip(Size size) {
    return right
        ? Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height)
        : Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
