import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_progress_bar.dart';

class WorkPackageProgress extends StatelessWidget {
  const WorkPackageProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.select<WorkPackagePayloadCubit, int>(
      (cubit) => cubit.state!.percentageDone,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Progress ',
                style: AppTextStyles.medium.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              TextSpan(
                text: '(%)',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.descriptiveText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppProgressBar(
          value: progress / 100,
          onChanged: (value) {
            final payloadCubit = context.read<WorkPackagePayloadCubit>();

            payloadCubit.updatePayload(
              payloadCubit.state!.copyWith(
                percentageDone: Value.present(
                  (value * 100).toInt(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
