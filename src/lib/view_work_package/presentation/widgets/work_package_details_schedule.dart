import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/date_format.dart';
import 'package:open_project/core/util/duration_extension.dart';
import 'package:open_project/core/widgets/date_picker/date_picker_widget.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_info_tile.dart';
import 'package:open_project/work_packages/models/work_package.dart';

class WorkPackageDetailsSchedule extends StatelessWidget {
  const WorkPackageDetailsSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final workPackage = context.read<WorkPackage>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule and Estimates',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 24),
        DatePickerWidget(
          startDate: workPackage.startDate,
          finishDate: workPackage.dueDate,
          onChanged: (startDate, finishDate) {},
          enabled: false,
        ),
        const SizedBox(height: 12),
        Center(
          child: Builder(
            builder: (context) {
              final formattedCurrentDate = getFormattedDate(
                DateTime.now(),
              )!;

              if (workPackage.dueDate == null) {
                return SizedBox.shrink();
              }

              final formattedDeadlineDate = parseDeadline(workPackage.dueDate!);

              return Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${formattedDeadlineDate.prefix} ',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.descriptiveText,
                      ),
                    ),
                    TextSpan(
                      text: formattedDeadlineDate.value,
                      style: AppTextStyles.small.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' (${formattedCurrentDate.day}${formattedCurrentDate.daySuffix} ${formattedCurrentDate.month.substring(0, 3)} is today’s date)',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.descriptiveText,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        WorkPackageInfoTile(
          hint: 'Estimated time',
          svgIconAsset: AppIcons.clock,
          value: workPackage.estimatedTime?.toReadableString(),
        ),
      ],
    );
  }
}
