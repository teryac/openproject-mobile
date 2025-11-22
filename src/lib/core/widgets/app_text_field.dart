import '../styles/colors.dart';
import '../styles/text_styles.dart';
import 'package:flutter/material.dart';

enum _TextFieldStyle {
  normal,
  outlined,
  filled,
}

class AppTextFormField extends StatelessWidget {
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

  final _TextFieldStyle _style;

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
  }) : _style = _TextFieldStyle.filled;

  bool get _filled => _style == _TextFieldStyle.filled;

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) {
        if (!unFocusOnTapOutside) return;

        // This will un-focus ONLY if the tap was outside this specific widget
        // AND the keyboard is currently looking at this specific widget.
        if (focusNode?.hasFocus ?? false) {
          focusNode?.unfocus();
        } else {
          // If you aren't using a custom focusNode, we use the primary focus
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        onTap: onTap,
        style: _filled
            ? AppTextStyles.small.copyWith(
                color: AppColors.primaryText,
              )
            : AppTextStyles.medium.copyWith(
                color: AppColors.primaryText,
              ),
        focusNode: focusNode,
        obscureText: obscure,
        maxLines: maxLines,
        readOnly: readOnly,
        autofocus: autofocus,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        cursorColor: AppColors.primaryText,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          labelText: (_filled || disableLabel) ? null : hint,
          labelStyle: AppTextStyles.medium.copyWith(
            color: AppColors.descriptiveText,
            fontWeight: FontWeight.w400,
          ),
          hintText: (_filled || disableLabel) ? hint : null,
          hintStyle: _filled
              ? AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                )
              : AppTextStyles.medium.copyWith(
                  color: AppColors.descriptiveText,
                  fontWeight: FontWeight.w400,
                ),
          errorText: errorText,
          errorStyle: AppTextStyles.extraSmall.copyWith(
            color: AppColors.red,
          ),
          filled: _filled,
          fillColor: _filled ? AppColors.searchBarBackground : null,
          enabledBorder: _filled
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 360),
                  borderSide: BorderSide.none,
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.border),
                ),
          focusedBorder: _filled
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 360),
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
                  borderRadius: BorderRadius.circular(borderRadius ?? 360),
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
                  borderRadius: BorderRadius.circular(borderRadius ?? 360),
                  borderSide: const BorderSide(color: AppColors.red, width: 2),
                )
              : const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: AppColors.red),
                ),
          suffixIcon: suffixIcon == null
              ? null
              : ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  child: GestureDetector(
                    onTap: onSuffixIconPressed,
                    child: suffixIcon,
                  ),
                ),
          prefixIconConstraints:
              const BoxConstraints(minHeight: 0, minWidth: 0),
          suffixIconConstraints:
              const BoxConstraints(minHeight: 0, minWidth: 0),
          prefixIcon: prefixIcon == null
              ? null
              : GestureDetector(
                  onTap: onPrefixIconPressed,
                  child: prefixIcon,
                ),
        ),
      ),
    );
  }
}
