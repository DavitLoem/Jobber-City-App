import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.isPasswordField = false,
    required this.controller,

    // 🎯 បន្ថែម Properties ថ្មីៗសម្រាប់ TextFormField
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool isPasswordField;
  final TextEditingController controller;

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
    // 🎯 ប្តូរពី TextField ទៅ TextFormField
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      style: const TextStyle(color: AppColors.inputText),

      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction ?? TextInputAction.next,

      decoration: InputDecoration(
        filled: true,
        fillColor: _isFocused
            ? AppColors.inputFocusedBackground
            : AppColors.inputBackground,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.inputFocusedBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: AppColors.inputErrorBorder),
        ),
        // 🎯 ពេលមាន Error ឱ្យវានៅតែមានរាងកោងស្អាត
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: AppColors.inputErrorBorder, width: 2),
        ),

        prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Icon(
            widget.prefixIcon,
            color: _isFocused
                ? AppColors.inputFocusedBorder
                : AppColors.inputIconText,
          ),
        ),

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
        ),
      ),
    );
  }
}
