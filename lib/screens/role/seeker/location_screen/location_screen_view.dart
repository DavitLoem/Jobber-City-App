import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/location_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/location_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widget/location_list_item.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/widget/location_search_bar.dart';
import 'package:jobber_city/widgets/custom_button.dart';

part 'location_screen_binding.dart';
part 'location_screen_controller.dart';

class LocationScreenView extends GetView<LocationScreenController> {
  const LocationScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ១. Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Text(
                    'Your City',
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
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

            const SizedBox(height: 8),

            // ៣. ListView
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
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
                        onTap: () =>
                            controller.selectedLocationId.value = location.id,
                      ),
                    );
                  },
                );
              }),
            ),

            // ៤. Footer
            Divider(color: AppColors.line, thickness: 1.8),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                text: "Continue",
                onPressed: () => controller.continueToNextScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
