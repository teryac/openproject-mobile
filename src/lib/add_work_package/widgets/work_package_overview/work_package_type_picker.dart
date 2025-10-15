import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class WorkPackageTypePicker extends StatelessWidget {
  const WorkPackageTypePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        right: 12,
        left: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.blue25,
        borderRadius: BorderRadius.circular(360),
      ),
      child: Row(
        children: [
          Text(
            'Task',
            style: AppTextStyles.small.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.blue100,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            AppIcons.arrowDown,
            width: 12,
            height: 12,
            colorFilter: const ColorFilter.mode(
              AppColors.blue100,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
