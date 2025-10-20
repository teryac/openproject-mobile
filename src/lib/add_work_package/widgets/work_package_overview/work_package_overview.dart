import 'package:flutter/material.dart';
import 'package:open_project/add_work_package/widgets/work_package_overview/work_package_type_picker.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class WorkPackageOverview extends StatelessWidget {
  const WorkPackageOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work package overview',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            WorkPackageTypePicker(),
            SizedBox(width: 12),
            Expanded(
              child: AppTextFormField(hint: 'Work Package title'),
            ),
          ],
        ),
      ],
    );
  }
}
