import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

/// A polished, animated text field with:
/// - Smooth border/background color transitions on focus
/// - A subtle scale "pop" when focused
/// - An animated icon swap for the password visibility toggle
/// - A shake animation when validation fails
///
/// Drop-in replacement for the original CustomTextfield — same
/// constructor signature, so no call sites need to change.
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
    this.labelText,
    this.autovalidateMode,
    this.maxLines = 1, // Added maxLines parameter here
    this.showPasswordStrength = false,
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
  final int maxLines; // Added maxLines variable

  /// Optional floating label. If null, [hintText] is used as a plain hint.
  final String? labelText;
  final AutovalidateMode? autovalidateMode;

  /// When true (and [isPasswordField] is true), shows a segmented strength
  /// bar + label ("Weak" / "Fair" / "Strong" / "Very Strong") below the field.
  final bool showPasswordStrength;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();

  bool _isFocused = false;
  late bool _obscureText;

  // Focus scale/border animation.
  late final AnimationController _focusController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 1.0,
    end: 1.01,
  ).animate(CurvedAnimation(parent: _focusController, curve: Curves.easeOut));

  // Shake animation, triggered on validation error.
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _shakeAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -6.0, end: 4.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 1),
  ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));

  String? _lastErrorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
    _focusNode.addListener(_handleFocusChange);
    if (widget.showPasswordStrength) {
      widget.controller.addListener(_handlePasswordChanged);
    }
  }

  void _handlePasswordChanged() {
    setState(() {});
  }

  /// Returns a score from 0 (empty) to 4 (very strong).
  int get _passwordStrengthScore {
    final text = widget.controller.text;
    if (text.isEmpty) return 0;

    int score = 0;
    if (text.length >= 8) score++;
    if (text.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(text) && RegExp(r'[a-z]').hasMatch(text)) {
      score++;
    }
    if (RegExp(r'[0-9]').hasMatch(text)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\[\];/~`+=]').hasMatch(text)) {
      score++;
    }

    // Clamp into 4 buckets: 1 = Weak, 2 = Fair, 3 = Good/Strong, 4 = Very Strong
    if (score <= 1) return 1;
    if (score == 2) return 2;
    if (score <= 4) return 3;
    return 4;
  }

  String get _passwordStrengthLabel {
    switch (_passwordStrengthScore) {
      case 0:
        return '';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Strong';
      default:
        return 'Very Strong';
    }
  }

  Color get _passwordStrengthColor {
    switch (_passwordStrengthScore) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return AppColors.inputFocusedBorder;
      case 4:
        return Colors.green;
      default:
        return AppColors.line;
    }
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
      // Re-validate on blur so the shake can react to a fresh error.
      _fieldKey.currentState?.validate();
    }
  }

  void _maybeShake(String? errorText) {
    if (errorText != null && errorText != _lastErrorText) {
      _shakeController.forward(from: 0);
    }
    _lastErrorText = errorText;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.showPasswordStrength) {
      widget.controller.removeListener(_handlePasswordChanged);
    }
    _focusNode.dispose();
    _focusController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Color get _borderColor =>
      _isFocused ? AppColors.inputFocusedBorder : Colors.transparent;

  Color get _iconColor =>
      _isFocused ? AppColors.inputFocusedBorder : AppColors.inputIconText;

  Widget _buildStrengthIndicator() {
    final score = _passwordStrengthScore;
    final color = _passwordStrengthColor;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: score == 0 ? 0 : 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password strength: $_passwordStrengthLabel',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(4, (index) {
                final filled = index < score;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
                    height: 4,
                    decoration: BoxDecoration(
                      color: filled ? color : AppColors.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = AnimatedBuilder(
      animation: Listenable.merge([_focusController, _shakeController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: TextFormField(
        key: _fieldKey,
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _obscureText,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,

        // Pass the maxLines down here. If it's a password field, force to 1 line to avoid UI bugs.
        maxLines: widget.isPasswordField ? 1 : widget.maxLines,

        autovalidateMode:
            widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
        validator: (value) {
          final error = widget.validator?.call(value);
          // Defer to avoid calling setState during build/validate.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _maybeShake(error);
          });
          return error;
        },
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.inputText,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: _isFocused
              ? AppColors.inputFocusedBackground
              : AppColors.inputBackground,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          labelText: widget.labelText,
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
            borderSide: BorderSide(color: _borderColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      widget.prefixIcon,
                      key: ValueKey(_isFocused),
                      color: _iconColor,
                    ),
                  ),
                )
              : null,
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  padding: const EdgeInsets.only(right: 10.0),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      key: ValueKey(_obscureText),
                      color: _iconColor,
                    ),
                  ),
                  onPressed: () {
                    setState(() => _obscureText = !_obscureText);
                  },
                )
              : widget.suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      widget.suffixIcon,
                      key: ValueKey(_isFocused),
                      color: _iconColor,
                    ),
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
      ),
    );

    if (!widget.isPasswordField || !widget.showPasswordStrength) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [field, _buildStrengthIndicator()],
    );
  }
}
