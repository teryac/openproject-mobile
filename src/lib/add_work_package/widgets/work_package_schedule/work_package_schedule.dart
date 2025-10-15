import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/date_picker/date_picker_widget.dart';

class WorkPackageSchedule extends StatelessWidget {
  const WorkPackageSchedule({super.key});

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
        const SizedBox(height: 16),
        DatePickerWidget(
          startDate: DateTime(2006, 7, 22),
          finishDate: DateTime.now(),
          onChanged: (startDate, finishDate) {},
        ),
        const SizedBox(height: 16),
        const AppTextFormField(hint: 'Estimated time (Hours)'),
      ],
    );
  }
}
