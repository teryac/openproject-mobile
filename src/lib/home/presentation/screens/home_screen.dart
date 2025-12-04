import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/util/focus.dart';
import 'package:open_project/core/widgets/empty_state_widget.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';
import 'package:open_project/home/presentation/widgets/home_search_bar.dart';
import 'package:open_project/home/presentation/widgets/projects_list_error_widget.dart';
import 'package:open_project/home/presentation/widgets/projects_list_widget.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/sliver_util.dart';
import 'package:open_project/home/presentation/cubits/projects_list_expansion_cubit.dart';
import 'package:open_project/home/presentation/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.paddingOf(context);
    const expansionAnimationDuration = Duration(milliseconds: 700);
    const expansionAnimationCurve = Curves.easeInOut;

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeProjectsListCubit,
            PaginatedAsyncValue<PaginatedProjects, NetworkFailure>>(
          listener: (context, state) {
            // If requesting more items failed, show an error snackbar.
            // This isn't shown if the request failed on the first requested
            // page, because the error state is clearly visible on the UI as
            // a retry button (Check `widgets/projects_list_widget.dart`)
            if (state.hasPageError) {
              showErrorSnackBar(context, state.error!.errorMessage);
            }
          },
        ),
      ],
      child: Portal(
        child: Scaffold(
          body: GestureDetector(
            onTap: unFocusTextField,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverSafeArea(
                  sliver: SliverPadding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: HomeHeader(safeArea: safeArea),
                        ),
                        const SliverIndent(height: 24),
                        const SliverToBoxAdapter(
                          child: HomeSearchBar(),
                        ),
                        const SliverIndent(height: 20),
                        BlocBuilder<
                            HomeProjectsListCubit,
                            PaginatedAsyncValue<PaginatedProjects,
                                NetworkFailure>>(
                          builder: (context, state) {
                            final cache = context.read<CacheCubit>().state;
                            final isAuthenticated =
                                cache[AppConstants.apiTokenCacheKey] != null;

                            // Checking if the user is authenticated makes the error widget
                            // visible only once -for both public and private projects-.
                            // On the other hand, when the user is not authenticated, a widget
                            // for entering an API token is shown at the private projects section,
                            // and that last widget should be shown regardless of whther the public
                            // projects loaded, are still loading, or failed to load.
                            if (isAuthenticated) {
                              final safeArea = MediaQuery.paddingOf(context);
                              const approximateHeightOfScreenHeader = 300;
                              final remainingScreenHeight =
                                  MediaQuery.sizeOf(context).height -
                                      safeArea.top -
                                      safeArea.bottom -
                                      approximateHeightOfScreenHeader;
                              if (state.data?.projects.isEmpty ?? false) {
                                return SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: remainingScreenHeight,
                                    child: Center(
                                      child: EmptyStateWidget(
                                          message: 'No projects found'),
                                    ),
                                  ),
                                );
                              }

                              if (state.isError) {
                                return SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: remainingScreenHeight,
                                    child: Center(
                                      child: ProjectsListErrorWidget(
                                        errorMessage: state.error!.errorMessage,
                                        retryTrigger: () {
                                          context
                                              .read<HomeProjectsListCubit>()
                                              .getProjects(
                                                context: context,
                                                projectsFilters:
                                                    const ProjectsFilters
                                                        .noFilters(),
                                              );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }

                            return SliverMainAxisGroup(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Public projects",
                                        style: AppTextStyles.large.copyWith(
                                            color: AppColors.primaryText),
                                      ),
                                      BlocBuilder<ProjectsListExpansionCubit,
                                          bool>(
                                        builder: (context, listExpansionState) {
                                          return InkWell(
                                            splashColor: AppColors.primaryText
                                                .withAlpha(38),
                                            highlightColor: Colors
                                                .transparent, // Removes gray overlay
                                            borderRadius:
                                                BorderRadius.circular(360),
                                            onTap: () {
                                              context
                                                  .read<
                                                      ProjectsListExpansionCubit>()
                                                  .toggleExpansion();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AnimatedRotation(
                                                duration:
                                                    expansionAnimationDuration,
                                                curve: expansionAnimationCurve,
                                                turns: listExpansionState
                                                    ? 0
                                                    : 0.5,
                                                child: SvgPicture.asset(
                                                  AppIcons.arrowUp,
                                                  width: 24.0,
                                                  height: 24.0,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                    AppColors.iconPrimary,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SliverIndent(height: 16),
                                const ProjectsListWidget(
                                  expansionAnimationDuration:
                                      expansionAnimationDuration,
                                  expansionAnimationCurve:
                                      expansionAnimationCurve,
                                  public: true,
                                ),
                                const SliverIndent(height: 24.0),
                                SliverToBoxAdapter(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Private projects",
                                        style: AppTextStyles.large.copyWith(
                                            color: AppColors.primaryText),
                                      ),
                                    ],
                                  ),
                                ),
                                const SliverIndent(height: 20.0),
                                const ProjectsListWidget(
                                  expansionAnimationDuration:
                                      expansionAnimationDuration,
                                  expansionAnimationCurve:
                                      expansionAnimationCurve,
                                  public: false,
                                ),
                                const SliverIndent(height: 12),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
