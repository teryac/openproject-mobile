import 'package:flutter/material.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class WorkPackageDescription extends StatelessWidget {
  const WorkPackageDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTextFormField(
      hint: 'Task Description',
      maxLines: 2,
    );
  }
}
