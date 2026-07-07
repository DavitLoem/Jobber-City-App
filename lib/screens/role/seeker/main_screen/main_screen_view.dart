import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
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
            _buildNavigator(2, '/saved'),
            _buildNavigator(3, '/applied'),
            _buildNavigator(4, '/profile'),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => CubertoBottomBar(
          key: const Key("BottomBar"),
          inactiveIconColor: Colors.grey.shade400,
          tabStyle: CubertoTabStyle.styleFadedBackground,
          selectedTab: controller.currentIndex.value,
          tabs: [
            TabData(
              iconData: Icons.home_rounded,
              title: "Home",
              tabColor: Colors.blue,
            ),
            TabData(
              iconData: Icons.bookmark_rounded,
              title: "Saved",
              tabColor: Colors.blue,
            ),
            TabData(
              iconData: Icons.description_rounded,
              title: "Applications",
              tabColor: Colors.blue,
            ),
            TabData(
              iconData: Icons.person_rounded,
              title: "Profile",
              tabColor: Colors.blue,
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
      key: Get.nestedKey(nestedId), // កំណត់ ID ផ្តាច់មុខឱ្យ Tab នីមួយៗ
      initialRoute: initialRoute, // តម្រុយទៅកាន់ onGenerateRoute (ឧ. /home)
      onGenerateRoute: controller.onGenerateRoute,
    );
  }
}
