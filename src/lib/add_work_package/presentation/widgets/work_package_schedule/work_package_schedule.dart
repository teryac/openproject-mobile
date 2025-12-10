import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/application/add_work_package_controller.dart';
import 'package:open_project/add_work_package/presentation/cubits/week_days_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/date_picker/date_range_picker_widget.dart';
import 'package:open_project/core/widgets/duration_text_form_field.dart';

class WorkPackageSchedule extends StatelessWidget {
  const WorkPackageSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final isUsingDateRange = context
        .read<WorkPackageFormDataCubit>()
        .state
        .value
        .data!
        .options
        .usingDateRange;

    final data = context.select<
        WorkPackagePayloadCubit,
        ({
          DateTime? date,
          DateTime? startDate,
          DateTime? dueDate,
          Duration? estimatedTime,
        })>((cubit) {
      final payload = cubit.state!;
      return (
        date: payload.date,
        startDate: payload.startDate,
        dueDate: payload.dueDate,
        estimatedTime: payload.estimatedTime,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule and Estimates',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        isUsingDateRange
            ? DateRangePickerWidget(
                startDate: data.startDate,
                finishDate: data.dueDate,
                weekDays: context.read<WeekDaysDataCubit>().state.data!,
                onChanged: (startDate, finishDate) {
                  final payloadCubit = context.read<WorkPackagePayloadCubit>();
                  payloadCubit.updatePayload(
                    payloadCubit.state!.copyWith(
                      startDate: Value.present(startDate),
                      dueDate: Value.present(finishDate),
                    ),
                  );
                },
              )
            : DatePickerWidget(
                date: data.date,
                weekDays: context.read<WeekDaysDataCubit>().state.data!,
                onChanged: (date) {
                  final payloadCubit = context.read<WorkPackagePayloadCubit>();
                  payloadCubit.updatePayload(
                    payloadCubit.state!.copyWith(
                      date: Value.present(date),
                    ),
                  );
                },
              ),
        const SizedBox(height: 16),
        DurationTextFormField(
          hint: 'Estimated time (Hours)',
          value: data.estimatedTime,
          durationFormatter: context
              .read<AddWorkPackageController>()
              .formatDurationToDecimalHours,
          durationParser: context
              .read<AddWorkPackageController>()
              .getDurationFromDecimalHoursString,
          onChanged: (newDuration) {
            final payloadCubit = context.read<WorkPackagePayloadCubit>();
            payloadCubit.updatePayload(
              payloadCubit.state!.copyWith(
                estimatedTime: Value.present(newDuration),
              ),
            );
          },
        ),
      ],
    );
  }
}
