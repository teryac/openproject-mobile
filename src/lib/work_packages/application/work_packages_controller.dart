import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/pagination.dart' as pagination_tools;
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
    _workPackagesFiltersCubitStreamSubscription =
        workPackagesFiltersCubit.stream.listen((filters) {
      workPackagesListCubit.getWorkPackages(
        // ignore: use_build_context_synchronously
        context: context,
        projectId: projectId,
        workPackagesFilters: filters,
      );
    });

    scrollController.addListener(_onScroll);
  }

  StreamSubscription? _workPackagesFiltersCubitStreamSubscription;

  final searchTextController = TextEditingController();
  final scrollController = ScrollController();

  void _onScroll() {
    // If not data, or the controller doesn't have clients, skip
    final isDataState = workPackagesListCubit.state.isData;
    if (!scrollController.hasClients || !isDataState) return;

    // If reached last page, also skip
    final workPackagesDataModel = workPackagesListCubit.state.data!;
    final isLastPage = pagination_tools.isLastPage(
      total: workPackagesDataModel.total,
      pageSize: workPackagesDataModel.pageSize,
      currentPage: workPackagesDataModel.page,
    );

    if (isLastPage) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    // If we are 800px from the bottom, trigger the Cubit
    final reachedScrollThreshold = currentScroll >= (maxScroll - 800);

    if (reachedScrollThreshold) {
      getWorkPackages();
    }
  }

  void getWorkPackages({bool resetPages = false}) {
    // It's crucial to get the same filters as the first page,
    // otherwise, a new page will be requested
    final previousFilters = workPackagesFiltersCubit.state;

    workPackagesListCubit.getWorkPackages(
      context: context,
      projectId: projectId,
      workPackagesFilters: previousFilters,
      resetPages: resetPages,
    );
  }

  void searchWorkPackages({required String query}) {
    context.read<SearchDialogWorkPackagesCubit>().getWorkPackages(
          context: context,
          projectId: projectId,
          workPackagesFilters: WorkPackagesFilters(name: query),
          resetPages: true,
        );
  }

  int getRemainingUnfetchedWorkPackages() {
    final workPackagesDataModel = workPackagesListCubit.state.data!;

    final totalWorkPackages = workPackagesDataModel.total;
    final currentlyFetchedItems =
        (workPackagesDataModel.pageSize * (workPackagesDataModel.page - 1)) +
            // ** Because the last page might not be full **
            workPackagesDataModel.count;

    return totalWorkPackages - currentlyFetchedItems;
  }

  void dispose() {
    searchTextController.dispose();

    _workPackagesFiltersCubitStreamSubscription?.cancel();

    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }
}
