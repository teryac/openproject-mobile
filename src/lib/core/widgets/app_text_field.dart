import 'dart:async';

import '../styles/colors.dart';
import '../styles/text_styles.dart';
import 'package:flutter/material.dart';

enum _TextFieldStyle {
  normal,
  outlined,
  filled,
}

class AppTextFormField extends StatefulWidget {
  /// You can update with your own state management if you
  /// do not prefer to use the controller
  final String? initialValue;
  final TextEditingController? controller;
  final String hint;
  final bool obscure;
  final Widget? prefixIcon;
  final void Function()? onPrefixIconPressed;
  final Widget? suffixIcon;
  final void Function()? onSuffixIconPressed;
  final TextInputAction textInputAction;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final bool readOnly;
  final bool autofocus;
  final String? errorText;
  final bool disableLabel;
  final int? maxLines;
  final void Function()? onTap;
  final bool unFocusOnTapOutside;
  final TextStyle? textStyle;
  // Required callback for reactive search logic
  final void Function(String value)? onDebounceSubmitted;
  // Optional debounce duration (default to 500ms)
  final Duration debounceDuration;
  final _TextFieldStyle _style;
  final AutovalidateMode autovalidateMode;

  const AppTextFormField({
    this.initialValue,
    super.key,
    this.controller,
    required this.hint,
    this.validator,
    this.obscure = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onFieldSubmitted,
    this.keyboardType,
    this.focusNode,
    this.contentPadding,
    this.readOnly = false,
    this.autofocus = false,
    this.errorText,
    this.prefixIcon,
    this.onPrefixIconPressed,
    this.disableLabel = false,
    this.maxLines = 1,
    this.onTap,
    this.unFocusOnTapOutside = false,
    this.textStyle,
    this.onDebounceSubmitted,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  })  : borderRadius = null,
        _style = _TextFieldStyle.normal;

  const AppTextFormField.outlineBorder({
    this.initialValue,
    super.key,
    this.controller,
    required this.hint,
    this.validator,
    this.obscure = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onFieldSubmitted,
    this.keyboardType,
    this.focusNode,
    this.contentPadding,
    this.borderRadius,
    this.readOnly = false,
    this.autofocus = false,
    this.errorText,
    this.prefixIcon,
    this.onPrefixIconPressed,
    this.disableLabel = false,
    this.maxLines = 1,
    this.onTap,
    this.unFocusOnTapOutside = false,
    this.textStyle,
    this.onDebounceSubmitted,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : _style = _TextFieldStyle.outlined;

  const AppTextFormField.filled({
    this.initialValue,
    super.key,
    this.controller,
    required this.hint,
    this.validator,
    this.obscure = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onFieldSubmitted,
    this.keyboardType,
    this.focusNode,
    this.contentPadding,
    this.borderRadius,
    this.readOnly = false,
    this.autofocus = false,
    this.errorText,
    this.prefixIcon,
    this.onPrefixIconPressed,
    this.disableLabel = false,
    this.maxLines = 1,
    this.onTap,
    this.unFocusOnTapOutside = false,
    this.textStyle,
    this.onDebounceSubmitted,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : _style = _TextFieldStyle.filled;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool get _filled => widget._style == _TextFieldStyle.filled;

  Timer? _debounceTimer;

  void _triggerDebounce(String value) {
    // 1. Cancel the previous timer if active (user is still typing)
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // 2. Start a new timer
    _debounceTimer = Timer(widget.debounceDuration, () {
      // 3. This runs after the delay, triggering the onDebounceSubmitted callback
      widget.onDebounceSubmitted?.call(value);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: (event) {
        widget.onTap?.call();
      },
      onTapOutside: (event) {
        if (!widget.unFocusOnTapOutside) return;

        // ------------------------------------------------------------------
        // 🔒 FIX: Manually check if the tap was actually inside the bounds.
        // This prevents the Android "flicker" where tapping the active
        // text field triggers a false-positive 'onTapOutside'.
        // ------------------------------------------------------------------
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final localOffset = renderBox.globalToLocal(event.position);
          if (renderBox.paintBounds.contains(localOffset)) {
            // The tap was actually INSIDE this widget.
            // Ignore the event and do not unfocus.
            return;
          }
        }

        // If we passed the check, it was truly outside. Unfocus.
        if (widget.focusNode != null) {
          widget.focusNode?.unfocus();
          return;
        }

        FocusScope.of(context).unfocus();
      },
      child: TextFormField(
        initialValue: widget.initialValue,
        controller: widget.controller,
        validator: widget.validator,
        onChanged: (value) {
          widget.onChanged?.call(value);

          // Used for reactive triggers
          if (widget.onDebounceSubmitted != null) {
            _triggerDebounce(value);
          }
        },
        // onTap: widget.onTap,
        style: widget.textStyle ??
            (_filled
                ? AppTextStyles.small.copyWith(
                    color: AppColors.primaryText,
                  )
                : AppTextStyles.medium.copyWith(
                    color: AppColors.primaryText,
                  )),
        focusNode: widget.focusNode,
        obscureText: widget.obscure,
        maxLines: widget.maxLines,
        enabled: !widget.readOnly,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        autovalidateMode: widget.autovalidateMode,
        keyboardType: widget.keyboardType,
        cursorColor: AppColors.primaryText,
        decoration: InputDecoration(
          contentPadding: widget.contentPadding,
          labelText: (_filled || widget.disableLabel) ? null : widget.hint,
          labelStyle: AppTextStyles.medium.copyWith(
            color: AppColors.descriptiveText,
            fontWeight: FontWeight.w400,
          ),
          hintText: (_filled || widget.disableLabel) ? widget.hint : null,
          hintStyle: _filled
              ? AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                )
              : AppTextStyles.medium.copyWith(
                  color: AppColors.descriptiveText,
                  fontWeight: FontWeight.w400,
                ),
          errorText: widget.errorText,
          errorStyle: AppTextStyles.extraSmall.copyWith(
            color: AppColors.red,
          ),
          filled: _filled,
          fillColor: _filled ? AppColors.searchBarBackground : null,
          enabledBorder: _filled
              ? OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 360),
                  borderSide: BorderSide.none,
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.border),
                ),
          focusedBorder: _filled
              ? OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 360),
                  borderSide: BorderSide.none,
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: AppColors.primaryText,
                  ),
                ),
          errorBorder: _filled
              ? OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 360),
                  borderSide: BorderSide(
                    color: AppColors.red.withAlpha(150),
                    width: 1,
                  ),
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.red),
                ),
          focusedErrorBorder: _filled
              ? OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 360),
                  borderSide: const BorderSide(color: AppColors.red, width: 2),
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: AppColors.red),
                ),
          suffixIcon: widget.suffixIcon == null
              ? null
              : ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  child: GestureDetector(
                    onTap: widget.onSuffixIconPressed,
                    child: widget.suffixIcon,
                  ),
                ),
          prefixIconConstraints:
              const BoxConstraints(minHeight: 0, minWidth: 0),
          suffixIconConstraints:
              const BoxConstraints(minHeight: 0, minWidth: 0),
          prefixIcon: widget.prefixIcon == null
              ? null
              : GestureDetector(
                  onTap: widget.onPrefixIconPressed,
                  child: widget.prefixIcon,
                ),
        ),
      ),
    );
  }
}
