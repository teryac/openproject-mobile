import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_progress_bar.dart';
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
        _InfoTile(
          name: 'Version',
          value: workPackage.versionName,
          svgAsset: AppIcons.layer,
        ),
        const SizedBox(height: 24),
        _InfoTile(
          name: 'Category',
          value: workPackage.categoryName,
          svgAsset: AppIcons.category,
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

class _InfoTile extends StatelessWidget {
  final String name;
  final String? value;
  final String svgAsset;
  const _InfoTile({
    required this.name,
    required this.value,
    required this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Row(
            children: [
              SvgPicture.asset(
                svgAsset,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.descriptiveText,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        if (value != null) ...[
          const SizedBox(width: 24),
          SizedBox(
            width: MediaQuery.sizeOf(context).width -
                100 // Tile name width
                -
                40 // Screen padding
                -
                24 // Space between text and tile
            ,
            child: Text(
              value!,
              style: AppTextStyles.medium.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          ),
        ]
      ],
    );
  }
}
