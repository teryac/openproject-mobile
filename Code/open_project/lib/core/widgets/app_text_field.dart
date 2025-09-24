import '../styles/colors.dart';
import '../styles/text_styles.dart';
import 'package:flutter/material.dart';

enum _TextFieldStyle {
  normal,
  outlined,
  filled,
}

class AppTextFormField extends StatelessWidget {
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

  final _TextFieldStyle _style;

  const AppTextFormField({
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
  })  : borderRadius = null,
        _style = _TextFieldStyle.normal;

  const AppTextFormField.outlineBorder({
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
  }) : _style = _TextFieldStyle.outlined;

  const AppTextFormField.filled({
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
  }) : _style = _TextFieldStyle.filled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      style: _style == _TextFieldStyle.filled
          ? AppTextStyles.small.copyWith(
              color: AppColors.primaryText,
            )
          : AppTextStyles.medium.copyWith(
              color: AppColors.primaryText,
            ),
      focusNode: focusNode,
      obscureText: obscure,
      readOnly: readOnly,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hint,
        errorText: errorText,
        hintStyle: _style == _TextFieldStyle.filled
            ? AppTextStyles.small.copyWith(
                color: AppColors.descriptiveText,
              )
            : AppTextStyles.medium.copyWith(
                color: AppColors.descriptiveText,
                fontWeight: FontWeight.w400,
              ),
        filled: _style == _TextFieldStyle.filled,
        fillColor: _style == _TextFieldStyle.filled
            ? AppColors.searchBarBackground
            : null,
        enabledBorder: _style == _TextFieldStyle.filled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 360),
                borderSide: BorderSide.none,
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.border),
              ),
        focusedBorder: _style == _TextFieldStyle.filled
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
        errorBorder: _style == _TextFieldStyle.filled
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
        focusedErrorBorder: _style == _TextFieldStyle.filled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 360),
                borderSide: const BorderSide(color: AppColors.red, width: 2),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.red),
              ),
        suffixIcon: suffixIcon == null
            ? null
            : GestureDetector(
                onTap: onSuffixIconPressed,
                child: suffixIcon,
              ),
        prefixIcon: prefixIcon == null
            ? null
            : GestureDetector(
                onTap: onPrefixIconPressed,
                child: prefixIcon,
              ),
      ),
    );
  }
}
