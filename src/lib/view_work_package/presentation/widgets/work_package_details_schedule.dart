import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/date_picker/date_picker_widget.dart';

class WorkPackageDetailsSchedule extends StatelessWidget {
  const WorkPackageDetailsSchedule({super.key});

  @override
  Widget build(BuildContext context) {
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
          startDate: DateTime.now().subtract(
            const Duration(days: 3902),
          ),
          finishDate: DateTime.now(),
          onChanged: (startDate, finishDate) {},
          enabled: false,
        ),
        const SizedBox(height: 12),
        Center(
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: 'Deadline in ',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.descriptiveText,
                  ),
                ),
                TextSpan(
                  text: '2 weeks.',
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText,
                  ),
                ),
                TextSpan(
                  text: ' (11th Jun is today’s date)',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.descriptiveText,
                  ),
                ),
              ],
            ),
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
              '3.5 Hours',
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
