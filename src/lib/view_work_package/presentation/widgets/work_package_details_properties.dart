import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_progress_bar.dart';

class WorkPackageDetailsProperties extends StatelessWidget {
  const WorkPackageDetailsProperties({super.key});

  @override
  Widget build(BuildContext context) {
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
        const _InfoTile(
          name: 'Version',
          value: '1.0',
          svgAsset: AppIcons.layer,
        ),
        const SizedBox(height: 24),
        const _InfoTile(
          name: 'Category',
          value: 'Category 1',
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
                text: '(50%)',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const AppProgressBar(value: 0.5),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String name;
  final String value;
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
        const SizedBox(width: 24),
        Text(
          value,
          style: AppTextStyles.medium.copyWith(
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
