import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomAnimatedCheckbox extends StatefulWidget {
  final bool value;
  final VoidCallback onTap;
  final String label;

  // Made optional with "?" so it works seamlessly for simple text rows too
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
            // Custom Animated Checkbox box
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 19,
              height: 19,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: widget.value
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: widget.value
                      ? AppColors.buttonPrimary
                      : Colors.grey.shade400,
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
            // Flexibly generated Text Label
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (widget.linkText != null)
                      TextSpan(
                        text: widget.linkText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLink,
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
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (widget.linkText2 != null)
                      TextSpan(
                        text: widget.linkText2,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLink,
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
