import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/add_work_package/application/add_work_package_controller.dart';
import 'package:open_project/add_work_package/models/work_package_mode.dart';
import 'package:open_project/add_work_package/presentation/cubits/add_work_package_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/week_days_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_description/work_package_description.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_overview/work_package_overview.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_people/work_package_people.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_priority/work_package_priority.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_progress/work_package_progress.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_properties/work_package_properties.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_schedule/work_package_schedule.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_status/work_package_status.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/async_retry.dart';
import 'package:open_project/core/widgets/custom_app_bar.dart';

class AddWorkPackageScreen extends StatelessWidget {
  const AddWorkPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = EdgeInsets.symmetric(horizontal: 20);

    return Portal(
      child: Scaffold(
        appBar: CustomAppBar(
          text: context.read<AddWorkPackageScreenConfig>().editMode
              ? 'Edit work package'
              : 'Create a work pacakge',
        ),
        body: BlocListener<AddWorkPackageDataCubit,
            AsyncValue<void, NetworkFailure>>(
          listener: (context, state) {
            if (state.isData) {
              // When true, the Work Packages screen will reload to get
              // the latest updates, and the View Work Package screen
              // will pop itself and force the WorkPackages screen to reload

              // Note, this route can be accessed in three ways:
              // 1. Work Packages --> View Work Package --> Edit Work Package
              //     (Reload)               (Pop)                (Pop)
              //
              // 2. Work Packages --> Add Work Package
              //     (Reload)              (Pop)

              // 3. Work Packages --> Edit Work Package (From popup menu)
              //     (Reload)              (Pop)
              context.pop<bool>(true);
            }

            if (state.isError) {
              showErrorSnackBar(context, state.error!.errorMessage);
            }
          },
          child: Builder(
            builder: (context) {
              final workPackageFormState =
                  context.watch<WorkPackageFormDataCubit>().state;
              final weekDaysState = context.watch<WeekDaysDataCubit>().state;

              if (weekDaysState.isError || workPackageFormState.value.isError) {
                return Center(
                  child: AsyncRetryWidget(
                    // If the first one is null, the second isn't
                    message: weekDaysState.error?.errorMessage ??
                        workPackageFormState.value.error!.errorMessage,
                    onPressed: () {
                      if (weekDaysState.error != null) {
                        context.read<WeekDaysDataCubit>().getWeekDays(context);
                      }

                      if (workPackageFormState.value.error != null) {
                        context
                            .read<WorkPackageFormDataCubit>()
                            .getWorkPackageForm(
                              context: context,
                              // This ensures that if the request fails while trying to
                              // update the options from the API (rather than requesting
                              // data for the first time), in that case the data isn't lost
                              workPackageType: context
                                  .read<WorkPackagePayloadCubit>()
                                  .state
                                  ?.type,
                            );
                      }
                    },
                  ),
                );
              }

              if (weekDaysState.isLoading ||
                  weekDaysState.isInitial ||
                  workPackageFormState.value.isInitial ||
                  workPackageFormState.value.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Passing the cubit is important for seamless widget rebuilds
              // (If you remove the bloc provider, the top-most bloc builder will
              // not respond to some states, to ensure, try to remove the provider
              // and change the work package type)
              return BlocProvider<WorkPackageFormDataCubit>.value(
                value: context.read<WorkPackageFormDataCubit>(),
                child: Builder(
                  builder: (context) {
                    return SingleChildScrollView(
                      child: SafeArea(
                        child: Form(
                          key: context.read<AddWorkPackageController>().formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 24),
                              // Overview
                              Padding(
                                padding: screenPadding,
                                child: WorkPackageOverview(),
                              ),
                              SizedBox(height: 20),
                              // Status
                              WorkPackageStatus(screenPadding: screenPadding),
                              SizedBox(height: 20),
                              Padding(
                                padding: screenPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Description
                                    WorkPackageDescription(),
                                    SizedBox(height: 48),
                                    // People
                                    WorkPackagePeople(),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              // Priority
                              WorkPackagePriority(
                                screenPadding: screenPadding,
                              ),
                              SizedBox(height: 48),
                              Padding(
                                padding: screenPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Schedule and Estimates
                                    WorkPackageSchedule(),
                                    SizedBox(height: 48),
                                    // Properties
                                    WorkPackageProperties(),
                                    SizedBox(height: 20),
                                    // Progress
                                    WorkPackageProgress(),
                                    SizedBox(height: 32),
                                    AppButton(
                                      text: context
                                              .read<
                                                  AddWorkPackageScreenConfig>()
                                              .editMode
                                          ? 'Edit work package'
                                          : 'Create work package',
                                      loading: context
                                          .watch<AddWorkPackageDataCubit>()
                                          .state
                                          .isLoading,
                                      onPressed: () {
                                        final payload = context
                                            .read<WorkPackagePayloadCubit>()
                                            .state;

                                        context
                                            .read<AddWorkPackageController>()
                                            .createOrEditWorkPackage(
                                              context: context,
                                              payload: payload!,
                                            );
                                      },
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
