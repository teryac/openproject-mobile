import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/models/user.dart';
import 'package:open_project/auth/presentation/cubits/auth_get_user_cubit.dart';
import 'package:open_project/auth/presentation/widgets/token_input_screen/api_token_instructions_dialog.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_image.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/blurred_overlays.dart';

class TokenInputScreen extends StatelessWidget {
  const TokenInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding:
              EdgeInsets.only(bottom: 32.0, left: 20.0, right: 20.0, top: 20.0),
          child: AppAssetImage(
            assetPath: AppImages.overview,
            height: 217.0,
            fit: BoxFit.fitHeight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'Step into your workspace',
                textAlign: TextAlign.center,
                style: AppTextStyles.extraLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your API token to edit tasks, access private projects, and collaborate with your team.',
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        // This is a default 72 pixels indent
        const SizedBox(height: 72),
        // This is an additional option to fill the screen if screen
        // is large enough
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your API token',
                style: AppTextStyles.large.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'To get your API token, go to account settings on the website. For help, see the guide below.',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
              const SizedBox(height: 24),
              AppTextFormField(
                hint: 'API Token',
                controller: context.read<AuthController>().tokenTextController,
                obscure: true,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: AppTextButton(
                  text: 'How to get API token?',
                  onPressed: () {
                    showBlurredDialog(
                      context: context,
                      builder: (_) {
                        return const ApiTokenInstructionsDialog();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthGetUserCubit, AsyncValue<User, NetworkFailure>>(
                builder: (context, state) {
                  return AppButton(
                    text: 'Access Workspace',
                    loading: state.isLoading,
                    onPressed: context.read<AuthController>().getUserData,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
