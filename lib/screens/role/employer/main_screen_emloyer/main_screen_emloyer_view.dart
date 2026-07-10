import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:jobber_city/screens/role/employer/home_employer/home_employer_view.dart';
import 'package:jobber_city/screens/role/employer/recruit/post_job_screen/post_job_screen_view.dart';
import 'package:jobber_city/screens/role/employer/company_profile/company_profile_view.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:jobber_city/screens/role/employer/recruit/recruit_screen/recruit_screen_view.dart';

class MainScreenEmloyerView extends GetView<MainScreenEmloyerController> {
  MainScreenEmloyerView({super.key});

  // 🟢 បញ្ចូលទំព័រពិតប្រាកដរបស់អ្នកនៅទីនេះ
  final List<Widget> pages = [
    const HomeEmployerView(),
    const RecruitScreenView(), // 👈 ទំព័រ Post Job
    const CompanyProfileView(), // 👈 ទំព័រ Profile
  ];

  @override
  Widget build(BuildContext context) {
    // 🚀 បង្ខំបញ្ចូល Controller ទាំងអស់នៅទីនេះមុនពេល UI ចាប់ផ្តើម!
    Get.put(MainScreenEmloyerController());
    Get.put(HomeEmployerViewController());
    // PostJobScreenViewController and CompanyProfileViewController are handled by binding
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
