import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import './date_picker_dialog.dart' as custom_date_picker;
import 'package:open_project/core/util/date_format.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? finishDate;
  final void Function(DateTime? startDate, DateTime? finishDate) onChanged;
  final bool enabled;
  const DatePickerWidget({
    super.key,
    required this.startDate,
    required this.finishDate,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: enabled ? 800 : 600,
      ),
      child: Row(
        spacing: enabled ? 8 : 0,
        children: List.generate(
          3,
          (index) {
            // Item Separator
            if (index == 1) {
              return Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.textScalerOf(context).scale(13)
                      // 13 pixels with the device text scale modifier
                      // this refers to the 'Start/Finish Date' text
                      // widget above the date boxes
                      +
                      4
                  // This is the space between the previous text
                  // And the date box

                  // This behavior is intended to place the current
                  // widget right at the center between the boxes
                  ,
                ),
                child: enabled
                    ? Text(
                        'To',
                        style: AppTextStyles.extraSmall.copyWith(
                          color: AppColors.descriptiveText,
                        ),
                      )
                    : Container(
                        width: 28,
                        height: 8,
                        color: AppColors.projectBackground,
                      ),
              );
            }

            return Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    index == 0 ? 'Start date' : 'Finish date',
                    style: AppTextStyles.extraSmall.copyWith(
                      color: AppColors.descriptiveText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Material(
                    color: AppColors.projectBackground,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: enabled
                          ? () async {
                              final result = await _showDateRangePicker(
                                context: context,
                                startDate: startDate,
                                finishDate: finishDate,
                              );

                              onChanged(result.startDate, result.finishDate);
                            }
                          : null,
                      child: Container(
                        height: MediaQuery.textScalerOf(context).scale(
                          enabled ? 132 : 104,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: enabled
                              ? Border.all(
                                  color: AppColors.blue100,
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Builder(
                            builder: (context) {
                              final formattedDate = getFormattedDate(
                                index == 0 ? startDate : finishDate,
                              );

                              if (formattedDate == null) {
                                final text = () {
                                  if (!enabled) {
                                    if (index == 0) {
                                      return 'No start date';
                                    } else {
                                      return 'No finish date';
                                    }
                                  }
                                  return 'Pick a date';
                                }();

                                return Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.small.copyWith(
                                    color: enabled
                                        ? AppColors.blue100
                                        : AppColors.descriptiveText,
                                  ),
                                );
                              }

                              return Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: formattedDate.day,
                                      style: AppTextStyles.large.copyWith(
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${formattedDate.daySuffix} ',
                                      style: AppTextStyles.small.copyWith(
                                        color: AppColors.descriptiveText,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${formattedDate.month}, ${formattedDate.year}',
                                      style: AppTextStyles.large.copyWith(
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<({DateTime? startDate, DateTime? finishDate})> _showDateRangePicker({
  required BuildContext context,
  required DateTime? startDate,
  required DateTime? finishDate,
}) async {
  final result = await custom_date_picker.showDateRangePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate: DateTime(DateTime.now().year + 100),
    initialDateRange: (startDate != null && finishDate != null)
        ? DateTimeRange(start: startDate, end: finishDate)
        : null,
    helpText: 'Set your timeline',
  );

  if (result == null) {
    return (startDate: startDate, finishDate: finishDate);
  }

  return (startDate: result.start, finishDate: result.end);
}
