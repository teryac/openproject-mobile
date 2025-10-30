import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/home/presentation/widgets/members_list.dart';

class WorkPackageDetailsPeople extends StatelessWidget {
  const WorkPackageDetailsPeople({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'People',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        const _PersonInfoTile(
          name: 'Accountable',
          value: 'Yaman Kalaji',
          avatarUrl: 'website.example.com/avatar1.png',
        ),
        const SizedBox(height: 20),
        const _PersonInfoTile(
          name: 'Assignee',
          value: 'Shaaban Shaheen',
          avatarUrl: 'website.example.com/avatar2.png',
        ),
      ],
    );
  }
}

class _PersonInfoTile extends StatelessWidget {
  /// e.g. "Accountable", "Assignee", etc.
  final String name;

  /// e.g. "Peter Peterson"
  final String value;
  final String avatarUrl;
  const _PersonInfoTile({
    required this.name,
    required this.value,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            name,
            style: AppTextStyles.small.copyWith(
              color: AppColors.descriptiveText,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.searchBarBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MemberAvatarWidget.noBorder(
                  fullName: value,
                  color: Colors.red, // Temp solution
                  radius: 12,
                ),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
