import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/widgets/work_package_tile.dart';
import 'package:open_project/work_packages/presentation/widgets/work_package_tile_loading_view.dart';

class WorkPackagesList extends StatelessWidget {
  const WorkPackagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkPackagesListCubit,
        PaginatedAsyncValue<PaginatedWorkPackages, NetworkFailure>>(
      builder: (context, workPackagesState) {
        return AsyncValueBuilder(
          value: workPackagesState,
          loading: (context) {
            return ListView.separated(
              itemCount: 7,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, __) => const WorkPackageTileLoadingView(),
            );
          },
          error: (context, error) {
            return AsyncRetryWidget(
              message: error.errorMessage,
              onPressed: () {
                final projectId = int.parse(
                  GoRouterState.of(context).pathParameters['project_id']!,
                );
                context.read<WorkPackagesListCubit>().getWorkPackages(
                      projectId: projectId,
                      workPackagesFilters:
                          const WorkPackagesFilters.noFilters(),
                    );
              },
            );
          },
          data: (context, data) {
            final workPackages = data.workPackages;

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

            return ListView.separated(
              itemCount: workPackages.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return WorkPackageTile(
                  title: workPackages[index].subject,
                  assignee: workPackages[index].assignee?.name,
                  status: workPackages[index].status.name,
                  statusColor: workPackages[index].status.colorHex,
                );
              },
            );
          },
        );
      },
    );
  }
}
