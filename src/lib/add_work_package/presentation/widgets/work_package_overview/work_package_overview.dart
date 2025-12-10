import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/add_work_package/presentation/widgets/work_package_overview/work_package_type_picker.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/widgets/app_text_field.dart';

class WorkPackageOverview extends StatelessWidget {
  const WorkPackageOverview({super.key});
  @override
  Widget build(BuildContext context) {
    final options =
        context.read<WorkPackageFormDataCubit>().state.value.data!.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work package overview',
          style: AppTextStyles.large.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            WorkPackageTypePicker(),
            SizedBox(width: 12),
            Expanded(
              child: AppTextFormField(
                hint: 'Work Package title',
                initialValue: context.select<WorkPackagePayloadCubit, String>(
                  (cubit) => cubit.state!.subject,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A name must be provided';
                  }

                  return null;
                },
                readOnly: !options.isSubjectWritable,
                onTap: options.isSubjectWritable
                    ? null
                    : () {
                        showWarningSnackBar(
                            context, 'Title can\'t be changed');
                      },
                onChanged: (value) {
                  final payloadCubit = context.read<WorkPackagePayloadCubit>();
                  payloadCubit.updatePayload(
                    payloadCubit.state!.copyWith(
                      subject: Value.present(value),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
