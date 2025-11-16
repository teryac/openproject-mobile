import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/data/add_work_package_repo.dart';
import 'package:open_project/add_work_package/models/work_package_mode.dart';
import 'package:open_project/add_work_package/models/work_package_payload.dart';
import 'package:open_project/core/util/cache_extension.dart';
import 'package:open_project/core/util/failure.dart';

class AddWorkPackageDataCubit extends Cubit<AsyncValue<void, NetworkFailure>> {
  final AddWorkPackageRepo _addWorkPackageRepo;
  AddWorkPackageDataCubit({
    required AddWorkPackageRepo addWorkPackageRepo,
    required BuildContext context,
  })  : _addWorkPackageRepo = addWorkPackageRepo,
        super(AsyncValue.initial());

  void createWorkPackage({
    required BuildContext context,
    required WorkPackagePayload payload,
  }) async {
    if (state.isLoading) return;

    emit(AsyncValue.loading());

    final serverUrl = context.getServerUrl();

    if (serverUrl == null) {
      return;
    }

    final apiToken = context.getApiToken();
    final workPackageMode = context.read<AddWorkPackageScreenConfig>();

    final result = await _addWorkPackageRepo.createWorkPackage(
      serverUrl: serverUrl,
      apiToken: apiToken,
      payload: payload.toJson(),
      editMode: workPackageMode.editMode,
      id: workPackageMode.editMode
          ? workPackageMode.workPackageId!
          : workPackageMode.projectId,
    );

    if (result.isData) {
      emit(AsyncValue.data(data: null));
    } else {
      emit(AsyncValue.error(error: result.error!));
    }
  }
}
