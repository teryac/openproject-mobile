import 'package:flutter/material.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';

class WorkPackagesController {
  final SearchDialogWorkPackagesCubit searchDialogWorkPackagesCubit;
  final int projectId;

  WorkPackagesController({
    required this.searchDialogWorkPackagesCubit,
    required this.projectId,
  });

  final searchTextController = TextEditingController();
  void searchProjects() {
    if (searchTextController.text.isEmpty) {
      return;
    }

    searchDialogWorkPackagesCubit.getWorkPackages(
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
