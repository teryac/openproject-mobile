import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/avatar_widget.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_info_tile.dart';
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
        WorkPackageInfoTile(
          hint: 'Accountable',
          value: workPackage.accountable?.name,
          valueBuilder: (context, value) {
            final userId = workPackage.accountable?.id;

            return _UserInfoWidget(userId: userId, value: value);
          },
        ),
        const SizedBox(height: 20),
        WorkPackageInfoTile(
          hint: 'Assignee',
          value: workPackage.assignee?.name,
          valueBuilder: (context, value) {
            final userId = workPackage.assignee?.id;

            return _UserInfoWidget(userId: userId, value: value);
          },
        ),
      ],
    );
  }
}

class _UserInfoWidget extends StatelessWidget {
  final int? userId;
  final String value;
  const _UserInfoWidget({
    required this.userId,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AvatarWidget.noBorder(
          userData: (userId != null)
              ? (
                  id: userId!,
                  fullName: value,
                )
              : null,
          radius: 12,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.small.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
