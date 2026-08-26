import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/location_screen_view.dart';

class LocationContinueButton extends StatefulWidget {
  final LocationScreenController controller;
  const LocationContinueButton({super.key, required this.controller});

  @override
  State<LocationContinueButton> createState() => _LocationContinueButtonState();
}

class _LocationContinueButtonState extends State<LocationContinueButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(_pressCtrl);
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Obx(() {
      final isProvincePage = widget.controller.currentPage.value == 0;

      final hasSelection = isProvincePage
          ? widget.controller.selectedProvinceId.value.isNotEmpty
          : widget.controller.selectedDistrictId.value.isNotEmpty;

      final disableText = isProvincePage
          ? 'Select a City to Continue'
                .tr // 🟢 Added .tr
          : 'Select a District to Continue'.tr; // 🟢 Added .tr

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: GestureDetector(
          onTapDown: hasSelection ? (_) => _pressCtrl.forward() : null,
          onTapUp: hasSelection
              ? (_) {
                  _pressCtrl.reverse();
                  widget.controller.continueToNextScreen();
                }
              : null,
          onTapCancel: () => _pressCtrl.reverse(),
          child: ScaleTransition(
            scale: _scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 56,
              decoration: BoxDecoration(
                gradient: hasSelection
                    ? const LinearGradient(
                        colors: [
                          LocationColors.accent,
                          LocationColors.accentLt,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : LinearGradient(
                        colors: isDark
                            ? [
                                AppColors.darkSurfaceElevated,
                                AppColors.darkSurfaceElevated,
                              ]
                            : const [
                                Color(0xFFCCCCCC),
                                Color(0xFFDDDDDD),
                              ], // 🟢 Dynamic BG
                      ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: hasSelection
                    ? [
                        BoxShadow(
                          color: LocationColors.accent.withValues(
                            alpha: 0.38,
                          ), // 🟢 Updated to withValues
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hasSelection
                          ? 'Continue'.tr
                          : disableText, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: hasSelection
                            ? Colors.white
                            : (isDark
                                  ? AppColors.darkTextHint
                                  : const Color(0xFFAAAAAA)), // 🟢 Dynamic Text
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (hasSelection) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
