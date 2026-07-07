import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/location_services.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widgets/location_continue_button.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widgets/location_empty_search.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widgets/location_header.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widgets/location_search_bar.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widgets/location_selected_chip.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widgets/location_tile.dart';

part 'location_screen_binding.dart';
part 'location_screen_controller.dart';

class LocationScreenView extends GetView<LocationScreenController> {
  const LocationScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocationColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => LocationHeader(
                title: controller.currentPage.value == 0
                    ? 'Your City'
                    : 'Your District',
                onBackPressed: controller.goBack,
                showBackButton: controller.currentPage.value != 0,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LocationSearchBar(
                searchController: controller.searchController,
                onChanged: controller.filterLocations,
              ),
            ),
            const SizedBox(height: 16),

            // ── PageView (ស្លាយចុះឡើងរវាង ខេត្ត និង ស្រុក) ──
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  // 🔹 ទំព័រទី ១៖ បញ្ជីខេត្ត
                  _buildProvincePage(),
                  _buildDistrictPage(),
                ],
              ),
            ),
            LocationContinueButton(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildProvincePage() {
    return Obx(() {
      if (controller.isProvinceLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: LocationColors.accent),
        );
      }

      final list = controller.provincesList;
      if (list.isEmpty) return const LocationEmptySearch();

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 2),
        itemBuilder: (context, index) {
          final province = list[index];
          return Obx(() {
            final isSelected =
                controller.selectedProvinceId.value == province.id;
            return LocationTile(
              location: province,
              isSelected: isSelected,
              onTap: () => controller.onProvinceSelected(province.id),
            );
          });
        },
      );
    });
  }

  Widget _buildDistrictPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Chip បង្ហាញខេត្តដែលបានរើស
        Obx(() {
          final selectedProv = controller.provincesList.firstWhereOrNull(
            (p) => p.id == controller.selectedProvinceId.value,
          );
          if (selectedProv == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: LocationSelectedChip(
              cityName: selectedProv.nameEn,
              onClear: controller.goBack,
            ),
          );
        }),

        Expanded(
          child: Obx(() {
            if (controller.isDistrictLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: LocationColors.accent),
              );
            }

            final list = controller.districtsList;
            if (list.isEmpty) return const LocationEmptySearch();

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final district = list[index];
                return Obx(() {
                  final isSelected =
                      controller.selectedDistrictId.value == district.id;
                  return LocationTile(
                    location: district,
                    isSelected: isSelected,
                    onTap: () => controller.onDistrictSelected(district.id),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
