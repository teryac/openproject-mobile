import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/home/widgets/members_list.dart';

class ProjectTile extends StatelessWidget {
  const ProjectTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.projectBackground,
            border: Border.all(color: AppColors.border, width: 1.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Secrum project",
                        style: AppTextStyles.medium
                            .copyWith(color: AppColors.primaryText),
                      ),
                      //Container
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFF2EAC5D).withAlpha(38),
                            borderRadius: BorderRadius.circular(360)),
                        child: Text(
                          "On track",
                          // I Want a style text is Small.
                          style: AppTextStyles.extraSmall.copyWith(
                            color: const Color(0xFF2EAC5D),
                            fontWeight: FontWeight.w500,
                          ),
                        ), /*
                        badgeAnimation: const badges.BadgeAnimation.fade(
                          animationDuration: Duration(seconds: 4),
                          loopAnimation: false,
                        ),
                        badgeStyle: badges.BadgeStyle(
                          const Color(0xFF2EAC5D).withAlpha(38),
                          shape: badges.BadgeShape.square,
                          badgeColor: const Color(0xFF2EAC5D).withAlpha(38),
                          borderRadius: BorderRadius.circular(20.0),
                          elevation: 0,
                        ),*/
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        "Overdue by : ",
                        style: AppTextStyles.medium
                            .copyWith(color: AppColors.descriptiveText),
                      ),
                      Text(
                        "3 Months.",
                        style: AppTextStyles.medium
                            .copyWith(color: AppColors.primaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MembersList(
                        members: [
                          (
                            fullName: 'Majd Haj Hmidi',
                            color: Colors.deepOrange
                          ),
                          (fullName: 'Yaman Kalaji', color: Colors.deepPurple),
                          (fullName: 'Shaaban Shaheen', color: Colors.teal),
                          (fullName: 'Test Name', color: Colors.black),
                          (fullName: 'Test Name', color: Colors.red),
                          (fullName: 'Test Name', color: Colors.blue),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "See tasks",
                            style: AppTextStyles.small
                                .copyWith(color: AppColors.descriptiveText),
                          ),
                          SvgPicture.asset(
                            AppIcons.arrowRight,
                            width: 14.0,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.iconSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.projectBackground,
            border: Border.all(color: AppColors.border, width: 1.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Demo project",
                    style: AppTextStyles.medium
                        .copyWith(color: AppColors.primaryText),
                  ),
                  //Container
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF84616).withAlpha(15),
                        borderRadius: BorderRadius.circular(360)),
                    child: Text(
                      "Off track",
                      // I Want a style text is Small.
                      style: AppTextStyles.extraSmall.copyWith(
                        color: const Color(0xFFF84616),
                        fontWeight: FontWeight.w500,
                      ),
                    ), /*
                        badgeAnimation: const badges.BadgeAnimation.fade(
                          animationDuration: Duration(seconds: 4),
                          loopAnimation: false,
                        ),
                        badgeStyle: badges.BadgeStyle(
                          const Color(0xFF2EAC5D).withAlpha(38),
                          shape: badges.BadgeShape.square,
                          badgeColor: const Color(0xFF2EAC5D).withAlpha(38),
                          borderRadius: BorderRadius.circular(20.0),
                          elevation: 0,
                        ),*/
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Text(
                    "Overdue by : ",
                    style: AppTextStyles.medium
                        .copyWith(color: AppColors.descriptiveText),
                  ),
                  Text(
                    "2 weeks.",
                    style: AppTextStyles.medium
                        .copyWith(color: AppColors.primaryText),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MembersList(
                    members: [
                      (fullName: 'Majd Haj Hmidi', color: Colors.deepOrange),
                      (fullName: 'Yaman Kalaji', color: Colors.deepPurple),
                      (fullName: 'Shaaban Shaheen', color: Colors.teal),
                      (fullName: 'Test Name', color: Colors.black),
                      (fullName: 'Test Name', color: Colors.red),
                      (fullName: 'Test Name', color: Colors.blue),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "See tasks",
                        style: AppTextStyles.small
                            .copyWith(color: AppColors.descriptiveText),
                      ),
                      SvgPicture.asset(
                        AppIcons.arrowRight,
                        width: 14.0,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.iconSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
