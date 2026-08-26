import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors

class CustomFormTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isDropdown;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  const CustomFormTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isDropdown = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.onTap,
    this.inputFormatters,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white70
                  : Colors.black87, // 🟢 Dynamic Label Color
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: isDropdown || readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onTap: onTap,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ), // 🟢 Dynamic Input Text
          decoration: InputDecoration(
            hintText: hint.tr, // 🟢 Added .tr
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.darkTextHint
                  : Colors.grey.shade400, // 🟢 Dynamic Hint
              fontSize: 14,
            ),
            suffixIcon:
                suffixIcon ??
                (isDropdown
                    ? Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark
                            ? AppColors.darkIconSecondary
                            : Colors.grey, // 🟢 Dynamic Dropdown Icon
                      )
                    : null),

            filled: true,
            fillColor: isDark
                ? AppColors.darkInputBackground
                : Colors.white, // 🟢 Dynamic BG
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.darkCardBorder
                    : Colors.grey.shade300, // 🟢 Dynamic Border
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.blueAccent
                    : Colors.blueAccent, // Consistent branding
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
