// ignore_for_file: use_build_context_synchronously

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/cache_extension.dart';
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

  CancelableOperation? _currentOperation;

  void getProjects({
    required BuildContext context,
    required ProjectsFilters projectsFilters,
    bool resetPages = false,
  }) async {
    // If different filter applied, reset model first
    if (resetPages || (projectsFilters != state.data?.projectsFilters)) {
      emit(PaginatedAsyncValue.initial());
    }

    // Cancel the previous request
    await _currentOperation?.cancel();

    emit(PaginatedAsyncValue.loading(previous: state));

    final serverUrl = context.getServerUrl();
    final apiToken = context.getApiToken();

    if (serverUrl == null) {
      return;
    }

    _currentOperation = CancelableOperation.fromFuture(
      _homeRepo.getProjects(
        serverUrl: serverUrl,
        apiToken: apiToken,
        // If first page, `data?.page` is replaced with 0, then 1 is
        // added, making it the first page
        page: (state.data?.page ?? 0) + 1,
        projectsFilters: projectsFilters,
      ),
    );

    final AsyncResult<PaginatedProjects, NetworkFailure>? result =
        await _currentOperation!.valueOrCancellation();

    if (result == null) return;

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

  void cancelRunningRequest() {
    _currentOperation?.cancel();
  }

  void reset() {
    emit(PaginatedAsyncValue.initial());
  }
}
