import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/api/services/category_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/onboarding_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/widgets/category_footer.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/widgets/category_header.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/widgets/category_list.dart';
import 'package:jobber_city/screens/role/seeker/expertise_screen/widgets/category_search_bar.dart';

import '../../../../models/category_model.dart';

part 'category_screen_binding.dart';
part 'category_screen_controller.dart';

class CategoryScreenView extends GetView<CategoryScreenViewController> {
  const CategoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // 🟢 Dynamic Theme Background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryHeader(),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CategorySearchBar(controller: controller),
                  ),
                  const SizedBox(height: 15),

                  Divider(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.line, // 🟢 Dynamic Divider
                    thickness: 1.8,
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: CategoryList(controller: controller)),
                ],
              ),
            ),

            CategoryFooter(controller: controller),
          ],
        ),
      ),
    );
  }
}
