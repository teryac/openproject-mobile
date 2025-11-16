part of 'work_package_form_data_cubit.dart';

sealed class WorkPackageFormDataState {
  final AsyncValue<
      ({
        WorkPackageOptions options,
        WorkPackagePayload payload,
      }),
      NetworkFailure> value;

  WorkPackageFormDataState({required this.value});
}

// This is emitted for the first form request
class WorkPackageFormDataFetchingState extends WorkPackageFormDataState {
  WorkPackageFormDataFetchingState({required super.value});
}

// This is emitted when the type is changed
class WorkPackageFormDataChangedTypeState extends WorkPackageFormDataState {
  WorkPackageFormDataChangedTypeState({required super.value});
}
