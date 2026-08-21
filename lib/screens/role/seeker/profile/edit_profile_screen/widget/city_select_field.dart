import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// A text-field-styled selector for City / Province (or any other
/// API-backed single-select list).
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
  final Future<List<T>> Function() fetchOptions;
  final String Function(T option) labelOf;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final String sheetTitle;
  final String searchHint;
  final bool enabled;
  final bool showSeparators;
  final void Function(T option)? onSelected;

  @override
  State<CitySelectField<T>> createState() => _CitySelectFieldState<T>();
}

class _CitySelectFieldState<T> extends State<CitySelectField<T>>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isOpen = false;
  // 🟢 បន្ថែមអថេរសម្រាប់តាមដានថាមានទិន្នន័យ (អក្សរ) ត្រូវបានជ្រើសរើសឬអត់
  bool _hasText = false;

  late final AnimationController _arrowController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  @override
  void initState() {
    super.initState();
    _hasText =
        widget.controller.text.isNotEmpty; // ឆែកមើលពេលបើកមកដំបូង[cite: 48]

    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });

    // 🟢 ស្តាប់រាល់ពេលមានការផ្លាស់ប្តូរនៅក្នុង Controller[cite: 48]
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _hasText = widget.controller.text.isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  Future<void> _openPicker() async {
    if (!widget.enabled) return;

    _focusNode.requestFocus();
    setState(() => _isOpen = true);
    _arrowController.forward();
    HapticFeedback.selectionClick();

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
        selectedLabel: widget.controller.text,
      ),
    );

    _focusNode.unfocus();
    _arrowController.reverse();
    if (mounted) setState(() => _isOpen = false);

    if (selected != null) {
      widget.controller.text = widget.labelOf(selected);
      widget.onSelected?.call(selected);
    }
  }

  // 🟢 កែប្រែ Logic ពណ៌ Icon ត្រង់នេះឲ្យដូចទៅនឹង ProfileTextField[cite: 48]
  Color get _accentColor {
    if (!widget.enabled) return AppColors.iconDisabled;
    if (_isFocused || _isOpen) return AppColors.inputFocusedBorder;
    if (_hasText) {
      return AppColors.inputIconText; // ប្តូរទៅពណ៌ខ្មៅពេលមានទិន្នន័យជ្រើសរើសរួច
    }
    return AppColors.inputIconText;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: (_isFocused || _isOpen) ? 1.01 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: TextFormField(
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
          color: widget.enabled ? Colors.black87 : Colors.grey,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.enabled
              ? ((_isFocused || _isOpen)
                    ? AppColors.inputFocusedBackground
                    : AppColors.inputBackground)
              : AppColors.inputDisabledBackground,
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
            borderSide: BorderSide(
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
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                widget.prefixIcon,
                // 🟢 បន្ថែម _hasText ចូលក្នុង Key ដើម្បីឲ្យវា Animates ដូរពណ៌
                key: ValueKey('$_isFocused-$_isOpen-$_hasText'),
                color: _accentColor,
              ),
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_arrowController),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _accentColor,
              ),
            ),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            // 🟢 Hint Text នៅតែជាពណ៌ប្រផេះធម្មតា
            color: widget.enabled
                ? AppColors.inputIconText
                : AppColors.iconDisabled,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
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
    this.selectedLabel,
  });

  final Future<List<T>> Function() fetchOptions;
  final String Function(T option) labelOf;
  final String title;
  final String searchHint;
  final bool showSeparators;
  final String? selectedLabel;

  @override
  State<_OptionPickerSheet<T>> createState() => _OptionPickerSheetState<T>();
}

class _OptionPickerSheetState<T> extends State<_OptionPickerSheet<T>> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<T> _allOptions = [];
  List<T> _filteredOptions = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasQuery = false;

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
      _hasQuery = query.isNotEmpty;
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
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.inputIconText,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.close_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.inputIconText,
                    ),
                    suffixIcon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: _hasQuery
                          ? IconButton(
                              key: const ValueKey('clear'),
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () => _searchCtrl.clear(),
                            )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                    ),
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.inputFocusedBorder),
            SizedBox(height: 12),
            Text(
              'Loading options...',
              style: TextStyle(color: AppColors.textHint, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 36,
              color: AppColors.error,
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _loadOptions,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredOptions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 36, color: AppColors.textHint),
            SizedBox(height: 10),
            Text(
              'No results found',
              style: TextStyle(color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: _filteredOptions.length,
      separatorBuilder: (_, __) => widget.showSeparators
          ? const Divider(height: 1)
          : const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final option = _filteredOptions[index];
        final label = widget.labelOf(option);
        final isSelected =
            widget.selectedLabel != null &&
            widget.selectedLabel!.toLowerCase() == label.toLowerCase();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.inputFocusedBorder.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: isSelected
                  ? AppColors.inputFocusedBorder
                  : AppColors.inputBackground,
              child: Text(
                label.isNotEmpty ? label[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.inputIconText,
                ),
              ),
            ),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: AppColors.inputIconText,
              ),
            ),
            trailing: isSelected
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.inputFocusedBorder,
                  )
                : null,
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context, option);
            },
          ),
        );
      },
    );
  }
}
