import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/avatar_widget.dart';
import 'package:open_project/home/application/home_controller.dart';

class ServerDialog extends StatelessWidget {
  final EdgeInsets safeArea;
  const ServerDialog({super.key, required this.safeArea});

  @override
  Widget build(BuildContext context) {
    final cacheData = context.read<CacheCubit>().state;

    // If a user hasn't provided an API token, they are not
    // authenitcated
    final isAuthenticated = cacheData[AppConstants.apiTokenCacheKey] != null;
    final serverUrl = cacheData[AppConstants.serverUrlCacheKey]!;
    final userId = int.tryParse(
      cacheData[AppConstants.userIdCacheKey] ?? 'null',
    );
    final userName = cacheData[AppConstants.userNameCacheKey];

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 12.0,
        bottom: safeArea.bottom >= 12 ? 0 : 12,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.handle,
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.blue100,
                  shape: BoxShape.circle,
                ),
                child: AvatarWidget.noBorder(
                  userData: (userId != null && userName != null)
                      ? (id: userId, fullName: userName)
                      : null,
                  svgAssetFallback: AppIcons.link,
                  fallbackIconSize: 20,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isAuthenticated ? userName! : serverUrl,
                      style: isAuthenticated
                          ? AppTextStyles.medium.copyWith(
                              color: AppColors.primaryText,
                            )
                          : AppTextStyles.extraSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                            ),
                    ),
                    if (isAuthenticated) ...[
                      SizedBox(height: 4.0),
                      Text(
                        serverUrl,
                        style: AppTextStyles.extraSmall.copyWith(
                          color: AppColors.descriptiveText,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(width: 22.0),
              if (!isAuthenticated)
                AppButton.outlined(
                  text: 'Sign in',
                  onPressed: () {
                    Navigator.pop(context);
                    context.pushNamed(AppRoutes.updateApiToken.name);
                  },
                  wrapContent: true,
                  small: true,
                ),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Change server',
            onPressed: () {
              context.read<HomeController>().logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
