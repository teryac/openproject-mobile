import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_progress_bar.dart';

class WorkPackageProgress extends StatelessWidget {
  const WorkPackageProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Progress ',
                style: AppTextStyles.medium.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              TextSpan(
                text: '(%)',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppProgressBar(
          value: 0.5,
          onChanged: (value) {},
        ),
      ],
    );
  }
}
