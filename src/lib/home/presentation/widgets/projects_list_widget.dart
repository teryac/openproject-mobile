import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/util/pagination.dart';
import 'package:open_project/core/widgets/empty_state_widget.dart';
import 'package:open_project/core/widgets/load_next_page_button.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/data/home_repo.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';
import 'package:open_project/home/presentation/cubits/projects_list_expansion_cubit.dart';
import 'package:open_project/home/presentation/widgets/project_tile.dart';
import 'package:open_project/home/presentation/widgets/project_tile_loading_view.dart';
import 'package:open_project/home/presentation/widgets/projects_list_error_widget.dart';
import 'package:sliver_expandable/sliver_expandable.dart';

class ProjectsListWidget extends StatelessWidget {
  final PaginatedAsyncValue<PaginatedProjects, NetworkFailure>
      projectsAsyncValue;
  final bool public;
  final Duration expansionAnimationDuration;
  final Curve expansionAnimationCurve;
  const ProjectsListWidget({
    super.key,
    required this.projectsAsyncValue,
    required this.expansionAnimationDuration,
    required this.expansionAnimationCurve,
    this.public = true,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocBuilder<ProjectsListExpansionCubit, bool>(
          // Only build when the widget is for public projects because
          // private projects do not expand/collapse
          buildWhen: (_, __) => public,
          builder: (context, listExpansionState) {
            return AnimatedSliverExpandable(
              expanded: listExpansionState,
              duration: expansionAnimationDuration,
              curve: expansionAnimationCurve,
              sliver: AsyncValueBuilder(
                value: projectsAsyncValue,
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
                    child: ProjectsListErrorWidget(
                      errorMessage: error.errorMessage,
                      retryTrigger: () {
                        if (public) {
                          context.read<HomePublicProjectsCubit>().getProjects(
                                context: context,
                                projectsFilters:
                                    const ProjectsFilters.noFilters(),
                              );
                          return;
                        }

                        context.read<HomePrivateProjectsCubit>().getProjects(
                              context: context,
                              projectsFilters:
                                  const ProjectsFilters.noFilters(),
                            );
                      },
                    ),
                  );
                },
                data: (context, data) {
                  final separatedProjects = context
                      .read<HomeController>()
                      .separatePublicFromPrivateProjects(
                        projects: data.projects,
                        public: public,
                      );

                  if (separatedProjects.isEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      sliver: SliverToBoxAdapter(
                        child: EmptyStateWidget(message: 'No projects found'),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverList.separated(
                          itemCount: separatedProjects.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            final project = separatedProjects[index];

                            return ProjectTile(
                              projectId: project.id,
                              projectName: project.name,
                              status: project.status,
                              statusColor: context
                                  .read<HomeRepo>()
                                  .getProjectStatusColor(
                                    project.statusId,
                                  ),
                              updatedAt: project.updatedAt,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 16.0),
                        ),
                        // const SliverIndent(height: 16),
                        SliverToBoxAdapter(
                          child: Builder(
                            builder: (context) {
                              if (isLastPage(
                                total: data.total,
                                pageSize: data.pageSize,
                                currentPage: data.page,
                              )) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: LoadNextPageButton(
                                  loading: projectsAsyncValue.isLoadingPage,
                                  onTap: () {
                                    if (public) {
                                      context
                                          .read<HomePublicProjectsCubit>()
                                          .getProjects(
                                            context: context,
                                            projectsFilters:
                                                const ProjectsFilters
                                                    .noFilters(),
                                          );
                                      return;
                                    }
                                    context
                                        .read<HomePrivateProjectsCubit>()
                                        .getProjects(
                                          context: context,
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
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
