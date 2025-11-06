// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_repo.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/home/models/paginated_projects.dart';
import 'package:open_project/home/models/project.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';

class HomeController {
  final SearchDialogProjectsCubit searchDialogProjectsCubit;
  final BuildContext context;
  HomeController({
    required this.searchDialogProjectsCubit,
    required this.context,
  });

  final searchTextController = TextEditingController();
  void searchProjects() {
    if (searchTextController.text.isEmpty) {
      return;
    }

    searchDialogProjectsCubit.getProjects(
      context: context,
      projectsFilters: ProjectsFilters(
        name: searchTextController.text,
        public: null,
      ),
    );
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

  void logOut(BuildContext context) {
    context.read<CacheRepo>().clearAll().then((_) {
      context.goNamed(AppRoutes.splash.name);
    });
  }

  void dispose() {
    searchTextController.dispose();
  }
}
