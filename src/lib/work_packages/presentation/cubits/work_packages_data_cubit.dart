import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/cache_extension.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/work_packages/data/work_packages_repo.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/models/work_package.dart';
import 'package:open_project/work_packages/models/work_package_filters.dart';

/// This class is used for the work packages list in work
/// packages screen
class WorkPackagesListCubit extends _WorkPackagesDataCubit {
  final int projectId;
  final BuildContext context;
  WorkPackagesListCubit({
    required this.context,
    required super.workPackagesRepo,
    required this.projectId,
  }) {
    super.getWorkPackages(
      context: context,
      projectId: projectId,
      workPackagesFilters: const WorkPackagesFilters.noFilters(),
    );
  }
}

/// This class is used for the work packages search dialog
class SearchDialogWorkPackagesCubit extends _WorkPackagesDataCubit {
  SearchDialogWorkPackagesCubit({required super.workPackagesRepo});
}

/// This is a private class that is wrapped with two different classes
/// to be used in the same scope but with two different injected instances
/// Since context.read<CubitExample> is the way to get the cubit instance,
/// it's not possible to differentiate two instances from each other
class _WorkPackagesDataCubit
    extends Cubit<PaginatedAsyncValue<PaginatedWorkPackages, NetworkFailure>> {
  final WorkPackagesRepo _workPackagesRepo;
  _WorkPackagesDataCubit({
    required WorkPackagesRepo workPackagesRepo,
  })  : _workPackagesRepo = workPackagesRepo,
        super(PaginatedAsyncValue.initial());

  void getWorkPackages({
    required BuildContext context,
    required int projectId,
    required WorkPackagesFilters workPackagesFilters,
    bool resetPages = false,
  }) async {
    if (state.isLoading) return;

    // If different filter applied, reset model first
    if (resetPages ||
        (workPackagesFilters != state.data?.workPackagesFilters)) {
      emit(PaginatedAsyncValue.initial());
    }

    emit(PaginatedAsyncValue.loading(previous: state));

    final serverUrl = context.getServerUrl();
    final apiToken = context.getApiToken();

    if (serverUrl == null) {
      return;
    }

    final result = await _workPackagesRepo.getWorkPackages(
      serverUrl: serverUrl,
      apiToken: apiToken,
      // If first page, `data?.page` is replaced with 0, then 1 is
      // added, making it the first page
      projectId: projectId,
      page: (state.data?.page ?? 0) + 1,
      workPackagesFilters: workPackagesFilters,
    );

    if (result.isData) {
      emit(
        PaginatedAsyncValue.data(
          data: result.data!,
          previous: state,
          combine: (oldData, newData) {
            final combinedWorkPackages = <WorkPackage>[
              ...oldData.workPackages,
              ...newData.workPackages,
            ];

            return PaginatedWorkPackages(
              total: newData.total,
              count: newData.count,
              pageSize: newData.pageSize,
              page: newData.page,
              workPackagesFilters: newData.workPackagesFilters,
              workPackages: combinedWorkPackages,
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
