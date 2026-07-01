import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// A text-field-styled selector for City / Province (or any other
/// API-backed single-select list).
///
/// Looks exactly like [CustomTextfield] (same prefix icon, same dropdown
/// arrow, same background/border styling) but it is read-only and tapping
/// it opens a bottom sheet list of items loaded from the API via
/// [fetchOptions]. Selecting an item fills [controller] with whatever
/// [labelOf] returns for it, and reports the full object back via
/// [onSelected] so you can pull out the id (or anything else) for your
/// request payload.
///
/// Generic over [T] so it can be used directly with your real model
/// (e.g. `CitySelectField<LocationModel>`) without needing a wrapper class.
class CitySelectField<T> extends StatefulWidget {
  const CitySelectField({
    super.key,
    required this.controller,
    required this.fetchOptions,
    required this.labelOf,
    this.hintText = 'Select City / Province',
    this.prefixIcon = Icons.location_city_outlined,
    this.onSelected,
    this.validator,
    this.sheetTitle = 'Select City / Province',
    this.searchHint = 'Search city...',
    this.enabled = true,
    this.showSeparators = true,
  });

  final TextEditingController controller;

  /// Should call your API and return the list of available items.
  /// e.g. () => LocationServices().getLocation()
  final Future<List<T>> Function() fetchOptions;

  /// How to turn an item of type [T] into the text shown in the list /
  /// field. e.g. (location) => location.name
  final String Function(T option) labelOf;

  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final String sheetTitle;
  final String searchHint;
  final bool enabled;
  final bool showSeparators;

  /// Called with the selected item when the user picks one, so you can
  /// pull its id (or anything else) for your update request.
  final void Function(T option)? onSelected;

  @override
  State<CitySelectField<T>> createState() => _CitySelectFieldState<T>();
}

class _CitySelectFieldState<T> extends State<CitySelectField<T>> {
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

  Future<void> _openPicker() async {
    if (!widget.enabled) return;

    _focusNode.requestFocus();

    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OptionPickerSheet<T>(
        fetchOptions: widget.fetchOptions,
        labelOf: widget.labelOf,
        title: widget.sheetTitle,
        searchHint: widget.searchHint,
        showSeparators: widget.showSeparators,
      ),
    );

    _focusNode.unfocus();

    if (selected != null) {
      widget.controller.text = widget.labelOf(selected);
      widget.onSelected?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: true,
      showCursor: false,
      onTap: widget.enabled ? _openPicker : null,
      enabled: widget.enabled,
      validator: widget.validator,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: widget.enabled ? AppColors.inputIconText : Colors.grey,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.enabled
            ? (_isFocused
                  ? AppColors.inputFocusedBackground
                  : AppColors.inputBackground)
            : AppColors.inputDisabledBackground,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Icon(
            widget.prefixIcon,
            color: widget.enabled
                ? (_isFocused
                      ? AppColors.inputFocusedBorder
                      : AppColors.inputIconText)
                : AppColors.iconDisabled,
          ),
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: widget.enabled
              ? (_isFocused
                    ? AppColors.inputFocusedBorder
                    : AppColors.inputIconText)
              : AppColors.iconDisabled,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.enabled
              ? (_isFocused
                    ? AppColors.inputFocusedBorder
                    : AppColors.inputIconText)
              : AppColors.iconDisabled,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

/// Bottom sheet that loads the option list from the API and lets the user
/// search + pick one.
class _OptionPickerSheet<T> extends StatefulWidget {
  const _OptionPickerSheet({
    required this.fetchOptions,
    required this.labelOf,
    required this.title,
    required this.searchHint,
    this.showSeparators = true,
  });

  final Future<List<T>> Function() fetchOptions;
  final String Function(T option) labelOf;
  final String title;
  final String searchHint;
  final bool showSeparators;

  @override
  State<_OptionPickerSheet<T>> createState() => _OptionPickerSheetState<T>();
}

class _OptionPickerSheetState<T> extends State<_OptionPickerSheet<T>> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<T> _allOptions = [];
  List<T> _filteredOptions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOptions();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final options = await widget.fetchOptions();
      setState(() {
        _allOptions = options;
        _filteredOptions = options;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load list. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filteredOptions = query.isEmpty
          ? _allOptions
          : _allOptions
                .where((o) => widget.labelOf(o).toLowerCase().contains(query))
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inputIconText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildBody(scrollController)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(ScrollController scrollController) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: _loadOptions, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_filteredOptions.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    if (widget.showSeparators) {
      return ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: _filteredOptions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final option = _filteredOptions[index];
          return ListTile(
            title: Text(
              widget.labelOf(option),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.inputIconText,
              ),
            ),
            onTap: () => Navigator.pop(context, option),
          );
        },
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: _filteredOptions.length,
      itemBuilder: (context, index) {
        final option = _filteredOptions[index];
        return ListTile(
          title: Text(
            widget.labelOf(option),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.inputIconText,
            ),
          ),
          onTap: () => Navigator.pop(context, option),
        );
      },
    );
  }
}
