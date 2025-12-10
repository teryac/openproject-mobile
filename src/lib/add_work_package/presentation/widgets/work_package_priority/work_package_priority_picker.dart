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

class WorkPackagePriorityPicker extends StatelessWidget {
  const WorkPackagePriorityPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final priorities = context
        .read<WorkPackageFormDataCubit>()
        .state
        .value
        .data!
        .options
        .priorities;
    final selectedPriority =
        context.select<WorkPackagePayloadCubit, WPPriority>(
      (cubit) => cubit.state!.priority,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          priorities.length,
          (index) {
            return Padding(
              padding: getScrollableRowPadding(
                context: context,
                index: index,
                listLength: priorities.length,
                marginalPadding: 20,
                itemPadding: 12,
              ),
              child: _WorkPackagePriorityItem(
                priority: priorities[index],
                isSelected: priorities[index].id == selectedPriority.id,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkPackagePriorityItem extends StatelessWidget {
  final WPPriority priority;
  final bool isSelected;
  const _WorkPackagePriorityItem({
    required this.priority,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options =
        context.read<WorkPackageFormDataCubit>().state.value.data!.options;

    const animationDuration = Duration(milliseconds: 400);
    const animationCurve = Curves.fastOutSlowIn;

    final splashColor =
        (isSelected ? AppColors.buttonText : AppColors.primaryText)
            .withAlpha(75);
    final backgroundColor =
        isSelected ? AppColors.button : Colors.grey.withAlpha(20);

    return InkWell(
      onTap: () {
        if (!options.isPriorityWritable) {
          showWarningSnackBar(context, 'Priority can\'t be changed');
          return;
        }

        final payloadCubit = context.read<WorkPackagePayloadCubit>();

        payloadCubit.updatePayload(
          payloadCubit.state!.copyWith(
            priority: Value.present(priority),
          ),
        );
      },
      splashColor: splashColor,
      highlightColor: Colors.transparent, // Removes gray overlay
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: options.isPriorityWritable || isSelected ? 1.0 : 0.5,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve,
          width: 124,
          height: 64,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedSize(
              duration: animationDuration,
              curve: animationCurve,
              child: Row(
                children: [
                  if (isSelected) ...[
                    SvgPicture.asset(
                      AppIcons.flag,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  AnimatedDefaultTextStyle(
                    duration: animationDuration,
                    curve: animationCurve,
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.buttonText
                          : AppColors.primaryText,
                    ),
                    child: Text(priority.name),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
