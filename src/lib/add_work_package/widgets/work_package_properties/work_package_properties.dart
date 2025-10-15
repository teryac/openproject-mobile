import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_dropdown/app_dropdown_button.dart';

class WorkPackageProperties extends StatelessWidget {
  const WorkPackageProperties({super.key});

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
        const SizedBox(height: 20),
        AppDropdownButton(
          items: const [
            'v1.1',
            'v1.0.2',
            'v1.0.1',
            'v1.0',
          ],
          value: null,
          hint: 'Version',
          onChanged: (value) {},
        ),
        const SizedBox(height: 20),
        AppDropdownButton(
          items: const [
            'Mobile App',
            'Advertisment Campaign',
            'Website',
            'Testing',
          ],
          value: null,
          hint: 'Categories',
          onChanged: (value) {},
        ),
      ],
    );
  }
}
