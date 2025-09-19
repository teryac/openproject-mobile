import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_circular_progress_indicator.dart';

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
  final bool _outlined;
  final bool _caution;

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
  })  : _outlined = false,
        _caution = false;

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
  })  : _outlined = true,
        _caution = false;

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
  })  : _outlined = false,
        _caution = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: _outlined
          ? Theme.of(context).scaffoldBackgroundColor
          : _caution
              ? AppColors.redBackground
              : AppColors.button,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        splashColor: _caution
            ? AppColors.red.withAlpha(50)
            : AppColors.buttonText.withAlpha(50),
        highlightColor: Colors.transparent, // removes the gray overlay
        child: Builder(builder: (context) {
          final child = Container(
            padding: EdgeInsets.symmetric(horizontal: small ? 12 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: _outlined
                  ? Border.all(color: AppColors.button, width: 2)
                  : null,
            ),
            width: width,
            height: height ?? (small ? 36 : 52),
            child: Center(
              child: Builder(
                builder: (context) {
                  if (loading) {
                    return const AppCircularProgressIndicator(
                        color: AppColors.buttonText);
                  }
                  final textColor = _outlined
                      ? AppColors.button
                      : _caution
                          ? AppColors.red
                          : AppColors.buttonText;

                  final textWidget = Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textStyle ??
                        (small
                            ? AppTextStyles.extraSmall.copyWith(
                                fontWeight: FontWeight.w500, color: textColor)
                            : AppTextStyles.medium.copyWith(color: textColor)),
                    textScaler:
                        disableTextScaling ? const TextScaler.linear(1) : null,
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
