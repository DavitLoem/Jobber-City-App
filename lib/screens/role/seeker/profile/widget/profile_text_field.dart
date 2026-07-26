import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// A text field built specifically for the Profile / Edit Profile screens.
///
/// This is intentionally a separate widget from the shared `CustomTextfield`
/// used on the Sign In / Sign Up screens — those are auth-flow inputs and
/// should stay decoupled from profile-editing UI so the two can evolve
/// independently (different validation states, focus styling, disabled
/// look for "read-only" pickers like Date of Birth, etc.).
class ProfileTextField extends StatefulWidget {
  const ProfileTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData? prefixIcon;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color get _accentColor => !widget.enabled
      ? AppColors.iconDisabled
      : (_isFocused ? AppColors.inputFocusedBorder : AppColors.inputIconText);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isFocused ? 1.01 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        validator: widget.validator,
        textCapitalization: widget.textCapitalization,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: widget.enabled ? AppColors.inputText : AppColors.textDisabled,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: !widget.enabled
              ? AppColors.inputDisabledBackground
              : (_isFocused
                    ? AppColors.inputFocusedBackground
                    : AppColors.inputBackground),
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: AppColors.inputFocusedBorder,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: widget.prefixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Icon(widget.prefixIcon, size: 20, color: _accentColor),
                ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: _accentColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
