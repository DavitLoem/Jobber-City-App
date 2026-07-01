import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';

// 🟢 កុំភ្លេច Import View ទាំងពីរនេះចូល
import 'package:jobber_city/screens/role/seeker/home_seeker/home_seeker_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';
import 'package:jobber_city/screens/role/seeker/main_screen/main_screen_controller.dart';

class MainScreenView extends GetView<MainScreenController> {
  MainScreenView({super.key});

  // 🟢 បញ្ចូលទំព័រពិតប្រាកដរបស់អ្នកនៅទីនេះ
  final List<Widget> pages = [
    const HomeSeekerView(),
    const Center(child: Text("Saved Jobs", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Applications", style: TextStyle(fontSize: 24))),
    const ProfileScreenView(), // 👈 ទំព័រ Profile
  ];

  @override
  Widget build(BuildContext context) {
    // 🚀 ដំណោះស្រាយ ១០០%: បង្ខំបញ្ចូល Controller ទាំងអស់នៅទីនេះមុនពេល UI ចាប់ផ្តើម!
    Get.put(MainScreenController());
    Get.put(HomeSeekerViewController());
    // EditProfileScreenViewController is already registered in MainScreenBinding

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // 🟢 IndexedStack
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),

      // 🟢 Cuberto Bottom Bar
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
              tabColor: Colors.orange,
            ),
            TabData(
              iconData: Icons.description_rounded,
              title: "Applied",
              tabColor: Colors.teal,
            ),
            TabData(
              iconData: Icons.person_rounded,
              title: "Profile",
              tabColor: Colors.purple,
            ),
          ],
          onTabChangedListener: (position, title, color) {
            controller.changeTab(position);
          },
        ),
      ),
    );
  }
}
