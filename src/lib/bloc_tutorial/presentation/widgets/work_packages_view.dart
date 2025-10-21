import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/bloc_tutorial/models/work_package.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/work_packages_cubit.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/async_retry.dart';

class WorkPackagesView extends StatelessWidget {
  const WorkPackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Work Packages'),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BlocBuilder<WorkPackagesCubit,
              AsyncValue<List<WorkPackage>, NetworkFailure>>(
            builder: (context, state) {
              return AsyncValueBuilder(
                value: state,
                loading: (context) => const Center(
                  child: Text('Loading'),
                ),
                data: (context, data) {
                  return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        color: index % 2 == 0 ? Colors.grey : Colors.white,
                        child: Row(
                          children: [
                            Text(
                              data[index].name,
                            ),
                            const Spacer(),
                            Text(
                              'Type: ${data[index].type}',
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (context, error) => AsyncRetryWidget(
                  message: error.errorMessage,
                  onPressed: context.read<WorkPackagesCubit>().getWorkPackages,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
