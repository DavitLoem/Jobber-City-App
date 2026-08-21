import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 ត្រូវមាន Get សម្រាប់ Obx
import 'package:jobber_city/core/constants/app_colors.dart';
// 🟢 Import Controller ដែលយើងមាន
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/screens/role/seeker/profile/widget/profile_text_field.dart';

import 'section_field_label.dart';

class PersonalInfoSection extends StatelessWidget {
  // 🎯 បញ្ចូល Controller
  final EditProfileScreenViewController controller;

  const PersonalInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                  const SectionFieldLabel(title: 'First Name'),
                  const SizedBox(height: 6),
                  ProfileTextField(
                    hintText: 'First Name',
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
                  const SectionFieldLabel(title: 'Last Name'),
                  const SizedBox(height: 6),
                  ProfileTextField(
                    hintText: 'Last Name',
                    prefixIcon: Icons.person_outline,
                    controller: controller.lastNameCtrl, // 🎯
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'Date of Birth'),
        const SizedBox(height: 6),
        ProfileTextField(
          hintText: 'YYYY-MM-DD', // ដូរ Hint ឱ្យស្របតាមទម្រង់ API
          prefixIcon: Icons.date_range_outlined,
          readOnly: true,
          controller: controller.dateOfBirthCtrl, // 🎯
          onTap: controller.selectDate, // 🎯 ហៅមុខងាររើសកាលបរិច្ឆេទ
        ),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'Gender'),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildGenderChip('Male', Icons.male_rounded),
            const SizedBox(width: 10),
            _buildGenderChip('Female', Icons.female_rounded),
            const SizedBox(width: 10),
            _buildGenderChip('Other', Icons.person_outline_rounded),
          ],
        ),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'Marital Status'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildMaritalChip('Single'),
            _buildMaritalChip('Married'),
            _buildMaritalChip('Divorced'),
            _buildMaritalChip('Widowed'),
          ],
        ),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'Nationality'),
        const SizedBox(height: 6),
        CitySelectField<String>(
          controller: controller.nationalityCtrl, // 🎯
          fetchOptions: () async =>
              controller.nationalities, // 🎯 ទាញ List ពី Controller
          labelOf: (n) => n,
          hintText: 'Select Nationality',
          sheetTitle: 'Select Nationality',
          prefixIcon: Icons.flag_outlined,
          onSelected: (n) {
            controller.nationalityCtrl.text = n; // 🎯 អាប់ដេតតម្លៃពេលរើសរួច
          },
        ),
      ],
    );
  }

  // ── 🎯 កែប្រែ Chip ឲ្យដំណើរការបែប Dynamic (មានចុច និងលោតពណ៌) ──

  Widget _buildGenderChip(String name, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // ចាប់យកតម្លៃដាក់ចូលអថេរ .obs របស់ GetX
          controller.selectedGender.value = name;
        },
        child: Obx(() {
          // ឆែកមើលថាតើវាត្រូវបាន Select ដែរឬទេ
          final isSelected =
              controller.selectedGender.value.toLowerCase() ==
              name.toLowerCase();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? AppColors.primary : AppColors.inputBackground,
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
                  color: isSelected ? Colors.white : AppColors.inputIconText,
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.inputIconText,
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

  Widget _buildMaritalChip(String name) {
    // គណនាប្រវែង Chip ឱ្យស្មើគ្នា
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
            color: isSelected ? AppColors.primary : AppColors.inputBackground,
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
                color: isSelected ? Colors.white : AppColors.inputIconText,
              ),
            ),
          ),
        );
      }),
    );
  }
}
