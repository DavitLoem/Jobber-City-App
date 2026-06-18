import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class LocationSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const LocationSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        focusNode: _focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
          hintText: 'Search by province, area or city',
          hintStyle: TextStyle(color: AppColors.textDisabled),
          prefixIcon: Icon(
            Icons.search,
            color: _isFocused ? AppColors.primary : AppColors.textDisabled,
          ),
          filled: true,
          fillColor: _isFocused
              ? AppColors.inputFocusedBackground
              : AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _isFocused ? AppColors.primary : Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }
}
