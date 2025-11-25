import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_progress_bar.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_info_tile.dart';
import 'package:open_project/work_packages/models/work_package.dart';

class WorkPackageDetailsProperties extends StatelessWidget {
  const WorkPackageDetailsProperties({super.key});

  @override
  Widget build(BuildContext context) {
    final workPackage = context.read<WorkPackage>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Package Properties',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 24),
        WorkPackageInfoTile(
          hint: 'Version',
          svgIconAsset: AppIcons.layer,
          value: workPackage.versionName,
        ),
        const SizedBox(height: 24),
        WorkPackageInfoTile(
          hint: 'Category',
          svgIconAsset: AppIcons.category,
          value: workPackage.categoryName,
        ),
        const SizedBox(height: 24),
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
                text: '(${workPackage.percentageDone}%)',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppProgressBar(value: (workPackage.percentageDone / 100).toDouble()),
      ],
    );
  }
}
