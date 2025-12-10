import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/util/padding_util.dart';

class WorkPackageStatusPicker extends StatelessWidget {
  const WorkPackageStatusPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = context
        .read<WorkPackageFormDataCubit>()
        .state
        .value
        .data!
        .options
        .statuses;
    final selectedStatus = context.select<WorkPackagePayloadCubit, WPStatus>(
      (cubit) => cubit.state!.status,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          statuses.length,
          (index) {
            return Padding(
              padding: getScrollableRowPadding(
                context: context,
                index: index,
                listLength: statuses.length,
                marginalPadding: 20,
                itemPadding: 12,
              ),
              child: _WorkPackageStatusItem(
                status: statuses[index],
                isSelected: statuses[index].id == selectedStatus.id,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkPackageStatusItem extends StatelessWidget {
  final WPStatus status;
  final bool isSelected;
  const _WorkPackageStatusItem({
    required this.status,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options =
        context.read<WorkPackageFormDataCubit>().state.value.data!.options;
    final color = HexColor(status.colorHex).getReadableColor();

    return InkWell(
      onTap: () {
        if (!options.isStatusWritable) {
          showWarningSnackBar(context, 'Status can\'t be changed');
          return;
        }

        final payloadCubit = context.read<WorkPackagePayloadCubit>();

        payloadCubit.updatePayload(
          payloadCubit.state!.copyWith(
            status: Value.present(status),
          ),
        );
      },
      splashColor: color.withAlpha(75),
      highlightColor: Colors.transparent, // Removes gray overlay
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: options.isStatusWritable || isSelected ? 1.0 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withAlpha(38),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (isSelected) ...[
                SvgPicture.asset(
                  AppIcons.status,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                status.name,
                style: AppTextStyles.small.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
