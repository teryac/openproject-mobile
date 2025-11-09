import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_chip.dart';
import 'package:open_project/work_packages/models/work_package_dependencies.dart';
import 'package:open_project/work_packages/models/work_package_filters.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_filters_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_types_data_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';

class WorkPackagesFiltersWidget extends StatelessWidget {
  const WorkPackagesFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkPackageDependenciesDataCubit,
        AsyncValue<WorkPackageDependencies, NetworkFailure>>(
      builder: (context, dependenciesState) {
        return AsyncValueBuilder(
          value: dependenciesState,
          loading: (context) {
            // There is no need of waiting for the work packages list
            // finish loading, moreover, this widget must not depend on
            // the work packages list API, because sending a request with
            // new filters (Loading page #1) will force this widget to show
            // a loading view which is unintended behavior
            return AppChipList.shimmer();
          },
          error: (context, error) {
            // Not having a retry widget is fine in this case,
            // because the work packages list won't build unless
            // all APIs are successful, otherwise, a retry widget
            // will be shown
            return const SizedBox.shrink();
          },
          data: (context, data) {
            return Builder(
              builder: (context) {
                final workPackagesState =
                    context.watch<WorkPackagesListCubit>().state;

                final workPackagesFiltersCubit =
                    context.watch<WorkPackagesFiltersCubit>();
                final workPackagesFilters = workPackagesFiltersCubit.state;

                return AppChipList(
                  chips: _buildChips(
                    dependencies: data,
                    // `isLoading` includes loading the first page (`isFirstLoading`),
                    // and loading an additional page (`isLoadingPage`).
                    filtersCubit: workPackagesFiltersCubit,
                    filters: workPackagesFilters,
                    disabled: workPackagesState.isLoading,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

List<AppChip> _buildChips({
  required WorkPackageDependencies dependencies,
  required WorkPackagesFiltersCubit filtersCubit,
  required WorkPackagesFilters filters,

  /// Used to disable chip taps when a request is already
  /// being sent
  required bool disabled,
}) {
  final overdueChip = AppChip(
    text: 'Overdue',
    isSelected: filters.isOverdue ?? false,
    onPressed: disabled ? null : filtersCubit.toggleOverdue,
  );

  final typeChips = dependencies.workPackageTypes.map((type) {
    return AppChip(
      text: type.name,
      isSelected: filters.typeIDs?.contains(type.id) ?? false,
      onPressed: disabled ? null : () => filtersCubit.toggleType(type.id),
    );
  }).toList();

  final statusChips = dependencies.workPackageStatuses.map((status) {
    return AppChip(
      text: status.name,
      isSelected: filters.statusIDs?.contains(status.id) ?? false,
      onPressed: disabled ? null : () => filtersCubit.toggleStatus(status.id),
    );
  }).toList();

  final priorityChips = dependencies.workPackagePriorities.map((priority) {
    return AppChip(
      text: priority.name,
      isSelected: filters.priorityIDs?.contains(priority.id) ?? false,
      onPressed:
          disabled ? null : () => filtersCubit.togglePriority(priority.id),
    );
  }).toList();

  final allExceptOverdue = [
    ...typeChips,
    ...statusChips,
    ...priorityChips,
  ]
      // Remove comment to shuffle (Results in unsolved bug, the list is
      // shuffled every time the UI rebuilds)
      // ..shuffle();
      ;

  return [overdueChip, ...allExceptOverdue];
}
