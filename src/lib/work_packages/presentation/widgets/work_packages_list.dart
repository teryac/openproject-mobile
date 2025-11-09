import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/pagination.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/core/widgets/load_next_page_button.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_filters_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_types_data_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_package_tile.dart';
import 'package:open_project/work_packages/presentation/widgets/work_package_tile_loading_view.dart';

class WorkPackagesList extends StatelessWidget {
  const WorkPackagesList({super.key});

  void getWorkPackages(BuildContext context) {
    final projectId = int.parse(
      GoRouterState.of(context).pathParameters['project_id']!,
    );

    // It's crucial to get the same filters as the first page,
    // otherwise, a new page will be requested
    final previousFilters = context.read<WorkPackagesFiltersCubit>().state;

    context.read<WorkPackagesListCubit>().getWorkPackages(
          context: context,
          projectId: projectId,
          workPackagesFilters: previousFilters,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // Listen to all states that build the screen
        final workPackagesAsyncValue =
            context.watch<WorkPackagesListCubit>().state;
        final workPackageTypesAsyncValue =
            context.watch<WorkPackageDependenciesDataCubit>().state;

        // Loading...
        if (workPackagesAsyncValue.isFirstLoading ||
            workPackageTypesAsyncValue.isLoading ||
            workPackagesAsyncValue.isInitial ||
            workPackageTypesAsyncValue.isInitial) {
          return ListView.separated(
            itemCount: 7,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, __) => const WorkPackageTileLoadingView(),
          );
        }

        // Failure...
        if (workPackagesAsyncValue.isError ||
            workPackageTypesAsyncValue.isError) {
          return AsyncRetryWidget(
            // If the first doesn't have an error, the last must do so
            message: workPackagesAsyncValue.error?.errorMessage ??
                workPackageTypesAsyncValue.error!.errorMessage,
            onPressed: () {
              if (workPackagesAsyncValue.error != null) {
                getWorkPackages(context);
              }

              if (workPackageTypesAsyncValue.error != null) {
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

        // Data...
        final workPackagesModel = workPackagesAsyncValue.data!;
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
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return WorkPackageTile(
                  workPackage: workPackages[index],
                );
              },
            ),
            Builder(
              builder: (context) {
                if (isLastPage(
                  total: workPackagesModel.total,
                  pageSize: workPackagesModel.pageSize,
                  currentPage: workPackagesModel.page,
                )) {
                  return const SizedBox.shrink();
                }

                // If loading more items
                if (workPackagesAsyncValue.isLoadingPage) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Align(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: LoadNextPageButton(
                    onTap: () => getWorkPackages(context),
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
