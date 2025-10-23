import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';
import 'package:open_project/home/presentation/widgets/projects_list_widget.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/sliver_util.dart';
import 'package:open_project/home/presentation/cubits/projects_list_expansion_cubit.dart';
import 'package:open_project/home/presentation/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return SearchResults();
    // return ServersDialog();
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
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverSafeArea(
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: HomeHeader(),
                    ),
                    const SliverIndent(height: 24),
                    SliverToBoxAdapter(
                      child: AppTextFormField.filled(
                        controller:
                            context.read<HomeController>().searchTextController,
                        hint: 'Search for Projects..',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          child: SvgPicture.asset(
                            AppIcons.search,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColors.iconSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverIndent(height: 20),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Public projects",
                            style: AppTextStyles.large
                                .copyWith(color: AppColors.primaryText),
                          ),
                          BlocBuilder<ProjectsListExpansionCubit, bool>(
                            builder: (context, listExpansionState) {
                              return InkWell(
                                splashColor:
                                    AppColors.primaryText.withAlpha(38),
                                highlightColor:
                                    Colors.transparent, // Removes gray overlay
                                borderRadius: BorderRadius.circular(360),
                                onTap: () {
                                  context
                                      .read<ProjectsListExpansionCubit>()
                                      .toggleExpansion();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnimatedRotation(
                                    duration: expansionAnimationDuration,
                                    curve: expansionAnimationCurve,
                                    turns: listExpansionState ? 0 : 0.5,
                                    child: SvgPicture.asset(
                                      AppIcons.arrowUp,
                                      width: 24.0,
                                      height: 24.0,
                                      colorFilter: const ColorFilter.mode(
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
                      expansionAnimationDuration: expansionAnimationDuration,
                      expansionAnimationCurve: expansionAnimationCurve,
                      public: true,
                    ),
                    const SliverIndent(height: 24.0),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Private projects",
                            style: AppTextStyles.large
                                .copyWith(color: AppColors.primaryText),
                          ),
                        ],
                      ),
                    ),
                    const SliverIndent(height: 20.0),
                    const ProjectsListWidget(
                      expansionAnimationDuration: expansionAnimationDuration,
                      expansionAnimationCurve: expansionAnimationCurve,
                      public: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
