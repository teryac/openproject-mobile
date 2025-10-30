import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class WorkPackageDetailsOverview extends StatelessWidget {
  const WorkPackageDetailsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organize open source',
                    style: AppTextStyles.large.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created by Yaman Kalaji',
                    style: AppTextStyles.extraSmall.copyWith(
                      color: AppColors.descriptiveText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    color: AppColors.blue100.withAlpha(38),
                  ),
                  child: Text(
                    'Task',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue100,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'This task involves organizing open source contributions effectively. The goal is to streamline the workflow and enhance...',
          style: AppTextStyles.small.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        const _InfoTile(
          name: 'Priority',
          value: 'Medium',
          svgAsset: AppIcons.flag,
          colorHex: '#2392D4',
        ),
        const SizedBox(height: 20),
        const _InfoTile(
          name: 'Status',
          value: 'In progress',
          svgAsset: AppIcons.status,
          colorHex: '#2EAC5D',
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String name;
  final String value;
  final String svgAsset;
  final String colorHex;
  const _InfoTile({
    required this.name,
    required this.value,
    required this.svgAsset,
    required this.colorHex,
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
                  AppColors.iconSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: AppTextStyles.small.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: HexColor(colorHex),
          ),
          child: Text(
            value,
            style: AppTextStyles.small.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.buttonText,
            ),
          ),
        ),
      ],
    );
  }
}
