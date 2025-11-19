import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/date_format.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/work_packages/models/work_package.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_filters_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_types_data_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_popup_menu.dart';

class WorkPackageTile extends StatelessWidget {
  final WorkPackage workPackage;
  final int projectId;
  const WorkPackageTile({
    super.key,
    required this.workPackage,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu(
      menu: (toggleMenu) {
        return WorkPackagesPopupMenu(
          toggleMenu: toggleMenu,
          editWorkPackageHandler: () async {
            final result = await context.pushNamed<bool>(
              AppRoutes.addWorkPackage.name,
              pathParameters: {
                'work_package_id': workPackage.id.toString(),
              },
              queryParameters: {
                'edit_mode': 'true',
                'project_id': projectId.toString(),
              },
            );

            if (result != null && result && context.mounted) {
              context.read<WorkPackagesListCubit>().getWorkPackages(
                    context: context,
                    projectId: projectId,
                    workPackagesFilters:
                        // This avoids changing the filters
                        context.read<WorkPackagesFiltersCubit>().state,
                    // Reset to avoid requesting next page instead of first page
                    resetPages: true,
                  );
            }
          },
          deleteWorkPackageHandler: () {},
        );
      },
      child: (toggleMenu) {
        return InkWell(
          splashColor: AppColors.primaryText.withAlpha(38),
          highlightColor: Colors.transparent, // Removes gray overlay
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final encodedDataModel = jsonEncode(workPackage.toJson());
            final encodedDependenciesModel = jsonEncode(context
                .read<WorkPackageDependenciesDataCubit>()
                .state
                .data!
                .toJson());

            final result = await context.pushNamed<bool>(
              AppRoutes.viewWorkPackage.name,
              queryParameters: {
                'data': encodedDataModel,
                'dependencies': encodedDependenciesModel,
                'project_id':
                    GoRouter.of(context).state.pathParameters['project_id']!,
              },
            );

            if (result != null && result && context.mounted) {
              final projectId = int.parse(
                GoRouterState.of(context).pathParameters['project_id']!,
              );

              context.read<WorkPackagesListCubit>().getWorkPackages(
                    context: context,
                    projectId: projectId,
                    workPackagesFilters:
                        // This avoids changing the filters
                        context.read<WorkPackagesFiltersCubit>().state,
                    // Reset to avoid requesting next page instead of first page
                    resetPages: true,
                  );
            }
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
                        workPackage.subject,
                        style: AppTextStyles.medium.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Builder(
                          builder: (context) {
                            final statuses = context
                                .read<WorkPackageDependenciesDataCubit>()
                                .state
                                .data!
                                .workPackageStatuses;

                            final status = statuses.firstWhere(
                              (element) => element.id == workPackage.statusId,
                            );

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: HexColor(status.colorHex).withAlpha(38),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                status.name,
                                style: AppTextStyles.extraSmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: HexColor(status.colorHex),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (workPackage.dueDate != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.clock),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final deadlineText =
                                parseDeadline(workPackage.dueDate!);
                            return Text(
                              '${deadlineText.prefix} ${deadlineText.value}',
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
                if (workPackage.assignee != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.profile),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Task assigned to ${workPackage.assignee}.',
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
