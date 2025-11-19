import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/avatar_widget.dart';
import 'package:open_project/home/application/home_controller.dart';

class ServerDialog extends StatelessWidget {
  const ServerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cacheData = context.read<CacheCubit>().state;

    final userId = int.tryParse(
      cacheData[AppConstants.userIdCacheKey] ?? 'null',
    );
    final userName = cacheData[AppConstants.userNameCacheKey];
    final userEmail = cacheData[AppConstants.userEmailCacheKey];

    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 24.0,
      ),
      color: AppColors.background,
      child: Row(
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
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? '',
                  style: AppTextStyles.medium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                if (userEmail != null) ...[
                  SizedBox(height: 4.0),
                  Text(
                    userEmail,
                    style: AppTextStyles.extraSmall.copyWith(
                      color: AppColors.descriptiveText,
                    ),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(width: 22.0),
          AppButton.caution(
            text: 'Log out',
            onPressed: () {
              context.read<HomeController>().logOut(context);
            },
            wrapContent: true,
            small: true,
          ),
        ],
      ),
    );
  }
}
