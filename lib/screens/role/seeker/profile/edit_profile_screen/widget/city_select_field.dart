import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

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
  bool _hasText = false;

  late final AnimationController _arrowController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;

    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });

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

  Color _accentColor(bool isDark) {
    if (!widget.enabled)
      return isDark ? AppColors.darkIconDisabled : AppColors.iconDisabled;
    if (_isFocused || _isOpen)
      return isDark ? Colors.blueAccent : AppColors.inputFocusedBorder;
    if (_hasText) {
      return isDark ? Colors.white : AppColors.inputIconText;
    }
    return isDark ? AppColors.darkIconSecondary : AppColors.inputIconText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          color: widget.enabled
              ? (isDark ? Colors.white : Colors.black87)
              : (isDark ? AppColors.darkTextHint : Colors.grey),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.enabled
              ? ((_isFocused || _isOpen)
                    ? (isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.inputFocusedBackground)
                    : (isDark
                          ? AppColors.darkInputBackground
                          : AppColors.inputBackground))
              : (isDark
                    ? AppColors.darkCardBorder
                    : AppColors.inputDisabledBackground),
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
              color: isDark ? Colors.blueAccent : AppColors.inputFocusedBorder,
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
                key: ValueKey('$_isFocused-$_isOpen-$_hasText'),
                color: _accentColor(isDark),
              ),
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_arrowController),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _accentColor(isDark),
              ),
            ),
          ),
          hintText: widget.hintText.tr,
          hintStyle: TextStyle(
            color: widget.enabled
                ? (isDark ? AppColors.darkTextHint : AppColors.inputIconText)
                : (isDark
                      ? AppColors.darkIconDisabled
                      : AppColors.iconDisabled),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

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
        _errorMessage =
            'Failed to load list. Please try again.'.tr; // 🟢 Added .tr
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
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
                        widget.title.tr, // 🟢 Added .tr
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: theme
                              .textTheme
                              .bodyLarge
                              ?.color, // 🟢 Dynamic Text
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors
                                    .inputBackground, // 🟢 Dynamic Close BG
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : Colors.black87,
                        ),
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
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintText: widget.searchHint.tr, // 🟢 Added .tr
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.inputIconText,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark
                          ? AppColors.darkIconSecondary
                          : AppColors.inputIconText,
                    ),
                    suffixIcon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: _hasQuery
                          ? IconButton(
                              key: const ValueKey('clear'),
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors.black87,
                              ),
                              onPressed: () => _searchCtrl.clear(),
                            )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkInputBackground
                        : AppColors.inputBackground, // 🟢 Dynamic Input BG
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.blueAccent
                            : AppColors.inputFocusedBorder,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildBody(scrollController, isDark)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(ScrollController scrollController, bool isDark) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: isDark ? Colors.blueAccent : AppColors.inputFocusedBorder,
            ),
            const SizedBox(height: 12),
            Text(
              'Loading options...'.tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                fontSize: 13,
              ),
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
              label: Text('Retry'.tr), // 🟢 Added .tr
            ),
          ],
        ),
      );
    }

    if (_filteredOptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 36,
              color: isDark ? AppColors.darkIconSecondary : AppColors.textHint,
            ),
            const SizedBox(height: 10),
            Text(
              'No results found'.tr, // 🟢 Added .tr
              style: TextStyle(
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
              ),
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
          ? Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
            )
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
                ? (isDark
                      ? Colors.blueAccent.withValues(alpha: 0.15)
                      : AppColors.inputFocusedBorder.withValues(
                          alpha: 0.08,
                        )) // 🟢 Dynamic BG
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
                  ? (isDark ? Colors.blueAccent : AppColors.inputFocusedBorder)
                  : (isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.inputBackground),
              child: Text(
                label.isNotEmpty ? label[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.inputIconText),
                ),
              ),
            ),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.inputIconText)
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.inputIconText),
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle_rounded,
                    color: isDark
                        ? Colors.blueAccent
                        : AppColors.inputFocusedBorder,
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
