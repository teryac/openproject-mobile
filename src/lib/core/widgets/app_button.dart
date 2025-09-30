import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_circular_progress_indicator.dart';

enum _ButtonStyle { normal, outlined, white, caution }

class AppButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool loading;
  final double? width;
  final Widget? prefixIcon;
  final double? height;
  final bool small;
  final bool disableTextScaling;
  final TextStyle? textStyle;
  final bool wrapContent;
  final bool blur;
  final _ButtonStyle _style;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefixIcon,
    this.loading = false,
    this.width,
    this.small = false,
    this.height,
    this.disableTextScaling = false,
    this.textStyle,
    this.wrapContent = false,
    this.blur = false,
  }) : _style = _ButtonStyle.normal;

  const AppButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefixIcon,
    this.loading = false,
    this.small = false,
    this.width,
    this.height,
    this.disableTextScaling = false,
    this.textStyle,
    this.wrapContent = false,
    this.blur = false,
  }) : _style = _ButtonStyle.outlined;

  const AppButton.caution({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefixIcon,
    this.loading = false,
    this.small = false,
    this.width,
    this.height,
    this.disableTextScaling = false,
    this.textStyle,
    this.wrapContent = false,
    this.blur = false,
  }) : _style = _ButtonStyle.caution;

  const AppButton.white({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefixIcon,
    this.loading = false,
    this.small = false,
    this.width,
    this.height,
    this.disableTextScaling = false,
    this.textStyle,
    this.wrapContent = false,
    this.blur = false,
  }) : _style = _ButtonStyle.white;

  Color _getBackgroundColor(BuildContext context) {
    switch (_style) {
      case _ButtonStyle.normal:
        return AppColors.button;
      case _ButtonStyle.outlined:
        return Theme.of(context).scaffoldBackgroundColor;
      case _ButtonStyle.caution:
        return AppColors.redBackground;
      case _ButtonStyle.white:
        return AppColors.background;
    }
  }

  Color _getForegroundColor() {
    switch (_style) {
      case _ButtonStyle.normal:
        return AppColors.buttonText;
      case _ButtonStyle.outlined:
        return AppColors.button;
      case _ButtonStyle.caution:
        return AppColors.red;
      case _ButtonStyle.white:
        return AppColors.primaryText;
    }
  }

  Border? _getBorder() {
    switch (_style) {
      case _ButtonStyle.outlined:
        return Border.all(color: AppColors.button, width: 2);
      case _ButtonStyle.white:
        return Border.all(color: AppColors.border, width: 1);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: _getBackgroundColor(context).withAlpha(
        // ignore: deprecated_member_use
        blur ? 190 : _getBackgroundColor(context).alpha,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur ? 4 : 0,
            sigmaY: blur ? 4 : 0,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            splashColor: _getForegroundColor().withAlpha(50),
            highlightColor: Colors.transparent, // removes the gray overlay
            child: Builder(builder: (context) {
              final child = Container(
                padding: EdgeInsets.symmetric(horizontal: small ? 12 : 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: _getBorder(),
                ),
                width: width,
                height: height ?? (small ? 36 : 52),
                child: Center(
                  child: Builder(
                    builder: (context) {
                      if (loading) {
                        return const AppCircularProgressIndicator(
                          color: AppColors.buttonText,
                        );
                      }

                      final textWidget = Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: textStyle ??
                            (small
                                ? AppTextStyles.extraSmall.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: _getForegroundColor(),
                                  )
                                : AppTextStyles.medium.copyWith(
                                    color: _getForegroundColor(),
                                  )),
                        textScaler: disableTextScaling
                            ? const TextScaler.linear(1)
                            : null,
                      );

                      if (prefixIcon != null) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            prefixIcon!,
                            const SizedBox(width: 12),
                            textWidget
                          ],
                        );
                      }

                      return textWidget;
                    },
                  ),
                ),
              );

              if (wrapContent) return IntrinsicWidth(child: child);
              return child;
            }),
          ),
        ),
      ),
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const AppTextButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          text,
          textScaler: const TextScaler.linear(1),
          style: AppTextStyles.extraSmall.copyWith(
            color: AppColors.highContrastCursor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
