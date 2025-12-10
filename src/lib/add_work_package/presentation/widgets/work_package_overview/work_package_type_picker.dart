import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/models/value.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/app_snackbar.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';

class WorkPackageTypePicker extends StatelessWidget {
  const WorkPackageTypePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final options =
        context.read<WorkPackageFormDataCubit>().state.value.data!.options;
    final selectedType = context.read<WorkPackagePayloadCubit>().state!.type;
    final types = options.types;
    types.remove(selectedType);

    return AppPopupMenu(
      dropdownAlignment: true,
      enabled: options.isTypeWritable,
      onTap: options.isTypeWritable
          ? null
          : () {
              showWarningSnackBar(context, 'Type can\'t be changed');
            },
      menu: (toggleMenu) {
        return Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 14,
                offset: Offset(0, 49),
                color: Color(0x00363636),
              ),
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 31),
                color: Color(0x03363636),
              ),
              BoxShadow(
                blurRadius: 11,
                offset: Offset(0, 18),
                color: Color(0x0A363636),
              ),
              BoxShadow(
                blurRadius: 8,
                offset: Offset(0, 8),
                color: Color(0x12363636),
              ),
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 2),
                color: Color(0x14363636),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: IntrinsicWidth(
                child: Column(
                  children: List.generate(
                    types.length,
                    (index) {
                      final typeColor =
                          HexColor(types[index].colorHex).getReadableColor();
                      final content = Material(
                        color: typeColor.withAlpha(38),
                        borderRadius: BorderRadius.circular(360),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(360),
                          highlightColor:
                              Colors.transparent, // Removes gray overlay
                          splashColor: typeColor.withAlpha(75),
                          onTap: () {
                            final formCubit =
                                context.read<WorkPackageFormDataCubit>();
                            final payloadCubit =
                                context.read<WorkPackagePayloadCubit>();

                            payloadCubit
                                .updatePayload(payloadCubit.state!.copyWith(
                              type: Value.present(
                                types[index],
                              ),
                            ));
                            formCubit.getWorkPackageForm(
                              context: context,
                              workPackageType: types[index],
                            );

                            toggleMenu(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: Text(
                              types[index].name,
                              style: AppTextStyles.small.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: typeColor,
                              ),
                            ),
                          ),
                        ),
                      );

                      const divider = Divider(
                        height: 16,
                        color: AppColors.border,
                        thickness: 1,
                      );

                      // If last widget, don't put a divider at the end
                      if (index == types.length - 1) {
                        return content;
                      }

                      return Column(
                        children: [content, divider],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: (toggleMenu) {
        final typeColor = HexColor(selectedType.colorHex).getReadableColor();
        return Material(
          color: typeColor.withAlpha(38),
          borderRadius: BorderRadius.circular(360),
          child: InkWell(
            borderRadius: BorderRadius.circular(360),
            highlightColor: Colors.transparent, // Removes gray overlay
            splashColor: typeColor.withAlpha(75),
            onTap: () {
              toggleMenu(true);
            },
            child: Container(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                right: 12,
                left: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
              ),
              child: Row(
                children: [
                  Text(
                    selectedType.name,
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                      color: typeColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AppIcons.arrowDown,
                    width: 12,
                    height: 12,
                    colorFilter: ColorFilter.mode(
                      typeColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
