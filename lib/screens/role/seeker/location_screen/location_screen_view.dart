import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/location_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/location_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widget/location_list_item.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widget/location_search_bar.dart';

part 'location_screen_binding.dart';
part 'location_screen_controller.dart';

class LocationScreenView extends GetView<LocationScreenController> {
  const LocationScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ១. Header — icon badge + title + subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_city_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Your City',
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select your city to find jobs near you',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textDisabled,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ២. Search Bar
            LocationSearchBar(
              controller: controller.searchController,
              onChanged: controller.filterLocations,
            ),

            // ៣. Selected chip — only shown once a city is picked
            Obx(() {
              final selected = controller.selectedLocation;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SizeTransition(
                    sizeFactor: anim,
                    axisAlignment: -1,
                    child: child,
                  ),
                ),
                child: selected == null
                    ? const SizedBox.shrink(key: ValueKey('no_chip'))
                    : Padding(
                        key: const ValueKey('chip'),
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                        child: Row(
                          children: [
                            Text(
                              'Selected:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDisabled,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 15,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    selected.nameEn,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: controller.clearSelection,
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }),

            const SizedBox(height: 4),

            // ៤. ListView
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      'No cities found',
                      style: TextStyle(color: AppColors.textDisabled),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final location = controller.filteredList[index];
                    return Obx(
                      () => LocationListItem(
                        location: location,
                        isSelected:
                            controller.selectedLocationId.value == location.id,
                        onTap: () => controller.selectLocation(location.id),
                      ),
                    );
                  },
                );
              }),
            ),

            // ៥. Footer — gradient Continue button with arrow
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Obx(() {
                final hasSelection =
                    controller.selectedLocationId.value.isNotEmpty;
                return GestureDetector(
                  onTap: controller.continueToNextScreen,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: hasSelection
                            ? [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.7),
                              ]
                            : [
                                AppColors.textDisabled.withOpacity(0.5),
                                AppColors.textDisabled.withOpacity(0.4),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: hasSelection
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [],
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
