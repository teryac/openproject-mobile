import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/padding_util.dart';

class WorkPackageStatusPicker extends StatelessWidget {
  final List<({String name, String colorHex})> statusList;
  const WorkPackageStatusPicker({
    super.key,
    required this.statusList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          statusList.length,
          (index) {
            return Padding(
              padding: getScrollableRowPadding(
                context: context,
                index: index,
                listLength: statusList.length,
                marginalPadding: 20,
                itemPadding: 12,
              ),
              child: _WorkPackageStatusItem(
                name: statusList[index].name,
                colorHex: statusList[index].colorHex,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkPackageStatusItem extends StatelessWidget {
  final String name;
  final String colorHex;
  const _WorkPackageStatusItem({
    required this.name,
    required this.colorHex,
  });

  @override
  Widget build(BuildContext context) {
    final color = HexColor(colorHex);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: AppTextStyles.small.copyWith(
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
