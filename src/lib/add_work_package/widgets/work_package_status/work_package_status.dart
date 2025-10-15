import 'package:flutter/material.dart';
import 'package:open_project/add_work_package/widgets/work_package_status/work_package_status_picker.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class WorkPackageStatus extends StatelessWidget {
  final EdgeInsets screenPadding;
  const WorkPackageStatus({super.key, required this.screenPadding});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: screenPadding,
          child: Text(
            'Task status',
            style: AppTextStyles.medium.copyWith(
              color: AppColors.primaryText,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const WorkPackageStatusPicker(
          statusList: [
            (name: 'In progress', colorHex: '#2EAC5D'),
            (name: 'On hold', colorHex: '#848D90'),
            (name: 'Rejected', colorHex: '#F84616'),
            (name: 'Closed', colorHex: '#743CAC'),
          ],
        ),
      ],
    );
  }
}
