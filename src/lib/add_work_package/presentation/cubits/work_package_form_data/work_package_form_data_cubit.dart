import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/data/add_work_package_repo.dart';
import 'package:open_project/add_work_package/models/work_package_mode.dart';
import 'package:open_project/add_work_package/models/work_package_options.dart';
import 'package:open_project/add_work_package/models/work_package_payload.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/core/util/cache_extension.dart';
import 'package:open_project/core/util/failure.dart';

part 'work_package_form_data_state.dart';

class WorkPackageFormDataCubit extends Cubit<WorkPackageFormDataState> {
  final AddWorkPackageRepo _addWorkPackageRepo;
  WorkPackageFormDataCubit({
    required AddWorkPackageRepo addWorkPackageRepo,
    required BuildContext context,
  })  : _addWorkPackageRepo = addWorkPackageRepo,
        super(WorkPackageFormDataFetchingState(value: AsyncValue.initial())) {
    getWorkPackageForm(context: context);
  }

  void getWorkPackageForm({
    required BuildContext context,

    /// If null, a normal request will be sent.
    /// Otherwise, a request will be made to the "Create
    /// Work Package Form" API, to get the options that match
    /// the work package type, because the "Edit Work Package Form"
    /// API doesn't allow adding a body.
    WPType? workPackageType,
  }) async {
    if (state.value.isLoading) return;

    if (workPackageType == null) {
      emit(WorkPackageFormDataFetchingState(value: AsyncValue.loading()));
    } else {
      emit(WorkPackageFormDataChangedTypeState(value: AsyncValue.loading()));
    }

    final serverUrl = context.getServerUrl();

    if (serverUrl == null) {
      return;
    }

    final apiToken = context.getApiToken();
    final workPackageMode = context.read<AddWorkPackageScreenConfig>();

    // If the work package type is not null, then a request of type 'create'
    // mode will be sent
    final editMode = workPackageType != null ? false : workPackageMode.editMode;

    final result = await _addWorkPackageRepo.getWorkPackageForm(
      serverUrl: serverUrl,
      apiToken: apiToken,
      body: workPackageType?.toFullJson(),
      editMode: editMode,
      id: editMode ? workPackageMode.workPackageId! : workPackageMode.projectId,
    );

    if (result.isData) {
      final data = result.data!;

      if (workPackageType == null) {
        emit(WorkPackageFormDataFetchingState(
          value: AsyncValue.data(data: data),
        ));
      } else {
        emit(WorkPackageFormDataChangedTypeState(
          value: AsyncValue.data(data: data),
        ));
      }
    } else {
      final error = result.error!;

      if (workPackageType == null) {
        emit(WorkPackageFormDataFetchingState(
          value: AsyncValue.error(error: error),
        ));
      } else {
        emit(WorkPackageFormDataChangedTypeState(
          value: AsyncValue.error(error: error),
        ));
      }
    }
  }
}
