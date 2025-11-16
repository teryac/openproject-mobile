import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_dropdown/app_dropdown_button.dart';

class WorkPackageProperties extends StatelessWidget {
  const WorkPackageProperties({super.key});

  @override
  Widget build(BuildContext context) {
    final versions = context
        .read<WorkPackageFormDataCubit>()
        .state
        .value
        .data!
        .options
        .versions;
    final selectedVersion = context.select<WorkPackagePayloadCubit, WPVersion?>(
      (cubit) => cubit.state!.version,
    );
    final categories = context
        .read<WorkPackageFormDataCubit>()
        .state
        .value
        .data!
        .options
        .categories;
    final selectedCategory =
        context.select<WorkPackagePayloadCubit, WPCategory?>(
      (cubit) => cubit.state!.category,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Package Properties',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        Builder(
          builder: (context) {
            return AppDropdownButton(
              hint: 'Version',
              values: versions,
              value: selectedVersion,
              titles: versions.map((version) => version.name).toList(),
              title: selectedVersion?.name,
              onChanged: (value) {
                final payloadCubit = context.read<WorkPackagePayloadCubit>();
                payloadCubit.updatePayload(
                  payloadCubit.state!.copyWith(
                    version: Value.present(value),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Builder(
          builder: (context) {
            return AppDropdownButton(
              hint: 'Category',
              values: categories,
              value: selectedCategory,
              titles: categories.map((category) => category.name).toList(),
              title: selectedCategory?.name,
              onChanged: (value) {
                final payloadCubit = context.read<WorkPackagePayloadCubit>();
                payloadCubit.updatePayload(
                  payloadCubit.state!.copyWith(
                    category: Value.present(value),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
