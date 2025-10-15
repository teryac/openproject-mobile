import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_dropdown/app_dropdown_button.dart';

class WorkPackagePeople extends StatelessWidget {
  const WorkPackagePeople({super.key});

  @override
  Widget build(BuildContext context) {
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
        AppDropdownButton(
          items: const [
            'Yaman Kalaji',
            'Shaaban Shaheen',
            'Mohammad Haj Hmidi',
            'Majd Haj Hmidi',
          ],
          value: null,
          hint: 'Accountable',
          onChanged: (value) {},
        ),
        const SizedBox(height: 20),
        AppDropdownButton(
          items: const [
            'Yaman Kalaji',
            'Shaaban Shaheen',
            'Mohammad Haj Hmidi',
            'Majd Haj Hmidi',
          ],
          value: null,
          hint: 'Assignee',
          onChanged: (value) {},
        ),
      ],
    );
  }
}
