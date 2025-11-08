import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/widgets/app_chip.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_types_data_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';

class WorkPackagesFiltersWidget extends StatelessWidget {
  const WorkPackagesFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final workPackagesAsyncValue =
            context.watch<WorkPackagesListCubit>().state;
        final workPackageDependenciesAsyncValue =
            context.watch<WorkPackageDependenciesDataCubit>().state;

        if (workPackagesAsyncValue.isFirstLoading ||
            workPackageDependenciesAsyncValue.isLoading) {
          return AppChipList.shimmer();
        }

        if (workPackagesAsyncValue.isError ||
            workPackageDependenciesAsyncValue.isError) {
          return const SizedBox.shrink();
        }

        final workPackageTypes =
            workPackageDependenciesAsyncValue.data!.workPackageTypes;

        return AppChipList(
          chips: [
            ...List.generate(
              workPackageTypes.length,
              (index) => AppChip(
                text: workPackageTypes[index].name,
                isSelected: false,
                onPressed: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}
