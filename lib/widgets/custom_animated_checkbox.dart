import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomAnimatedCheckbox extends StatefulWidget {
  final bool value;
  final VoidCallback onTap;
  final String label;
  final String? linkText;
  final String? labelText;
  final String? linkText2;
  final VoidCallback? onLinkTap;
  final VoidCallback? onLinkTap2;

  const CustomAnimatedCheckbox({
    super.key,
    required this.value,
    required this.onTap,
    required this.label,
    this.linkText,
    this.labelText,
    this.linkText2,
    this.onLinkTap,
    this.onLinkTap2,
  });

  @override
  State<CustomAnimatedCheckbox> createState() => _CustomAnimatedCheckboxState();
}

class _CustomAnimatedCheckboxState extends State<CustomAnimatedCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.0,
      upperBound: 0.06,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - _animationController.value,
          child: child,
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) {
          _animationController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _animationController.reverse(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: widget.value
                    ? AppColors.primary
                    : Colors.transparent, // 🟢 Switched to brand primary
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: widget.value
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.darkCardBorder
                            : Colors
                                  .grey
                                  .shade400), // 🟢 Dynamic Checkbox Border
                  width: 2,
                ),
              ),
              child: AnimatedScale(
                scale: widget.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary, // 🟢 Dynamic Text
                      ),
                    ),
                    if (widget.linkText != null)
                      TextSpan(
                        text: widget.linkText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.blueAccent
                              : AppColors.textLink, // 🟢 Dynamic Link
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (widget.onLinkTap != null) widget.onLinkTap!();
                          },
                      ),
                    if (widget.labelText != null)
                      TextSpan(
                        text: widget.labelText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary, // 🟢 Dynamic Text
                        ),
                      ),
                    if (widget.linkText2 != null)
                      TextSpan(
                        text: widget.linkText2,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.blueAccent
                              : AppColors.textLink, // 🟢 Dynamic Link
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (widget.onLinkTap2 != null) widget.onLinkTap2!();
                          },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
