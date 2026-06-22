import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    // 🎯 2. បើកំពុង Loading មិនអនុញ្ញាតឱ្យមានចលនា ឬដំណើរការ Function ទេ
    if (widget.isLoading) return;

    // Animate down
    _animationController.forward();

    widget.onPressed!(); // 4. Call with '!' since we checked for null above

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            // 🎯 3. ពេល Disable ប៊ូតុង ពណ៌អក្សរនឹងប្តូរដោយស្វ័យប្រវត្តិ
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
            foregroundColor: AppColors.buttonPrimaryText,
            shadowColor: AppColors.buttonPrimary.withValues(alpha: 0.7),
            elevation: widget.isLoading ? 0 : 3, // ដកស្រមោលចេញពេលកំពុង Loading
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // 🎯 4. បើ isLoading = true ដាក់ null ដើម្បី Disable ប៊ូតុង
          onPressed: widget.isLoading ? null : _onButtonPressed,
          // 🎯 5. ផ្លាស់ប្តូរ UI ទៅតាមស្ថានភាព Loading
          child: widget.isLoading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5, // ធ្វើឱ្យរង្វង់រាងស្តើង និងស្អាត
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Processing...', // ពាក្យ Professional ជំនួសឱ្យ Loading
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
