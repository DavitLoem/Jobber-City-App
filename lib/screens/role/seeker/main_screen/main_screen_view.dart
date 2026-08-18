import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors import
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_controller.dart';

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 Grab the active theme data
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic Scaffold BG
      // 🎯 ប្រើ IndexedStack ផ្ទុក Navigators ទាំង ៤
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            _buildNavigator(1, AppRoutes.homeSeeker),
            _buildNavigator(2, AppRoutes.saveJob),
            _buildNavigator(3, '/applied'),
            _buildNavigator(4, '/profile'),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => CubertoBottomBar(
          key: const Key("BottomBar"),
          // 🟢 Dynamic inactive icon color depending on theme mode
          inactiveIconColor: isDark
              ? AppColors.darkTextSecondary
              : Colors.grey.shade400,
          tabStyle: CubertoTabStyle.styleFadedBackground,
          selectedTab: controller.currentIndex.value,
          tabs: [
            TabData(
              iconData: Icons.home_rounded,
              title: "Home".tr, // 🟢 Added .tr
              tabColor: AppColors.primary,
            ),
            TabData(
              iconData: Icons.bookmark_rounded,
              title: "Saved".tr, // 🟢 Added .tr
              tabColor: AppColors.primary,
            ),
            TabData(
              iconData: Icons.description_rounded,
              title: "Applications".tr, // 🟢 Added .tr
              tabColor: AppColors.primary,
            ),
            TabData(
              iconData: Icons.person_rounded,
              title: "Profile".tr, // 🟢 Added .tr
              tabColor: AppColors.primary,
            ),
          ],
          onTabChangedListener: (position, title, color) {
            controller.changeTab(position);
          },
        ),
      ),
    );
  }

  Widget _buildNavigator(int nestedId, String initialRoute) {
    return Navigator(
      key: Get.nestedKey(nestedId),
      initialRoute: initialRoute,
      onGenerateRoute: controller.onGenerateRoute,
    );
  }
}
