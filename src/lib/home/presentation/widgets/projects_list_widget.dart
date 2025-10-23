import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/dependency_injection.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/core/widgets/sliver_util.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';
import 'package:open_project/home/presentation/cubits/projects_list_expansion_cubit.dart';
import 'package:open_project/home/presentation/widgets/project_tile.dart';
import 'package:open_project/home/presentation/widgets/project_tile_loading_view.dart';
import 'package:sliver_expandable/sliver_expandable.dart';

class ProjectsListWidget extends StatelessWidget {
  final bool public;
  final Duration expansionAnimationDuration;
  final Curve expansionAnimationCurve;
  const ProjectsListWidget({
    super.key,
    required this.expansionAnimationDuration,
    required this.expansionAnimationCurve,
    this.public = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeProjectsListCubit,
        PaginatedAsyncValue<PaginatedProjects, NetworkFailure>>(
      builder: (context, projectsState) {
        return BlocBuilder<ProjectsListExpansionCubit, bool>(
          // Only build when the widget is for public projects because
          // private projects do not expand/collapse
          buildWhen: (_, __) => public,
          builder: (context, listExpansionState) {
            return AsyncValueBuilder(
              value: projectsState,
              loading: (context) {
                return SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList.separated(
                    itemCount: 2,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, __) => const ProjectTileLoadingView(),
                  ),
                );
              },
              error: (context, error) {
                return SliverToBoxAdapter(
                  child: AsyncRetryWidget(
                    message: error.errorMessage,
                    onPressed: () {
                      context.read<HomeProjectsListCubit>().getProjects(
                            projectsFilters: const ProjectsFilters.noFilters(),
                          );
                    },
                  ),
                );
              },
              data: (context, data) {
                return AnimatedSliverExpandable(
                  expanded: listExpansionState,
                  duration: expansionAnimationDuration,
                  curve: expansionAnimationCurve,
                  sliver: SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverList.separated(
                          itemCount: data.projects.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            final project = data.projects[index];

                            return ProjectTile(
                              projectName: project.name,
                              status: project.status,
                              // TODO: Fix - Missing status color
                              statusColor: '#F84616',
                              updatedAt: project.updatedAt,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 16.0),
                        ),
                        const SliverIndent(height: 16),
                        SliverToBoxAdapter(
                          child: Builder(
                            builder: (context) {
                              if (context.read<HomeController>().isLastPage(
                                    total: data.total,
                                    pageSize: data.pageSize,
                                    currentPage: data.page,
                                  )) {
                                return const SizedBox.shrink();
                              }

                              // If loading more items
                              if (projectsState.isLoadingPage) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Align(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: AppTextButton(
                                  text: 'Load more',
                                  onPressed: () {
                                    context
                                        .read<HomeProjectsListCubit>()
                                        .getProjects(
                                          projectsFilters:
                                              const ProjectsFilters.noFilters(),
                                        );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
