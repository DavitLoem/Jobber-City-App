import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../home_employer_view.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ចាប់យក Controller
    final controller = Get.put(HomeEmployerViewController());

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Logo + greeting
              Obx(() {
                // 🎯 ទាញយកទិន្នន័យពី Controller
                final profile = controller.companyProfile.value;
                final companyName = profile?.companyName ?? 'Company Name';
                final hasLogo =
                    profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty;

                return Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4F7DF7,
                            ).withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      clipBehavior:
                          Clip.hardEdge, // 🎯 កាត់រូបភាពកុំឱ្យចេញក្រៅគែមសងខាង
                      child: hasLogo
                          ? Image.network(
                              profile.logoUrl!,
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    LucideIcons.building,
                                    color: Color(0xFF4f7df7),
                                  ),
                            )
                          : const Icon(
                              LucideIcons.building,
                              color: Color(0xFF4f7df7),
                            ),
                    ),
                    const SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Welcome back,",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF697386),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          companyName, // 🎯 បង្ហាញឈ្មោះពិតប្រាកដ
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1F36),
                            height: 1.2,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              // Right: actions ទុកដដែល[cite: 7]
              Row(
                children: [
                  _RoundIconButton(
                    icon: LucideIcons.search,
                    iconColor: const Color(0xFF697386),
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _RoundIconButton(
                    icon: LucideIcons.bell,
                    iconColor: const Color(0xFF1A1F36),
                    onTap: () {},
                    showDot: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Here's your hiring overview today.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF697386),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool showDot;

  const _RoundIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 20, color: iconColor),
              if (showDot)
                Positioned(
                  top: 9,
                  right: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEF4444),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
