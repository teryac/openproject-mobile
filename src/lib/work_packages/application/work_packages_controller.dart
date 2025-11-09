import 'package:flutter/material.dart';
import 'package:open_project/work_packages/models/work_package_filters.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_filters_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';

class WorkPackagesController {
  final BuildContext context;
  final WorkPackagesListCubit workPackagesListCubit;
  final SearchDialogWorkPackagesCubit searchDialogWorkPackagesCubit;
  final WorkPackagesFiltersCubit workPackagesFiltersCubit;
  final int projectId;

  WorkPackagesController({
    required this.context,
    required this.workPackagesListCubit,
    required this.searchDialogWorkPackagesCubit,
    required this.workPackagesFiltersCubit,
    required this.projectId,
  }) {
    workPackagesFiltersCubit.stream.listen((filters) {
      workPackagesListCubit.getWorkPackages(
        // ignore: use_build_context_synchronously
        context: context,
        projectId: projectId,
        workPackagesFilters: filters,
      );
    });
  }

  final searchTextController = TextEditingController();
  void searchProjects() {
    if (searchTextController.text.isEmpty) {
      return;
    }

    searchDialogWorkPackagesCubit.getWorkPackages(
      context: context,
      projectId: projectId,
      workPackagesFilters: WorkPackagesFilters(
        name: searchTextController.text,
      ),
    );
  }

  void dispose() {
    searchTextController.dispose();
  }
}
