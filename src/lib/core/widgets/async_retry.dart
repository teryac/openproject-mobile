import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/text_styles.dart';

class AsyncRetryWidget extends StatelessWidget {
  final String message;
  final void Function() onPressed;
  const AsyncRetryWidget({
    super.key,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.refresh,
            color: AppColors.primaryText,
            size: 26,
          ),
        ),
        Text(
          message,
          style: AppTextStyles.small.copyWith(color: AppColors.primaryText),
        ),
      ],
    );
  }
}
