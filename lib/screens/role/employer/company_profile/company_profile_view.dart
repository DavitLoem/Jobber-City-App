import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/role/employer/company_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/models/master_data_model.dart';
import 'package:jobber_city/models/role/employer/company_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';
import 'package:dio/dio.dart';
import 'package:jobber_city/screens/role/employer/company_profile/widgets/profile_section_card.dart.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../core/utils/token_storage.dart';
import '../../../../widgets/custom_textfield.dart';

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

    Get.bottomSheet(
      Obx(() {
        final isDark = _isDark;
        final bgColor = isDark ? AppColors.darkBackground : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;
        final inputBgColor = isDark
            ? AppColors.darkInputBackground
            : Colors.grey.shade100;
        final hintColor = isDark ? AppColors.darkTextHint : Colors.grey;
        final iconColor = isDark ? AppColors.darkIconSecondary : Colors.grey;

        return Container(
          height: Get.height * 0.65,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(
                title.tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: searchCtrl,
                style: TextStyle(
                  color: isDark ? AppColors.darkInputText : AppColors.inputText,
                ),
                decoration: InputDecoration(
                  hintText: "Search...".tr, // 🟢 Added .tr
                  hintStyle: TextStyle(color: hintColor),
                  prefixIcon: Icon(Icons.search, color: iconColor),
                  filled: true,
                  fillColor: inputBgColor,
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
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(
                        getName(item).tr, // Translated list item strings
                        style: TextStyle(color: textColor),
                      ),
                      onTap: () {
                        onSelected(item);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Company Profile".tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
            height: 1,
          ),
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
              _buildHeaderSection(isDark),
              const SizedBox(height: 30),

              // 1. Basic Info
              ProfileSectionCard(
                title: "Company Identity".tr,
                subtitle: "Tell us about your business".tr,
                children: [
                  CustomTextfield(
                    controller: controller.companyNameController,
                    hintText: 'Company Name *'.tr,
                    prefixIcon: Icons.apartment_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    hint: 'Select Industry *'.tr,
                    icon: Icons.work_outline_rounded,
                    value: controller.selectedIndustryId,
                    itemsBuilder: () => controller.industriesList
                        .map(
                          (ind) => DropdownMenuItem(
                            value: ind.id.toString(),
                            child: Text(ind.name),
                          ),
                        )
                        .toList(),
                    theme: theme,
                    isDark: isDark,
                  ),
                  if (controller.industriesError.value != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        controller.industriesError.value!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    hint: 'Company Size'.tr,
                    icon: Icons.people_alt_outlined,
                    value: controller.selectedCompanySize,
                    itemsBuilder: () => controller.companySizes
                        .map(
                          (size) => DropdownMenuItem(
                            value: size,
                            child: Text('$size ' + 'Employees'.tr),
                          ),
                        )
                        .toList(),
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: controller.descriptionCtrl,
                    hintText: 'Describe your company mission, vision...'.tr,
                    prefixIcon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Contact & Location
              ProfileSectionCard(
                title: "Contact & Location".tr,
                subtitle: "Where can candidates find you?".tr,
                children: [
                  CustomTextfield(
                    controller: controller.contactEmailController,
                    hintText: 'Contact Email *'.tr,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: controller.contactPhoneController,
                    hintText: 'Phone Number *'.tr,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: controller.websiteUrlController,
                    hintText: 'Website (Optional)'.tr,
                    prefixIcon: Icons.language_rounded,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          hint: 'Select Province'.tr,
                          icon: Icons.map_outlined,
                          value: controller.selectedProvinceId,
                          itemsBuilder: () => controller.locationCtrl.provinces
                              .map(
                                (prov) => DropdownMenuItem(
                                  value: prov.id.toString(),
                                  child: Text(prov.nameEn),
                                ),
                              )
                              .toList(),
                          onChanged: controller.onProvinceChanged,
                          theme: theme,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          hint: 'Select District'.tr,
                          icon: Icons.location_city_rounded,
                          value: controller.selectedDistrictId,
                          itemsBuilder: () => controller.districtsList
                              .map(
                                (dist) => DropdownMenuItem(
                                  value: dist.id.toString(),
                                  child: Text(dist.nameEn),
                                ),
                              )
                              .toList(),
                          theme: theme,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  if (controller.locationsError.value != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        controller.locationsError.value!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: controller.addressDetailController,
                    hintText: 'Address Detail (House, St, etc.)'.tr,
                    prefixIcon: Icons.home_work_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        );
      }),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
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
                        "Save Profile".tr,
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
                        ? AppColors.darkSurfaceElevated
                        : Colors.white,
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
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : Colors.white,
                      width: 2,
                    ),
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
            "Upload Company Logo".tr,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Recommended size: 500x500px".tr,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 Restored Missing _buildDropdownField Method
  Widget _buildDropdownField({
    required String hint,
    required IconData icon,
    required RxString value,
    required List<DropdownMenuItem<String>> Function() itemsBuilder,
    void Function(String?)? onChanged,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Obx(() {
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
          if (onChanged != null) onChanged(newValue);
        },
        dropdownColor: theme.cardColor,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextHint : Colors.grey[400],
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: isDark ? AppColors.darkIconSecondary : Colors.grey[400],
            size: 22,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkInputBackground : Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      );
    });
  }

  // 🟢 Appearance Bottom Sheet
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
              const SizedBox(height: 32),
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
              const SizedBox(height: 16),

              _buildLanguageOption(
                title: 'English'.tr,
                langCode: 'en',
                countryCode: 'US',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                title: 'Khmer'.tr,
                langCode: 'km',
                countryCode: 'KH',
                isDark: isDark,
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

  Widget _buildLanguageOption({
    required String title,
    required String langCode,
    required String countryCode,
    required bool isDark,
  }) {
    final isSelected = Get.locale?.languageCode == langCode;

    final textActiveColor = isDark ? Colors.white : Colors.black87;
    final textInactiveColor = isDark
        ? AppColors.darkTextHint
        : AppColors.textHint;

    return InkWell(
      onTap: () {
        controller.changeLanguage(langCode, countryCode);
        Get.back();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.5)
                : (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? textActiveColor : textInactiveColor,
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
          ],
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
