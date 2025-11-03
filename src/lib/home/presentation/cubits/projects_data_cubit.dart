import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/home/data/home_repo.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/models/project.dart';

/// This class is used for the projects list in the home screen
class HomeProjectsListCubit extends _ProjectsDataCubit {
  HomeProjectsListCubit(
      {required super.homeRepo, required BuildContext context}) {
    super.getProjects(
      context: context,
      projectsFilters: const ProjectsFilters.noFilters(),
    );
  }
}

/// This class is used for the projects search dialog
class SearchDialogProjectsCubit extends _ProjectsDataCubit {
  SearchDialogProjectsCubit({required super.homeRepo});
}

/// This is a private class that is wrapped with two different classes
/// to be used in the same scope but with two different injected instance
/// Since context.read<CubitExample> is the way to get the cubit instance,
/// it's not possible to differentiate two instances from each other
class _ProjectsDataCubit
    extends Cubit<PaginatedAsyncValue<PaginatedProjects, NetworkFailure>> {
  final HomeRepo _homeRepo;
  _ProjectsDataCubit({required HomeRepo homeRepo})
      : _homeRepo = homeRepo,
        // Default case is `initial` instead of `loading` because this
        // cubit is used in two instances, one for the home screen list,
        // and the other for the search dialog in home screen.
        super(PaginatedAsyncValue.initial());

  void getProjects({
    required BuildContext context,
    required ProjectsFilters projectsFilters,
    bool resetPages = false,
  }) async {
    if (state.isLoading) return;

    // If different filter applied, reset model first
    if (resetPages || (projectsFilters != state.data?.projectsFilters)) {
      emit(PaginatedAsyncValue.initial());
    }

    emit(PaginatedAsyncValue.loading(previous: state));

    final cacheData = context.read<CacheCubit>().state;

    // This is an extra safety gaurd
    if (cacheData[AppConstants.serverUrlCacheKey] == null) {
      // This means that the user is not authenticated
      context.goNamed(AppRoutes.auth.name);
      return;
    }

    final result = await _homeRepo.getProjects(
      serverUrl: cacheData[AppConstants.serverUrlCacheKey]!,
      apiToken: cacheData[AppConstants.apiTokenCacheKey],
      // If first page, `data?.page` is replaced with 0, then 1 is
      // added, making it the first page
      page: (state.data?.page ?? 0) + 1,
      projectsFilters: projectsFilters,
    );

    if (result.isData) {
      emit(
        PaginatedAsyncValue.data(
          data: result.data!,
          previous: state,
          combine: (oldData, newData) {
            final combinedProjects = <Project>[
              ...oldData.projects,
              ...newData.projects,
            ];

            return PaginatedProjects(
              total: newData.total,
              count: newData.count,
              pageSize: newData.pageSize,
              page: newData.page,
              projectsFilters: newData.projectsFilters,
              projects: combinedProjects,
            );
          },
        ),
      );
    } else {
      emit(PaginatedAsyncValue.error(
        error: result.error!,
        previous: state,
      ));
    }
  }

  /// This is used when the search dialog is closed
  void reset() {
    emit(PaginatedAsyncValue.initial());
  }
}
