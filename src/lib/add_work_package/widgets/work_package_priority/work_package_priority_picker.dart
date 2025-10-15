import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/padding_util.dart';

class WorkPackagePriorityPicker extends StatelessWidget {
  final List<String> priorityList;
  const WorkPackagePriorityPicker({
    super.key,
    required this.priorityList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          priorityList.length,
          (index) {
            return Padding(
              padding: getScrollableRowPadding(
                context: context,
                index: index,
                listLength: priorityList.length,
                marginalPadding: 20,
                itemPadding: 12,
              ),
              child: _WorkPackagePriorityItem(
                name: priorityList[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkPackagePriorityItem extends StatelessWidget {
  final String name;
  const _WorkPackagePriorityItem({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      height: 64,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.projectBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          name,
          style: AppTextStyles.small.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }
}
