import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/date_format.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_popup_menu.dart';

class WorkPackageTile extends StatelessWidget {
  final String title;
  final DateTime? endDate;
  final String? assignee;
  final String status;
  final String statusColor;
  const WorkPackageTile({
    super.key,
    required this.title,
    this.endDate,
    this.assignee,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu(
      menu: (toggleMenu) {
        return WorkPackagesPopupMenu(toggleMenu: toggleMenu);
      },
      child: (toggleMenu) {
        return InkWell(
          splashColor: AppColors.primaryText.withAlpha(38),
          highlightColor: Colors.transparent, // Removes gray overlay
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            context.pushNamed(AppRoutes.viewWorkPackage.name);
          },
          onLongPress: () => toggleMenu(true),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        title,
                        style: AppTextStyles.medium.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor(statusColor).withAlpha(38),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyles.extraSmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: HexColor(statusColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (endDate != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.clock),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            return Text(
                              deadlineText(endDate!),
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.descriptiveText,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                if (assignee != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.profile),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Task assigned to $assignee.',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.descriptiveText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
