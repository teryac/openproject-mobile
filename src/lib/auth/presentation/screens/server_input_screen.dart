import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/presentation/cubits/auth_ping_server_cubit.dart';
import 'package:open_project/auth/presentation/widgets/server_input_screen/server_globe_header.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class ServerInputScreen extends StatefulWidget {
  const ServerInputScreen({
    super.key,
  });

  @override
  State<ServerInputScreen> createState() => _ServerInputScreenState();
}

class _ServerInputScreenState extends State<ServerInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Once the server is successfully pinged, this widget
        // will start the connection success animation
        BlocBuilder<AuthPingServerCubit, AsyncValue<void, NetworkFailure>>(
          builder: (context, state) {
            return ServerGlobeHeader(
              hasConnectedToServer: state.isData,
            );
          },
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'Your projects, One link away',
                textAlign: TextAlign.center,
                style: AppTextStyles.extraLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the server URL to connect with your team’s workspace and access your ongoing projects.',
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
                'Enter the URL of your project host',
                style: AppTextStyles.large.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can copy the URL link of the website of your OpenProject from the browser, and paste it here.',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
              const SizedBox(height: 24),
              AppTextFormField(
                hint: 'URL Link',
                controller:
                    context.read<AuthController>().serverUrlTextController,
                disableLabel: true,
                contentPadding: const EdgeInsets.only(top: 18, bottom: 18),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    right: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.border,
                    ),
                    child: Text(
                      'https://',
                      style: AppTextStyles.small.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.highContrastCursor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthPingServerCubit,
                  AsyncValue<void, NetworkFailure>>(
                builder: (context, state) {
                  return AppButton(
                    text: 'Connect to Server',
                    loading: state.isLoading,
                    onPressed: () {
                      context.read<AuthController>().pingServer();
                    },
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
