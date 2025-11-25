import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/date_format.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/blurred_overlays.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/work_packages/application/work_packages_controller.dart';
import 'package:open_project/work_packages/models/work_package.dart';
import 'package:open_project/work_packages/presentation/cubits/delete_work_package_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_dependencies_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/delete_work_package_dialog.dart';
import 'package:open_project/work_packages/presentation/widgets/work_package_tile/work_package_tile_animation_helper.dart';
import 'package:open_project/work_packages/presentation/widgets/work_packages_popup_menu.dart';
import 'package:shimmer/shimmer.dart';

class WorkPackageTile extends StatefulWidget {
  final WorkPackage workPackage;
  final int workPackagesLength;
  final int workPackageIndex;
  final int projectId;
  const WorkPackageTile({
    super.key,
    required this.workPackage,
    required this.projectId,
    required this.workPackagesLength,
    required this.workPackageIndex,
  });

  @override
  State<WorkPackageTile> createState() => _WorkPackageTileState();
}

class _WorkPackageTileState extends State<WorkPackageTile>
    with SingleTickerProviderStateMixin {
  late WorkPackageTileAnimationHelper _animationHelper;

  @override
  void initState() {
    super.initState();

    _animationHelper = WorkPackageTileAnimationHelper(vsync: this);
  }

  @override
  void dispose() {
    _animationHelper.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cache = context.read<CacheCubit>().state;
    final isAuthenticated = cache[AppConstants.apiTokenCacheKey] != null;

    return AppPopupMenu(
      // Currently, all menu functions (Edit & Delete work packages) are exlusive to
      // authenticated users, so it's pointless to enable the menu for others
      enabled: isAuthenticated,
      menu: (toggleMenu) {
        return WorkPackagesPopupMenu(
          toggleMenu: toggleMenu,
          editWorkPackageHandler: () async {
            final result = await context.pushNamed<bool>(
              AppRoutes.addWorkPackage.name,
              pathParameters: {
                'work_package_id': widget.workPackage.id.toString(),
              },
              queryParameters: {
                'edit_mode': 'true',
                'project_id': widget.projectId.toString(),
              },
            );

            if (result != null && result && context.mounted) {
              context.read<WorkPackagesController>().getWorkPackages(
                    // Reset to avoid requesting next page instead of first page
                    resetPages: true,
                  );
            }
          },
          deleteWorkPackageHandler: () {
            showBlurredDialog(
              context: context,
              builder: (_) {
                return DeleteWorkPackageDialog(
                  onConfirmed: () {
                    context.read<DeleteWorkPackageCubit>().deleteWorkPackage(
                          context: context,
                          workPackageId: widget.workPackage.id,
                        );
                  },
                );
              },
            );
          },
        );
      },
      child: (toggleMenu) {
        return BlocConsumer<DeleteWorkPackageCubit,
            Map<int, AsyncValue<void, NetworkFailure>>>(
          listenWhen: (_, state) {
            final deletionAsyncValue = state[widget.workPackage.id];
            return deletionAsyncValue != null;
          },
          listener: (context, state) {
            final deletionAsyncValue = state[widget.workPackage.id];

            if (deletionAsyncValue != null && deletionAsyncValue.isError) {
              showErrorSnackBar(
                context,
                deletionAsyncValue.error!.errorMessage,
              );
            }

            // If deleted successfully, start the animation
            if (deletionAsyncValue != null && deletionAsyncValue.isData) {
              _animationHelper.controller.forward();
            }
          },
          buildWhen: (_, state) {
            final deletionAsyncValue = state[widget.workPackage.id];
            return deletionAsyncValue != null;
          },
          builder: (context, deleteCubitState) {
            final deletionAsyncValue = deleteCubitState[widget.workPackage.id];

            final isDeleted =
                deletionAsyncValue != null && deletionAsyncValue.isData;
            final isBeingDeleted =
                deletionAsyncValue != null && deletionAsyncValue.isLoading;

            EdgeInsets getItemPadding() {
              if (isDeleted) return EdgeInsets.zero;

              return EdgeInsets.only(
                top: widget.workPackageIndex == 0 ? 0 : 8,
                bottom: widget.workPackageIndex == widget.workPackagesLength - 1
                    ? 0
                    : 8,
              );
            }

            return Stack(
              children: [
                if (isBeingDeleted)
                  Positioned.fill(
                    child: Padding(
                      padding: getItemPadding(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Shimmer.fromColors(
                          baseColor: AppColors.red.withAlpha(0),
                          highlightColor: AppColors.red.withAlpha(64),
                          direction: ShimmerDirection.ltr,
                          period: const Duration(seconds: 2),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizeTransition(
                  sizeFactor: _animationHelper.sizeAnimation,
                  axisAlignment:
                      0.0, // 0.0 shrinks to the center, -1.0 shrinks upwards
                  child: FadeTransition(
                    opacity: _animationHelper.fadeAnimation,
                    child: Padding(
                      padding: getItemPadding(),
                      child: IgnorePointer(
                        ignoring: isBeingDeleted,
                        child: InkWell(
                          splashColor: AppColors.primaryText.withAlpha(38),
                          highlightColor:
                              Colors.transparent, // Removes gray overlay
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            final encodedDataModel =
                                jsonEncode(widget.workPackage.toJson());
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
                                'project_id': GoRouter.of(context)
                                    .state
                                    .pathParameters['project_id']!,
                              },
                            );

                            if (result != null && result && context.mounted) {
                              context
                                  .read<WorkPackagesController>()
                                  .getWorkPackages(
                                    // Reset to avoid requesting next page instead of first page
                                    resetPages: true,
                                  );
                            }
                          },
                          onLongPress: () => toggleMenu(true),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isBeingDeleted
                                    ? Color(0xFFFAA087)
                                    : AppColors.border,
                                width: 1.5,
                              ),
                              color: isBeingDeleted
                                  ? Color(0x80F2DBD5)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ImageFiltered(
                              enabled: isBeingDeleted,
                              imageFilter: ImageFilter.blur(
                                sigmaX: 6,
                                sigmaY: 6,
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
                                          widget.workPackage.subject,
                                          maxLines: 3,
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
                                                  .read<
                                                      WorkPackageDependenciesDataCubit>()
                                                  .state
                                                  .data!
                                                  .workPackageStatuses;

                                              final status =
                                                  statuses.firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    widget.workPackage.statusId,
                                              );

                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      HexColor(status.colorHex)
                                                          .withAlpha(38),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  status.name,
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles
                                                      .extraSmall
                                                      .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: HexColor(
                                                        status.colorHex),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.workPackage.dueDate != null) ...[
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.clock),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Builder(
                                            builder: (context) {
                                              final deadlineText =
                                                  parseDeadline(widget
                                                      .workPackage.dueDate!);
                                              return Text(
                                                '${deadlineText.prefix} ${deadlineText.value}',
                                                style: AppTextStyles.small
                                                    .copyWith(
                                                  color:
                                                      AppColors.descriptiveText,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (widget.workPackage.assignee != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.profile),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Task assigned to ${widget.workPackage.assignee!.name}.',
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
