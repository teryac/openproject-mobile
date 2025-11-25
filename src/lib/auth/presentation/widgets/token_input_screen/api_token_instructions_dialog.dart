import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_gallery_widget.dart';
import 'package:open_project/core/widgets/app_image.dart';

class ApiTokenInstructionsDialog extends StatelessWidget {
  const ApiTokenInstructionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "How to get API tokens?",
                    style: AppTextStyles.large
                        .copyWith(color: AppColors.primaryText),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      AppIcons.closeSquare,
                      width: 28.0,
                      height: 28.0,
                      colorFilter: const ColorFilter.mode(
                        AppColors.iconSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            AppGalleryWidget(
              itemCount: 3,
              borderRadius: BorderRadius.circular(16),
              itemBuilder: (index) {
                return AspectRatio(
                  aspectRatio: 1.423, // Based on aspect ratio of used images
                  child: AppAssetImage(
                    assetPath: AppImages.howToGetApiToken(index + 1),
                  ),
                );
              },
              secondaryItemIndentation: 12,
              secondaryItemBuilder: (index) {
                final instruction = AppConstants.getApiTokenInstructions(index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instruction.title,
                      style: AppTextStyles.medium.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      instruction.body,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.descriptiveText,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
