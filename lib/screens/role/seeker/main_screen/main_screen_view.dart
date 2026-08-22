import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_controller.dart';

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

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
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.withValues(
            alpha: 0.2,
          ), // ពណ៌ Background ពេលចុច
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: Colors.blue),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark_rounded, color: Colors.blue),
              label: "Saved",
            ),
            NavigationDestination(
              icon: Icon(Icons.description_outlined),
              selectedIcon: Icon(Icons.description_rounded, color: Colors.blue),
              label: "Applications",
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble_rounded, color: Colors.blue),
              label: "Chats",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded, color: Colors.blue),
              label: "Profile",
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
