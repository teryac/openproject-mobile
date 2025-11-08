import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/date_format.dart';
import 'package:open_project/core/util/duration_extension.dart';
import 'package:open_project/core/widgets/date_picker/date_picker_widget.dart';
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
        Row(
          children: [
            SvgPicture.asset(
              AppIcons.clock,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppColors.descriptiveText,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Estimated time',
              style: AppTextStyles.small.copyWith(
                color: AppColors.descriptiveText,
              ),
            ),
            const SizedBox(width: 24),
            Text(
              workPackage.estimatedTime == null
                  ? ''
                  : workPackage.estimatedTime!.toReadableString(),
              style: AppTextStyles.medium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
