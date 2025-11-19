import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/avatar_widget.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/presentation/widgets/server_dialog.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cacheData = context.read<CacheCubit>().state;
    final firstName = cacheData[AppConstants.userFirstNameCacheKey] ??
        // Name is never null, but first name can be null
        cacheData[AppConstants.userNameCacheKey]?.split(' ').first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello ${firstName ?? ''}",
              style: AppTextStyles.large.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              "Welcome back",
              style: AppTextStyles.small
                  .copyWith(color: AppColors.descriptiveText),
            ),
          ],
        ),
        Material(
          color: AppColors.searchBarBackground,
          borderRadius: BorderRadius.circular(360),
          child: InkWell(
            borderRadius: BorderRadius.circular(360),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                shape: RoundedRectangleBorder(),
                builder: (_) {
                  return SizedBox(
                    width: double.infinity,
                    child: IntrinsicHeight(
                      child: SafeArea(
                        child: RepositoryProvider.value(
                          value: context.read<HomeController>(),
                          child: ServerDialog(),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.only(
                right: 8.0,
                left: 4.0,
                top: 4.0,
                bottom: 4.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
              ),
              child: Row(
                children: [
                  AvatarWidget.noBorder(
                    userData: (cacheData[AppConstants.userIdCacheKey] != null &&
                            cacheData[AppConstants.userNameCacheKey] != null)
                        ? (
                            id: int.parse(
                                cacheData[AppConstants.userIdCacheKey]!),
                            fullName: cacheData[AppConstants.userNameCacheKey]!,
                          )
                        : null,
                    radius: 18,
                  ),
                  const SizedBox(width: 8.0),
                  SvgPicture.asset(
                    AppIcons.arrowUp,
                    width: 16.0,
                    height: 16.0,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
