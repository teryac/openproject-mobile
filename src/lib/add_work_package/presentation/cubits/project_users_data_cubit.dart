import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/data/add_work_package_repo.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/core/util/cache_extension.dart';
import 'package:open_project/core/util/failure.dart';

class ProjectAssigneesDataCubit extends _ProjectUsersDataCubit {
  ProjectAssigneesDataCubit({
    required super.addWorkPackageRepo,
    required super.projectId,
  }) : super(projectMemberType: ProjectMemberType.assignee);
}

class ProjectResponsiblesDataCubit extends _ProjectUsersDataCubit {
  ProjectResponsiblesDataCubit({
    required super.addWorkPackageRepo,
    required super.projectId,
  }) : super(projectMemberType: ProjectMemberType.responsible);
}

class _ProjectUsersDataCubit
    extends Cubit<AsyncValue<List<WPUser>, NetworkFailure>> {
  final AddWorkPackageRepo _addWorkPackageRepo;
  final ProjectMemberType projectMemberType;
  final int projectId;
  _ProjectUsersDataCubit({
    required AddWorkPackageRepo addWorkPackageRepo,
    required this.projectMemberType,
    required this.projectId,
  })  : _addWorkPackageRepo = addWorkPackageRepo,
        super(AsyncValue.initial());

  void getUsers({
    required BuildContext context,
    required int projectId,
  }) async {
    if (state.isLoading) return;

    emit(AsyncValue.loading());

    final serverUrl = context.getServerUrl();

    if (serverUrl == null) {
      return;
    }

    final apiToken = context.getApiToken();

    final result = await _addWorkPackageRepo.getProjectUsers(
      serverUrl: serverUrl,
      apiToken: apiToken,
      projectId: projectId,
      projectMemberType: projectMemberType,
    );

    if (result.isData) {
      emit(AsyncValue.data(data: result.data!));
    } else {
      emit(AsyncValue.error(error: result.error!));
    }
  }
}
