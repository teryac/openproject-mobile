import 'package:flutter/material.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/models/project.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';

class HomeController {
  final SearchDialogProjectsCubit searchDialogProjectsCubit;
  HomeController({required this.searchDialogProjectsCubit});

  final searchTextController = TextEditingController();
  void searchProjects() {
    if (searchTextController.text.isEmpty) {
      return;
    }

    searchDialogProjectsCubit.getProjects(
      projectsFilters: ProjectsFilters(
        name: searchTextController.text,
        public: null,
      ),
    );
  }

  bool isLastPage({
    required int total,
    required int pageSize,
    required int currentPage,
  }) {
    return currentPage == (total / pageSize).ceil();
  }

  List<Project> separatePublicFromPrivateProjects({
    required List<Project> projects,
    required bool public,
  }) {
    final List<Project> separatedProjects = [];
    for (final project in projects) {
      if (project.public == public) {
        separatedProjects.add(project);
      }
    }

    return separatedProjects;
  }

  void dispose() {
    searchTextController.dispose();
  }
}
