import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_image.dart';

class PrivateProjectsForbiddenWidget extends StatelessWidget {
  const PrivateProjectsForbiddenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppAssetImage(
          assetPath: AppImages.team,
        ),
        const SizedBox(height: 20),
        Text(
          'To be able to see private projects, collaborate with your colleagues after singing in by entering your API token.',
          textAlign: TextAlign.center,
          style: AppTextStyles.extraSmall.copyWith(
            color: AppColors.descriptiveText,
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          text: 'Sign in',
          wrapContent: true,
          small: true,
          prefixIcon: SvgPicture.asset(
            AppIcons.login,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              AppColors.buttonText,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            context.pushNamed(AppRoutes.updateApiToken.name);
          },
        ),
      ],
    );
  }
}
