import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/widgets/app_image.dart';

import '../styles/colors.dart';
import '../styles/text_styles.dart';

enum _WidgetStyle { illustration, textOnly }

class AsyncRetryWidget extends StatelessWidget {
  final String message;
  final void Function() onPressed;

  final _WidgetStyle _widgetStyle;

  const AsyncRetryWidget({
    super.key,
    required this.message,
    required this.onPressed,
  }) : _widgetStyle = _WidgetStyle.illustration;

  const AsyncRetryWidget.textOnly({
    super.key,
    required this.message,
    required this.onPressed,
  }) : _widgetStyle = _WidgetStyle.textOnly;

  @override
  Widget build(BuildContext context) {
    if (_widgetStyle == _WidgetStyle.textOnly) {
      return Text.rich(
        textAlign: TextAlign.start,
        TextSpan(
          children: [
            TextSpan(
              text: '$message. ',
              style: AppTextStyles.small.copyWith(
                color: AppColors.descriptiveText,
              ),
            ),
            TextSpan(
              text: 'Retry',
              style: AppTextStyles.small.copyWith(
                color: AppColors.descriptiveText,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()..onTap = onPressed,
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAssetImage(
          assetPath: AppImages.errorStateIllustration,
        ),
        Text(
          message,
          style: AppTextStyles.medium.copyWith(
            color: AppColors.descriptiveText,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Text(
              'Retry',
              style: AppTextStyles.small.copyWith(
                color: AppColors.button,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
