import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
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
    const animationDuration = Duration(milliseconds: 400);
    const animationCurve = Curves.fastOutSlowIn;
    return InkWell(
      onTap: () {
        final payloadCubit = context.read<WorkPackagePayloadCubit>();

        payloadCubit.updatePayload(
          payloadCubit.state!.copyWith(
            priority: Value.present(priority),
          ),
        );
      },
      splashColor: (isSelected ? AppColors.buttonText : AppColors.primaryText)
          .withAlpha(75),
      highlightColor: Colors.transparent, // Removes gray overlay
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: animationDuration,
        curve: animationCurve,
        width: 102,
        height: 64,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.button : AppColors.projectBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: AnimatedDefaultTextStyle(
            duration: animationDuration,
            curve: animationCurve,
            style: AppTextStyles.small.copyWith(
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.buttonText : AppColors.primaryText,
            ),
            child: Text(priority.name),
          ),
        ),
      ),
    );
  }
}
