import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_controller.dart';

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // 🎯 ប្រើ IndexedStack ផ្ទុក Navigators ទាំង ៤
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            _buildNavigator(1, AppRoutes.homeSeeker),
            _buildNavigator(2, AppRoutes.saveJob),
            _buildNavigator(3, '/applied'),
            _buildNavigator(4, AppRoutes.conversationList),
            _buildNavigator(5, '/profile'),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeTab,
          backgroundColor: theme.cardColor,
          surfaceTintColor:
              Colors.transparent, // 🟢 Ensures clean look in Dark Mode
          indicatorColor: AppColors.primary.withValues(
            alpha: 0.2,
          ), // ពណ៌ Background ពេលចុច
          destinations: [
            // 🟢 Removed const to allow .tr to evaluate dynamically
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(
                Icons.home_rounded,
                color: AppColors.primary,
              ),
              label: "Home".tr, // 🟢 Added .tr
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_outline),
              selectedIcon: const Icon(
                Icons.bookmark_rounded,
                color: AppColors.primary,
              ),
              label: "Saved".tr, // 🟢 Added .tr
            ),
            NavigationDestination(
              icon: const Icon(Icons.description_outlined),
              selectedIcon: const Icon(
                Icons.description_rounded,
                color: AppColors.primary,
              ),
              label: "Applications".tr, // 🟢 Added .tr
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline),
              selectedIcon: const Icon(
                Icons.chat_bubble_rounded,
                color: AppColors.primary,
              ),
              label: "Chats".tr, // 🟢 Added .tr
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
              ),
              label: "Profile".tr, // 🟢 Added .tr
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigator(int nestedId, String initialRoute) {
    return Navigator(
      key: Get.nestedKey(nestedId), // កំណត់ ID ផ្តាច់មុខឱ្យ Tab នីមួយៗ
      initialRoute: initialRoute, // តម្រុយទៅកាន់ onGenerateRoute (ឧ. /home)
      onGenerateRoute: controller.onGenerateRoute,
    );
  }
}
