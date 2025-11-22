import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class WorkPackageDescription extends StatelessWidget {
  const WorkPackageDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      hint: 'Work pacakge description',
      unFocusOnTapOutside: true,
      maxLines: 2,
      initialValue: context.select<WorkPackagePayloadCubit, String>(
        (cubit) => cubit.state!.description.raw,
      ),
      onChanged: (value) {
        final payloadCubit = context.read<WorkPackagePayloadCubit>();
        payloadCubit.updatePayload(
          payloadCubit.state!.copyWith(
            description: Value.present(
              WPDescription(
                format: 'markdown',
                raw: value,
                html: '',
              ),
            ),
          ),
        );
      },
    );
  }
}
