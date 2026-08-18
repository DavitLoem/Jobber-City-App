import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/screens/role/seeker/profile/widget/profile_text_field.dart';

import 'section_field_label.dart';

class PersonalInfoSection extends StatelessWidget {
  final EditProfileScreenViewController controller;

  const PersonalInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionFieldLabel(title: 'First Name'.tr), // 🟢 Added .tr
                  const SizedBox(height: 6),
                  ProfileTextField(
                    hintText: 'First Name'.tr, // 🟢 Added .tr
                    prefixIcon: Icons.person_outline,
                    controller: controller.firstNameCtrl,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionFieldLabel(title: 'Last Name'.tr), // 🟢 Added .tr
                  const SizedBox(height: 6),
                  ProfileTextField(
                    hintText: 'Last Name'.tr, // 🟢 Added .tr
                    prefixIcon: Icons.person_outline,
                    controller: controller.lastNameCtrl,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(title: 'Date of Birth'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        ProfileTextField(
          hintText: 'YYYY-MM-DD'.tr, // 🟢 Added .tr
          prefixIcon: Icons.date_range_outlined,
          readOnly: true,
          controller: controller.dateOfBirthCtrl,
          onTap: controller.selectDate,
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(title: 'Gender'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        Row(
          children: [
            _buildGenderChip(
              'Male'.tr,
              Icons.male_rounded,
              isDark,
            ), // 🟢 Added .tr
            const SizedBox(width: 10),
            _buildGenderChip(
              'Female'.tr,
              Icons.female_rounded,
              isDark,
            ), // 🟢 Added .tr
            const SizedBox(width: 10),
            _buildGenderChip(
              'Other'.tr,
              Icons.person_outline_rounded,
              isDark,
            ), // 🟢 Added .tr
          ],
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(title: 'Marital Status'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildMaritalChip('Single'.tr, isDark), // 🟢 Added .tr
            _buildMaritalChip('Married'.tr, isDark), // 🟢 Added .tr
            _buildMaritalChip('Divorced'.tr, isDark), // 🟢 Added .tr
            _buildMaritalChip('Widowed'.tr, isDark), // 🟢 Added .tr
          ],
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(title: 'Nationality'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        CitySelectField<String>(
          controller: controller.nationalityCtrl,
          fetchOptions: () async => controller.nationalities,
          labelOf: (n) => n.tr, // 🟢 Added .tr for dropdown items
          hintText: 'Select Nationality'.tr, // 🟢 Added .tr
          sheetTitle: 'Select Nationality'.tr, // 🟢 Added .tr
          prefixIcon: Icons.flag_outlined,
          onSelected: (n) {
            controller.nationalityCtrl.text = n.tr; // 🟢 Added .tr
          },
        ),
      ],
    );
  }

  Widget _buildGenderChip(String name, IconData icon, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Store actual English value internally for API if needed,
          // but if your backend accepts translated strings, we save 'name'.
          controller.selectedGender.value = name;
        },
        child: Obx(() {
          final isSelected =
              controller.selectedGender.value.toLowerCase() ==
              name.toLowerCase();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                        ? AppColors.darkInputBackground
                        : AppColors.inputBackground),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                            ? AppColors.darkInputText
                            : AppColors.inputIconText),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkInputText
                              : AppColors.inputIconText),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMaritalChip(String name, bool isDark) {
    final chipWidth = (Get.width - 40 - 32 - 30) / 4;

    return GestureDetector(
      onTap: () {
        controller.selectedMaritalStatus.value = name;
      },
      child: Obx(() {
        final isSelected =
            controller.selectedMaritalStatus.value.toLowerCase() ==
            name.toLowerCase();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: chipWidth,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkInputBackground
                      : AppColors.inputBackground),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? AppColors.darkInputText
                          : AppColors.inputIconText),
              ),
            ),
          ),
        );
      }),
    );
  }
}
