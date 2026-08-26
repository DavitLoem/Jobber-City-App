import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/screens/role/seeker/profile/widget/profile_text_field.dart';

import 'section_field_label.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({super.key, required this.controller});

  final EditProfileScreenViewController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionFieldLabel(title: 'Province'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        CitySelectField<LocationModel>(
          controller: controller.provinceCtrl,
          fetchOptions: controller.fetchProvinceOptions,
          labelOf: (loc) => loc.nameEn.tr, // 🟢 Translate Location Name
          hintText: 'Select Province'.tr, // 🟢 Added .tr
          sheetTitle: 'Select Province'.tr, // 🟢 Added .tr
          onSelected: (loc) {
            controller.selectedProvinceId.value = loc.id.toString();
            controller.provinceCtrl.text = loc.nameEn.tr;

            controller.districtCtrl.clear();
            controller.selectedDistrictId.value = '';
          },
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(title: 'District / Khan'.tr), // 🟢 Added .tr
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
                labelOf: (d) => d.nameEn.tr, // 🟢 Translate Location Name
                hintText: controller.selectedProvinceId.value.isEmpty
                    ? 'Select province first'
                          .tr // 🟢 Added .tr
                    : 'Select District'.tr, // 🟢 Added .tr
                sheetTitle: 'Select District'.tr, // 🟢 Added .tr
                enabled: controller.selectedProvinceId.value.isNotEmpty,
                onSelected: (d) {
                  controller.selectedDistrictId.value = d.id.toString();
                  controller.districtCtrl.text = d.nameEn.tr;
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),

        SectionFieldLabel(title: 'Commune / Sangkat'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.location_on_outlined,
          hintText: 'Enter commune'.tr, // 🟢 Added .tr
          controller: controller.communeCtrl,
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(
          title: 'Village'.tr,
          isOptional: true,
        ), // 🟢 Added .tr
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.holiday_village_outlined,
          hintText: 'Enter village'.tr, // 🟢 Added .tr
          controller: controller.villageCtrl,
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionFieldLabel(
                    title: 'Street'.tr,
                    isOptional: true,
                  ), // 🟢 Added .tr
                  const SizedBox(height: 6),
                  ProfileTextField(
                    prefixIcon: Icons.signpost_outlined,
                    hintText: 'Street name'.tr, // 🟢 Added .tr
                    controller: controller.streetCtrl,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionFieldLabel(
                    title: 'House / No.'.tr, // 🟢 Added .tr
                    isOptional: true,
                  ),
                  const SizedBox(height: 6),
                  ProfileTextField(
                    prefixIcon: Icons.home_outlined,
                    hintText: 'e.g. 12A'.tr, // 🟢 Added .tr
                    controller: controller.houseNoCtrl,
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
