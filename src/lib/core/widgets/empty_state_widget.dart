import 'package:flutter/material.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_image.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  const EmptyStateWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAssetImage(
          assetPath: AppImages.emptyStateIllustration,
        ),
        Text(
          message,
          style: AppTextStyles.medium.copyWith(
            color: AppColors.descriptiveText,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
