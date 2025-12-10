import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/models/work_package_mode.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/add_work_package/presentation/cubits/project_users_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_dropdown/app_dropdown_button.dart';
import 'package:open_project/core/widgets/async_retry.dart';

class WorkPackagePeople extends StatelessWidget {
  const WorkPackagePeople({super.key});

  @override
  Widget build(BuildContext context) {
    final options =
        context.read<WorkPackageFormDataCubit>().state.value.data!.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'People',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<ProjectResponsiblesDataCubit,
            AsyncValue<List<WPUser>, NetworkFailure>>(
          builder: (context, state) {
            final responsible =
                context.select<WorkPackagePayloadCubit, WPUser?>(
              (cubit) => cubit.state!.responsible,
            );

            return AppDropdownButton(
              hint: 'Accountable',
              values: !state.isData ? [] : state.data!,
              value: responsible,
              titles: !state.isData
                  ? []
                  : state.data!.map((user) => user.name).toList(),
              title: responsible?.name,
              onChanged: (value) {
                final payloadCubit = context.read<WorkPackagePayloadCubit>();

                payloadCubit.updatePayload(
                  payloadCubit.state!.copyWith(
                    responsible: Value.present(value),
                  ),
                );
              },
              enabled: options.isAccountableWritable,
              onTap: () {
                if (!options.isAccountableWritable) {
                  showWarningSnackBar(context, 'Accountable can\'t be changed');
                }
              },
              onMenuToggled: () {
                if (state.isInitial) {
                  context.read<ProjectResponsiblesDataCubit>().getUsers(
                        context: context,
                        projectId: context
                            .read<AddWorkPackageScreenConfig>()
                            .projectId,
                      );
                }
              },
              loading: state.isLoading,
              errorBuilder: !state.isError
                  ? null
                  : (context) {
                      return AsyncRetryWidget(
                        message: state.error!.errorMessage,
                        onPressed: () {
                          context.read<ProjectResponsiblesDataCubit>().getUsers(
                                context: context,
                                projectId: context
                                    .read<AddWorkPackageScreenConfig>()
                                    .projectId,
                              );
                        },
                      );
                    },
            );
          },
        ),
        const SizedBox(height: 20),
        BlocBuilder<ProjectAssigneesDataCubit,
            AsyncValue<List<WPUser>, NetworkFailure>>(
          builder: (context, state) {
            final assignee = context.select<WorkPackagePayloadCubit, WPUser?>(
              (cubit) => cubit.state!.assignee,
            );

            return AppDropdownButton(
              hint: 'Assignee',
              values: !state.isData ? [] : state.data!,
              value: assignee,
              titles: !state.isData
                  ? []
                  : state.data!.map((user) => user.name).toList(),
              title: assignee?.name,
              onChanged: (value) {
                final payloadCubit = context.read<WorkPackagePayloadCubit>();

                payloadCubit.updatePayload(
                  payloadCubit.state!.copyWith(
                    assignee: Value.present(value),
                  ),
                );
              },
              enabled: options.isAssigneeWritable,
              onTap: () {
                if (!options.isAssigneeWritable) {
                  showWarningSnackBar(context, 'Assignee can\'t be changed');
                }
              },
              onMenuToggled: () {
                if (state.isInitial) {
                  context.read<ProjectAssigneesDataCubit>().getUsers(
                        context: context,
                        projectId: context
                            .read<AddWorkPackageScreenConfig>()
                            .projectId,
                      );
                }
              },
              loading: state.isLoading,
              errorBuilder: !state.isError
                  ? null
                  : (context) {
                      return AsyncRetryWidget(
                        message: state.error!.errorMessage,
                        onPressed: () {
                          context.read<ProjectAssigneesDataCubit>().getUsers(
                                context: context,
                                projectId: context
                                    .read<AddWorkPackageScreenConfig>()
                                    .projectId,
                              );
                        },
                      );
                    },
            );
          },
        ),
      ],
    );
  }
}
