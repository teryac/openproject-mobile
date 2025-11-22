import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_project/add_work_package/models/work_package_payload.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/add_work_package/presentation/cubits/add_work_package_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/models/value.dart';

class AddWorkPackageController {
  final WorkPackageFormDataCubit workPackageFormDataCubit;
  final WorkPackagePayloadCubit workPackagePayloadCubit;
  final AddWorkPackageDataCubit addWorkPackageDataCubit;
  AddWorkPackageController({
    required this.workPackageFormDataCubit,
    required this.workPackagePayloadCubit,
    required this.addWorkPackageDataCubit,
  }) {
    _workPackageFormDataCubitStreamSubscription =
        workPackageFormDataCubit.stream.listen((state) {
      if (!state.value.isData) return;

      if (state is WorkPackageFormDataFetchingState) {
        workPackagePayloadCubit.updatePayload(
          state.value.data!.payload,
        );

        return;
      }

      // Else: state is `WorkPackageFormDataChangedTypeState`
      // In this case, only update the type and status
      final type = state.value.data!.payload.type;

      // The status should -ideally- not change, but it may be not
      // available in the options list
      WPStatus status = workPackagePayloadCubit.state!.status;
      final newStatusList = state.value.data!.options.statuses;

      if (!newStatusList.map((e) => e.id).contains(status.id)) {
        // If not found in new options list, set to first status
        status = newStatusList.first;
      }

      // Update payload
      workPackagePayloadCubit.updatePayload(
        workPackagePayloadCubit.state!.copyWith(
          type: Value.present(type),
          status: Value.present(status),
        ),
      );
    });
  }

  StreamSubscription? _workPackageFormDataCubitStreamSubscription;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  bool _validateForm() {
    if (_formKey.currentState != null) {
      return _formKey.currentState!.validate();
    }

    return false;
  }

  void createOrEditWorkPackage({
    required BuildContext context,
    required WorkPackagePayload payload,
  }) {
    if (!_validateForm()) {
      return;
    }

    addWorkPackageDataCubit.createWorkPackage(
      context: context,
      payload: payload,
    );
  }

  Duration? getDurationFromDecimalHoursString(String hoursString) {
    final hours = double.tryParse(hoursString);
    if (hours == null || hours < 0) return null;

    final totalMinutes = (hours * 60).round();
    return Duration(minutes: totalMinutes);
  }

  String formatDurationToDecimalHours(Duration? duration) {
    if (duration == null) return "";

    final double hours = duration.inMinutes / 60.0;

    // Format to avoid unnecessary .0 (e.g., "2" instead of "2.0")
    if (hours == hours.truncate()) {
      return hours.truncate().toString();
    } else {
      // Format to 2 decimal places and remove trailing zeros
      return hours.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }

  void dispose() {
    _workPackageFormDataCubitStreamSubscription?.cancel();
  }
}
