import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/data/add_work_package_repo.dart';
import 'package:open_project/add_work_package/models/week_day.dart';
import 'package:open_project/core/util/cache_extension.dart';
import 'package:open_project/core/util/failure.dart';

class WeekDaysDataCubit
    extends Cubit<AsyncValue<List<WeekDay>, NetworkFailure>> {
  final AddWorkPackageRepo _addWorkPackageRepo;
  WeekDaysDataCubit({
    required AddWorkPackageRepo addWorkPackageRepo,
    required BuildContext context,
  })  : _addWorkPackageRepo = addWorkPackageRepo,
        super(AsyncValue.initial()) {
    getWeekDays(context);
  }

  void getWeekDays(BuildContext context) async {
    if (state.isLoading) return;

    emit(AsyncValue.loading());

    final serverUrl = context.getServerUrl();

    if (serverUrl == null) {
      return;
    }

    final result = await _addWorkPackageRepo.getWeekDays(
      serverUrl: serverUrl,
    );

    if (result.isData) {
      emit(AsyncValue.data(data: result.data!));
    } else {
      emit(AsyncValue.error(error: result.error!));
    }
  }
}
