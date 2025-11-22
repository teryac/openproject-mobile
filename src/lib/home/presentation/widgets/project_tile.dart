import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/date_format.dart';

class ProjectTile extends StatelessWidget {
  final int projectId;
  final String projectName;
  final String? status;
  final String statusColor;
  final DateTime updatedAt;
  const ProjectTile({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.status,
    required this.statusColor,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.projectBackground,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        splashColor: AppColors.primaryText.withAlpha(38),
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          context.pushNamed(
            AppRoutes.workPackages.name,
            pathParameters: {
              'project_id': projectId.toString(),
            },
            queryParameters: {
              'project_name': projectName,
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
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
                        projectName,
                        style: AppTextStyles.medium
                            .copyWith(color: AppColors.primaryText),
                      ),
                      if (status != null)
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: HexColor(statusColor).withAlpha(38),
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: Text(
                            status!,
                            style: AppTextStyles.extraSmall.copyWith(
                              color: HexColor(statusColor),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 175,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Last updated: ',
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.descriptiveText,
                              ),
                            ),
                            TextSpan(
                              text: getFormattedDate(updatedAt).toString(),
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Builder(
                      //   builder: (context) {
                      //     return const MembersList(
                      //       members: [
                      //         (
                      //           fullName: 'Majd Haj Hmidi',
                      //           color: Colors.deepOrange
                      //         ),
                      //         (
                      //           fullName: 'Yaman Kalaji',
                      //           color: Colors.deepPurple
                      //         ),
                      //         (fullName: 'Shaaban Shaheen', color: Colors.teal),
                      //         (fullName: 'Test Name', color: Colors.black),
                      //         (fullName: 'Test Name', color: Colors.red),
                      //         (fullName: 'Test Name', color: Colors.blue),
                      //       ],
                      //     );
                      //   },
                      // ),
                      const SizedBox.shrink(),
                      Row(
                        children: [
                          Text(
                            "See tasks",
                            style: AppTextStyles.small
                                .copyWith(color: AppColors.descriptiveText),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            AppIcons.arrowRight,
                            width: 14.0,
                            height: 14.0,
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
      ),
    );
  }
}
