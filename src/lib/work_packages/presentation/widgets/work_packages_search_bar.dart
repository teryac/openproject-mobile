import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class WorkPackagesSearchBar extends StatelessWidget {
  const WorkPackagesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTextFormField.filled(
      hint: 'Search for tasks in this project..',
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: SvgPicture.asset(
          AppIcons.search,
          width: 24,
          height: 24,
          // ignore: deprecated_member_use
          color: AppColors.iconSecondary,
        ),
      ),
    );
  }
}
