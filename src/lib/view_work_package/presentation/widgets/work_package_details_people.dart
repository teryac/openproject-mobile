import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/constants/api_constants.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/home/presentation/widgets/members_list.dart';
import 'package:open_project/work_packages/models/work_package.dart';

class WorkPackageDetailsPeople extends StatelessWidget {
  const WorkPackageDetailsPeople({super.key});

  @override
  Widget build(BuildContext context) {
    final workPackage = context.read<WorkPackage>();

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
        _PersonInfoTile(
          name: 'Accountable',
          value: workPackage.accountable?.name,
          avatarUrl: workPackage.accountable?.id == null
              ? null
              : ApiConstants.userAvatar(
                  workPackage.accountable!.id.toString(),
                ),
        ),
        const SizedBox(height: 20),
        _PersonInfoTile(
          name: 'Assignee',
          value: workPackage.assignee?.name,
          avatarUrl: workPackage.assignee?.id == null
              ? null
              : ApiConstants.userAvatar(
                  workPackage.assignee!.id.toString(),
                ),
        ),
      ],
    );
  }
}

class _PersonInfoTile extends StatelessWidget {
  /// e.g. "Accountable", "Assignee", etc.
  final String name;

  /// e.g. "Peter Peterson"
  final String? value;
  final String? avatarUrl;
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
        value == null
            ? const SizedBox.shrink()
            : Flexible(
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
                        // Will never build this widget if null
                        value!,
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
