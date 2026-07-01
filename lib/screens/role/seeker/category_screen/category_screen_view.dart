import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jobber_city/core/api/services/role/category_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/role/category_model.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/widgets/arrow_key_back.dart';

import 'package:jobber_city/widgets/custom_button.dart';

part 'category_screen_binding.dart';
part 'category_screen_controller.dart';

class CategoryScreenView extends GetView<CategoryScreenViewController> {
  const CategoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ArrowKeyBack(),

              const SizedBox(height: 20),

              Expanded(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 15),
                    _buildDivider(),
                    const SizedBox(height: 15),
                    Expanded(child: _buildCategories()),
                  ],
                ),
              ),

              const SizedBox(height: 13),
              _buildDivider(),
              const SizedBox(height: 10),
              CustomButton(
                text: "Continue",
                onPressed: () => controller.continueToNextScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.categoriesList.isEmpty) {
        return const Center(child: Text("No categories found."));
      }

      return ListView.builder(
        itemCount: controller.categoriesList.length,
        itemBuilder: (context, index) {
          final category = controller.categoriesList[index];

          return Obx(() {
            final isSelected = controller.selectedCategoryIds.contains(
              category.id,
            );

            return GestureDetector(
              onTap: () => controller.toggleSelection(category.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.05)
                      : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.buttonOutlineBorder,
                          width: 1.7,
                        ),
                      ),
                      child: AnimatedScale(
                        scale: isSelected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutBack,
                        child: const Icon(
                          Icons.check,
                          color: AppColors.primaryLight,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.line, thickness: 1.8);
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "What is Your Experience?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Please select your field of expertise (up to 5)",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
