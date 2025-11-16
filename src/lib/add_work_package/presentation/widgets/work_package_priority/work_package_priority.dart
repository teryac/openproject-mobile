import 'package:flutter/material.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_priority/work_package_priority_picker.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class WorkPackagePriority extends StatelessWidget {
  final EdgeInsets screenPadding;
  const WorkPackagePriority({
    super.key,
    required this.screenPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: screenPadding,
          child: Text(
            'Work pacakge priority',
            style: AppTextStyles.medium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const WorkPackagePriorityPicker(),
      ],
    );
  }
}
