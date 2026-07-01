import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/models/role/location_model.dart';

class EditProfileScreenView extends GetView<EditProfileScreenViewController> {
  const EditProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Obx(() {
                controller.firstNameController.text =
                    controller.firstName.value;
                return TextField(
                  controller: controller.firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                controller.lastNameController.text = controller.lastName.value;
                return TextField(
                  controller: controller.lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                controller.emailController.text = controller.email.value;
                return TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                controller.positionController.text = controller.position.value;
                return TextField(
                  controller: controller.positionController,
                  decoration: const InputDecoration(
                    labelText: 'Position (Category)',
                    hintText: 'Select categories',
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              const SizedBox(height: 20),
              CitySelectField<LocationModel>(
                controller: controller.provinceController,
                fetchOptions: controller.fetchProvinceOptions,
                labelOf: (location) => location.nameEn,
                hintText: 'Select Province',
                sheetTitle: 'Select Province',
                onSelected: (location) {
                  controller.selectedProvinceId.value = location.id.toString();
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
