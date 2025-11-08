import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/cache_extension.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/work_packages/data/work_packages_repo.dart';
import 'package:open_project/work_packages/models/work_package_dependencies.dart';

class WorkPackageDependenciesDataCubit
    extends Cubit<AsyncValue<WorkPackageDependencies, NetworkFailure>> {
  final WorkPackagesRepo _workPackagesRepo;
  final BuildContext context;
  final int projectId;
  WorkPackageDependenciesDataCubit({
    required WorkPackagesRepo workPackagesRepo,
    required this.context,
    required this.projectId,
  })  : _workPackagesRepo = workPackagesRepo,
        super(AsyncValue.initial()) {
    getWorkPackageDependencies(
      context: context,
      projectId: projectId,
    );
  }

  // This requests: Statuses, Types & Priorities
  void getWorkPackageDependencies({
    required BuildContext context,
    required int projectId,
  }) async {
    if (state.isLoading) return;

    emit(AsyncValue.loading());

    final serverUrl = context.getServerUrl();

    if (serverUrl == null) {
      return;
    }

    final statusesRequest = _workPackagesRepo.getWorkPackageStatuses(
      serverUrl: serverUrl,
    );

    final typesRequest = _workPackagesRepo.getWorkPackageTypes(
      serverUrl: serverUrl,
      projectId: projectId,
    );

    final prioritiesRequest = _workPackagesRepo.getWorkPackagePriorities(
      serverUrl: serverUrl,
    );

    final results = await Future.wait<AsyncResult<dynamic, NetworkFailure>>([
      statusesRequest,
      typesRequest,
      prioritiesRequest,
    ]);

    if (results.any((result) => result.isError)) {
      final error = results.firstWhere((result) => result.error != null).error!;

      emit(AsyncValue.error(error: error));
    } else {
      emit(
        AsyncValue.data(
          data: WorkPackageDependencies(
            workPackageStatuses: results[0].data!,
            workPackageTypes: results[1].data!,
            workPackagePriorities: results[2].data!,
          ),
        ),
      );
    }
  }
}
