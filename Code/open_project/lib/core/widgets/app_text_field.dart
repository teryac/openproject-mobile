import '../styles/colors.dart';
import '../styles/text_styles.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final void Function()? onSuffixIconPressed;
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

  final bool _outlineBorder;

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
  })  : borderRadius = null,
        _outlineBorder = false;

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
  }) : _outlineBorder = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      style: AppTextStyles.medium.copyWith(color: AppColors.primaryText),
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
        hintStyle: AppTextStyles.medium.copyWith(
          color: AppColors.descriptiveText,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: _outlineBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 16),
                borderSide: const BorderSide(color: AppColors.border, width: 2),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.border),
              ),
        focusedBorder: _outlineBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 16),
                borderSide:
                    const BorderSide(color: AppColors.primaryText, width: 2),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: AppColors.primaryText,
                ),
              ),
        errorBorder: _outlineBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 16),
                borderSide: BorderSide(
                  color: AppColors.red.withAlpha(150),
                  width: 2,
                ),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.red),
              ),
        focusedErrorBorder: _outlineBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 16),
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
      ),
    );
  }
}
