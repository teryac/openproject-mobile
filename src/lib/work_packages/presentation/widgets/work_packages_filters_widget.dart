import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/app_chip.dart';

class WorkPackagesFiltersWidget extends StatelessWidget {
  const WorkPackagesFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppChipList(
      chips: [
        AppChip(
          text: 'In progress',
          isSelected: true,
          onPressed: () {},
        ),
        ...List.filled(
          7,
          AppChip(
            text: 'New',
            isSelected: false,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
