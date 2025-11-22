import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/work_packages/application/work_packages_controller.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_dependencies_data_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_package_tile.dart';
import 'package:open_project/work_packages/presentation/widgets/work_package_tile_loading_view.dart';

class WorkPackagesList extends StatelessWidget {
  const WorkPackagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final projectId = int.parse(
      GoRouterState.of(context).pathParameters['project_id']!,
    );

    return Builder(
      builder: (context) {
        // Listen to all states that build the screen
        final workPackagesAsyncValue =
            context.watch<WorkPackagesListCubit>().state;
        final workPackageDependenciesAsyncValue =
            context.watch<WorkPackageDependenciesDataCubit>().state;

        // Failure...
        if (workPackagesAsyncValue.isError ||
            workPackageDependenciesAsyncValue.isError) {
          return AsyncRetryWidget(
            // If the first doesn't have an error, the last must do so
            message: workPackagesAsyncValue.error?.errorMessage ??
                workPackageDependenciesAsyncValue.error!.errorMessage,
            onPressed: () {
              if (workPackagesAsyncValue.error != null) {
                context.read<WorkPackagesController>().getWorkPackages();
              }

              if (workPackageDependenciesAsyncValue.error != null) {
                final projectId = int.parse(
                  GoRouterState.of(context).pathParameters['project_id']!,
                );
                context
                    .read<WorkPackageDependenciesDataCubit>()
                    .getWorkPackageDependencies(
                      context: context,
                      projectId: projectId,
                    );
              }
            },
          );
        }

        // Loading...
        if (workPackagesAsyncValue.isFirstLoading ||
            workPackageDependenciesAsyncValue.isLoading ||
            workPackagesAsyncValue.isInitial ||
            workPackageDependenciesAsyncValue.isInitial) {
          return ListView.separated(
            itemCount: 7,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, __) => const WorkPackageTileLoadingView(),
          );
        }

        // Data...
        final workPackages = workPackagesAsyncValue.data!.workPackages;

        // No work packages...
        if (workPackages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No work packages found',
              style: AppTextStyles.medium.copyWith(
                color: AppColors.descriptiveText,
              ),
            ),
          );
        }

        return Column(
          children: [
            ListView.separated(
              itemCount: workPackages.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                return WorkPackageTile(
                  workPackage: workPackages[index],
                  projectId: projectId,
                  workPackagesLength: workPackages.length,
                  workPackageIndex: index,
                );
              },
            ),
            Builder(
              builder: (context) {
                if (!workPackagesAsyncValue.isLoadingPage) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListView.separated(
                    // In most cases, 2 loading tiles will be viewed, but if there's
                    // only 1 more work package left in the database that is being
                    // fetched, that can be confusing, that's why the minimum is picked
                    itemCount: min(
                      2,
                      context
                          .read<WorkPackagesController>()
                          .getRemainingUnfetchedWorkPackages(),
                    ),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, __) => const WorkPackageTileLoadingView(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
