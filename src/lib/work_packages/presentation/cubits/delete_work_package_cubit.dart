import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/cache_extension.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/work_packages/data/work_packages_repo.dart';

class DeleteWorkPackageCubit
    // The map links the work package id with the deletion async state
    // In the UI, we use the work package id as a key to find any matching
    // states in this map, if there is one, we show loading, data, or error
    // based on the value
    extends Cubit<Map<int, AsyncValue<void, NetworkFailure>>> {
  final WorkPackagesRepo _workPackagesRepo;
  DeleteWorkPackageCubit({
    required WorkPackagesRepo workPackagesRepo,
  })  : _workPackagesRepo = workPackagesRepo,
        super({});

  void deleteWorkPackage({
    required BuildContext context,
    required int workPackageId,
  }) async {
    // If work package state exists and is currently loading, skip
    if (state[workPackageId]?.isLoading ?? false) return;

    emit(_populateMap(
      items: state,
      newItem: MapEntry(
        workPackageId,
        AsyncValue.loading(),
      ),
    ));

    final serverUrl = context.getServerUrl();

    if (serverUrl == null) {
      return;
    }

    final apiToken = context.getApiToken();

    final result = await _workPackagesRepo.deleteWorkPackage(
      serverUrl: serverUrl,
      apiToken: apiToken,
      id: workPackageId,
    );

    if (result.isData) {
      emit(_populateMap(
        items: state,
        newItem: MapEntry(
          workPackageId,
          AsyncValue.data(data: null),
        ),
      ));
    } else {
      emit(_populateMap(
        items: state,
        newItem: MapEntry(
          workPackageId,
          AsyncValue.error(error: result.error!),
        ),
      ));
    }
  }

  Map<int, AsyncValue<void, NetworkFailure>> _populateMap({
    required Map<int, AsyncValue<void, NetworkFailure>> items,
    required MapEntry<int, AsyncValue<void, NetworkFailure>> newItem,
  }) {
    final map = <int, AsyncValue<void, NetworkFailure>>{}..addAll(items);
    map.addEntries([newItem]);

    return map;
  }
}
