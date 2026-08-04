import 'package:flutter/material.dart';
import 'package:get/get.dart';
// កុំភ្លេច Import Model និង Controller របស់អ្នក
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/screens/role/seeker/profile/widget/profile_text_field.dart';

import 'section_field_label.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({super.key, required this.controller});

  // 🎯 តម្រូវឱ្យបញ្ជូន Controller មកពីឯកសារមេ
  final EditProfileScreenViewController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionFieldLabel(title: 'Province'),
        const SizedBox(height: 6),
        CitySelectField<LocationModel>(
          controller: controller.provinceCtrl,
          fetchOptions: controller.fetchProvinceOptions,
          labelOf: (loc) => loc.nameEn,
          hintText: 'Select Province',
          sheetTitle: 'Select Province',
          onSelected: (loc) {
            // 🎯 កត់ត្រា ID ខេត្ត ហើយជម្រះស្រុកចោលពេលដូរខេត្ត
            controller.selectedProvinceId.value = loc.id.toString();
            controller.provinceCtrl.text = loc.nameEn;

            controller.districtCtrl.clear();
            controller.selectedDistrictId.value = '';
          },
        ),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'District / Khan'),
        const SizedBox(height: 6),
        Obx(() {
          final isEnabled = controller.selectedProvinceId.value.isNotEmpty;
          return IgnorePointer(
            ignoring: !isEnabled,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isEnabled ? 1.0 : 0.5,
              child: CitySelectField<LocationModel>(
                controller: controller.districtCtrl,
                fetchOptions: controller.fetchDistrictOptions,
                labelOf: (d) => d.nameEn,
                // 🎯 ឆែកមើលបើអត់ទាន់រើសខេត្តទេ ដាក់អក្សរព្រមាន
                hintText: controller.selectedProvinceId.value.isEmpty
                    ? 'Select province first'
                    : 'Select District',
                sheetTitle: 'Select District',
                // 🎯 បិទមិនឱ្យចុចរើសស្រុក បើមិនទាន់មានខេត្ត
                enabled: controller.selectedProvinceId.value.isNotEmpty,
                onSelected: (d) {
                  controller.selectedDistrictId.value = d.id.toString();
                  controller.districtCtrl.text = d.nameEn;
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'Commune / Sangkat'),
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.location_on_outlined,
          hintText: 'Enter commune',
          controller: controller.communeCtrl,
        ),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'Village', isOptional: true),
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.holiday_village_outlined,
          hintText: 'Enter village',
          controller: controller.villageCtrl, // 🎯 ភ្ជាប់ Controller
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionFieldLabel(title: 'Street', isOptional: true),
                  const SizedBox(height: 6),
                  ProfileTextField(
                    prefixIcon: Icons.signpost_outlined,
                    hintText: 'Street name',
                    controller: controller.streetCtrl, // 🎯 ភ្ជាប់ Controller
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionFieldLabel(
                    title: 'House / No.',
                    isOptional: true,
                  ),
                  const SizedBox(height: 6),
                  ProfileTextField(
                    prefixIcon: Icons.home_outlined,
                    hintText: 'e.g. 12A',
                    controller: controller.houseNoCtrl, // 🎯 ភ្ជាប់ Controller
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
