import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';
import 'package:open_project/core/widgets/sliver_util.dart';
import 'package:open_project/view_work_package/application/view_work_package_scroll_controller.dart';
// import 'package:open_project/core/widgets/bottom_tab_bar.dart';
// import 'package:open_project/view_work_package/presentation/cubits/view_work_package_scroll_cubit.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_details_overview.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_details_people.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_details_properties.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_details_schedule.dart';
import 'package:open_project/work_packages/models/work_package.dart';

class ViewWorkPackageScreen extends StatelessWidget {
  const ViewWorkPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);
    final scrollController = context.read<ViewWorkPackageScrollController>();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Builder(
                  builder: (context) {
                    final apiToken = context
                        .read<CacheCubit>()
                        .state[AppConstants.apiTokenCacheKey];

                    return CustomAppBar(
                      text: 'Details',
                      // Unauthenticated users can't edit work packages
                      trailingIcon: apiToken == null
                          ? null
                          : SvgPicture.asset(
                              AppIcons.edit,
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                AppColors.iconPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                      trailingIconAction: apiToken == null
                          ? null
                          : () async {
                              final workPackage = context.read<WorkPackage>();

                              final result = await context.pushNamed<bool>(
                                AppRoutes.addWorkPackage.name,
                                pathParameters: {
                                  'work_package_id': workPackage.id.toString(),
                                },
                                queryParameters: {
                                  'edit_mode': 'true',
                                  'project_id': GoRouter.of(context)
                                      .state
                                      .uri
                                      .queryParameters['project_id']!,
                                },
                              );

                              // When the `AddWorkPackageScreen` successfully updates a work
                              // package, it pops and sends a boolean with a value of `true`
                              // to this route, this route passes that value back to the
                              // Work Packages screen to trigger a reload in order to
                              // update the work packages list
                              if (result != null && result && context.mounted) {
                                context.pop<bool>(true);
                              }
                            },
                    );
                  },
                ),
              ),
              const SliverIndent(height: 24),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        key: scrollController.sectionKeys[0],
                        child: const WorkPackageDetailsOverview(),
                      ),
                    ),
                    const SliverIndent(height: 48),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        key: scrollController.sectionKeys[1],
                        child: const WorkPackageDetailsPeople(),
                      ),
                    ),
                    const SliverIndent(height: 48),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        key: scrollController.sectionKeys[2],
                        child: const WorkPackageDetailsSchedule(),
                      ),
                    ),
                    const SliverIndent(height: 48),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        key: scrollController.sectionKeys[3],
                        child: const WorkPackageDetailsProperties(),
                      ),
                    ),
                    SliverIndent(
                        height: safeArea.bottom // Safe Area
                            +
                            20 // Bottom padding
                        // + 76 // Tabbar height
                        ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: safeArea.bottom + 12,
          //   right: safeArea.right + 16,
          //   left: safeArea.left + 16,
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: BlocBuilder<ViewWorkPackageScrollCubit, int>(
          //       builder: (context, index) {
          //         return BottomTabBar(
          //           index: index,
          //           items: const [
          //             'Overview',
          //             'People',
          //             'Schedule',
          //             'Properties',
          //           ],
          //           onTap: (index) {
          //             // Since sections that are too close to the bottom
          //             // of the screen won't be detected when scrolling,
          //             // Clicking those sections on the tab bar won't
          //             // change the tab bar section since the cubit's
          //             // only updates when the current scroll position
          //             // matches the section coordinates (Check
          //             // view_work_package_scroll_controller.dart)
          //             context
          //                 .read<ViewWorkPackageScrollCubit>()
          //                 .updateIndex(index);
          //             scrollController.scrollToSection(context, index);
          //           },
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
