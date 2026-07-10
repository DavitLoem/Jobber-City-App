import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';

class MainScreenEmloyerView extends GetView<MainScreenEmloyerController> {
  const MainScreenEmloyerView({super.key});

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.bookmark_outline_rounded,
      activeIcon: Icons.bookmark_rounded,
      label: 'My Jobs',
    ),
    _NavItem(
      icon: Icons.people_alt_outlined,
      activeIcon: Icons.people_alt_rounded,
      label: 'Candidates',
    ),
    _NavItem(
      icon:
          Icons.business_outlined, // ប្រើរូប Business សម្រាប់ Employer Profile
      activeIcon: Icons.business_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            _buildNavigator(1, AppRoutes.homeEmployer),
            _buildNavigator(2, AppRoutes.myJob),
            _buildNavigator(3, AppRoutes.candidates),
            _buildNavigator(4, AppRoutes.employerProfile),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => _BottomNav(
          currentIndex: controller.currentIndex.value,
          items: _navItems,
          onTap: controller.changeTab,
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

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(top: BorderSide(color: Colors.transparent, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final active = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary.withValues(alpha: 0.10)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          active ? item.activeIcon : item.icon,
                          size: 24,
                          color: active
                              ? AppColors.primary
                              : AppColors.navBarInactive,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: active
                              ? AppColors.primary
                              : AppColors.navBarInactive,
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
