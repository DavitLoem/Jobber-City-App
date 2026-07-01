import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPasswordField = false,
    required this.controller,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPasswordField;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.inputIconText,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: _isFocused
            ? AppColors.inputFocusedBackground
            : AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.inputFocusedBorder,
            width: 1.5,
          ),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: Icon(
                  widget.prefixIcon,
                  color: _isFocused
                      ? AppColors.inputFocusedBorder
                      : AppColors.inputIconText,
                ),
              )
            : null,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                padding: const EdgeInsets.only(right: 10.0),
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _isFocused
                      ? AppColors.inputFocusedBorder
                      : AppColors.inputIconText,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  widget.suffixIcon,
                  color: _isFocused
                      ? AppColors.inputFocusedBorder
                      : AppColors.inputIconText,
                ),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: _isFocused
              ? AppColors.inputFocusedBorder
              : AppColors.inputIconText,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
