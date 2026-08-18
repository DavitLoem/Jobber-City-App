import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Label
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
            color: isDark
                ? AppColors.darkInputText
                : AppColors.inputText, // 🟢 Dynamic Text
          ),
          decoration: InputDecoration(
            hintText: hint,
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
                            : Colors.grey, // 🟢 Dynamic Icon
                      )
                    : null),
            filled: true,
            fillColor: isDark
                ? AppColors.darkInputBackground
                : Colors.white, // 🟢 Dynamic Fill
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade300,
              ), // 🟢 Dynamic Border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.primary : Colors.blueAccent,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
