import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/view_work_package/presentation/widgets/work_package_info_tile.dart';
import 'package:open_project/work_packages/models/work_package.dart';
import 'package:open_project/work_packages/models/work_package_dependencies.dart';

class WorkPackageDetailsOverview extends StatelessWidget {
  const WorkPackageDetailsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final workPackage = context.read<WorkPackage>();
    final dependencies = context.read<WorkPackageDependencies>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workPackage.subject,
                    style: AppTextStyles.large.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created by ${workPackage.author.name}',
                    style: AppTextStyles.extraSmall.copyWith(
                      color: AppColors.descriptiveText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 4,
              child: Align(
                alignment: Alignment.centerRight,
                child: Builder(
                  builder: (context) {
                    final type = dependencies.workPackageTypes.firstWhere(
                      (element) => element.id == workPackage.typeId,
                    );

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: HexColor(type.colorHex).withAlpha(38),
                      ),
                      child: Text(
                        type.name,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.small.copyWith(
                          fontWeight: FontWeight.w500,
                          color: HexColor(type.colorHex),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Builder(
          builder: (context) {
            final priority = dependencies.workPackagePriorities.firstWhere(
              (element) => element.id == workPackage.priorityId,
            );

            return WorkPackageInfoTile(
              hint: 'Priority',
              value: priority.name,
              svgIconAsset: AppIcons.flag,
              valueTileColor: HexColor(priority.colorHex).getReadableColor(),
            );
          },
        ),
        const SizedBox(height: 20),
        Builder(
          builder: (context) {
            final status = dependencies.workPackageStatuses.firstWhere(
              (element) => element.id == workPackage.statusId,
            );

            return WorkPackageInfoTile(
              hint: 'Status',
              value: status.name,
              svgIconAsset: AppIcons.status,
              valueTileColor: HexColor(status.colorHex).getReadableColor(),
            );
          },
        ),
      ],
    );
  }
}
