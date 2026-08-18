import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/location_services.dart';
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
                          .tr // 🟢 Added .tr
                    : 'Your District'.tr, // 🟢 Added .tr
                onBackPressed: controller.goBack,
                showBackButton: controller.currentPage.value != 0,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: LocationSearchBar(
                      searchController: controller.searchController,
                      onChanged: controller.filterLocations,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isGettingCurrentLocation.value
                          ? null
                          : controller.getCurrentLocation,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: controller.isGettingCurrentLocation.value
                              ? LocationColors.muted
                              : LocationColors.accent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: controller.isGettingCurrentLocation.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.my_location_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                    ),
                  ),
                ],
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
      final error = controller.provinceError.value;

      if (error.isNotEmpty) {
        return _buildErrorState(
          error,
          onRetry: () => controller.fetchProvinces(),
        );
      }

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
            final error = controller.districtError.value;

            if (error.isNotEmpty) {
              return _buildErrorState(
                error,
                onRetry: () {
                  controller.fetchDistricts(
                    controller.selectedProvinceId.value,
                  );
                },
              );
            }

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

  Widget _buildErrorState(String error, {required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: LocationColors.border,
          ),
          const SizedBox(height: 12),
          Text(
            error,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: LocationColors.sub,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: LocationColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Retry'.tr), // 🟢 Added .tr
          ),
        ],
      ),
    );
  }
}
