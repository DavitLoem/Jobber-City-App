import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainScreenEmloyerView extends GetView<MainScreenEmloyerController> {
  const MainScreenEmloyerView({super.key});

  // 🟢 Converted to getter so .tr updates instantly when language changes
  List<_NavItem> get _navItems => [
    _NavItem(
      icon: LucideIcons.home,
      activeIcon: LucideIcons.home,
      label: 'Home'.tr, // 🟢 Added .tr
    ),
    _NavItem(
      icon: LucideIcons.briefcase,
      activeIcon: LucideIcons.briefcase,
      label: 'My Jobs'.tr, // 🟢 Added .tr
    ),
    _NavItem(
      icon: LucideIcons.users,
      activeIcon: LucideIcons.users,
      label: 'Candidates'.tr, // 🟢 Added .tr
    ),
    _NavItem(
      icon: LucideIcons.messageSquare,
      activeIcon: LucideIcons.messageSquare,
      label: 'Chats'.tr, // 🟢 Added .tr
    ),
    _NavItem(
      icon: LucideIcons.user,
      activeIcon: LucideIcons.user,
      label: 'Profile'.tr, // 🟢 Added .tr
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG

      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            _buildNavigator(1, AppRoutes.homeEmployer),
            _buildNavigator(2, AppRoutes.myJob),
            _buildNavigator(3, AppRoutes.candidates),
            _buildNavigator(4, AppRoutes.conversationList),
            _buildNavigator(5, AppRoutes.employerProfile),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => _BottomNav(
          currentIndex: controller.currentIndex.value,
          items: _navItems,
          onTap: controller.changeTab,
          theme: theme, // 🟢 Pass down theme context
          isDark: isDark,
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
  final ThemeData theme;
  final bool isDark;

  const _BottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // 🟢 Dynamic Navigation Bar BG
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.06,
            ), // 🟢 Dynamic Shadow
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkDivider
                : Colors.transparent, // 🟢 Dark Top Border
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final active = i == currentIndex;

              // 🟢 Dynamic Inactive icon/text coloring
              final inactiveColor = isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.navBarInactive;

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
                              ? AppColors.primary.withValues(
                                  alpha: isDark ? 0.15 : 0.10,
                                ) // 🟢 Dynamic Active Bubble
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          active ? item.activeIcon : item.icon,
                          size: 24,
                          color: active ? AppColors.primary : inactiveColor,
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
                          color: active ? AppColors.primary : inactiveColor,
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
