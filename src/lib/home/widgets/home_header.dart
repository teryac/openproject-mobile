import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello Muhammad",
              style: AppTextStyles.large.copyWith(color: AppColors.primaryText),
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
        Container(
          padding: const EdgeInsets.only(
              right: 8.0, left: 4.0, top: 4.0, bottom: 4.0),
          decoration: BoxDecoration(
              color: AppColors.searchBarBackground,
              borderRadius: BorderRadius.circular(360.0)),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: AppColors.blue100, shape: BoxShape.circle),
                child: Center(
                  child: Text("MH",
                      style: AppTextStyles.small.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8.0),
              SvgPicture.asset(
                AppIcons.arrowUp,
                width: 16.0,
                height: 16.0,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
