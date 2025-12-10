import 'package:flutter/material.dart';
import 'package:open_project/core/models/week_day.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/date_range.dart';
import './date_picker_dialog.dart' as custom_date_picker;
import 'package:open_project/core/util/date_format.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? finishDate;
  final void Function(DateTime? startDate, DateTime? finishDate) onChanged;
  final bool enabled;
  final List<WeekDay>? weekDays;
  const DateRangePickerWidget({
    super.key,
    required this.startDate,
    required this.finishDate,
    required this.onChanged,
    this.weekDays,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 800,
      ),
      child: Row(
        spacing: 8,
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
                child: Text(
                  'To',
                  style: AppTextStyles.extraSmall.copyWith(
                    color: AppColors.descriptiveText,
                  ),
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
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: enabled
                        ? () async {
                            final result = await _showDateRangePicker(
                              context: context,
                              startDate: startDate,
                              finishDate: finishDate,
                              weekDays: weekDays,
                            );

                            onChanged(result.startDate, result.finishDate);
                          }
                        : null,
                    child: Ink(
                      height: MediaQuery.textScalerOf(context).scale(132),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.projectBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: enabled ? AppColors.blue100 : AppColors.border,
                          width: 1.5,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DatePickerWidget extends StatelessWidget {
  final DateTime? date;
  final void Function(DateTime? date) onChanged;
  final bool enabled;
  final List<WeekDay>? weekDays;
  final Alignment alignment;
  const DatePickerWidget({
    super.key,
    this.date,
    required this.onChanged,
    this.enabled = true,
    this.weekDays,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Column(
          children: [
            Text(
              'Date',
              style: AppTextStyles.extraSmall.copyWith(
                color: AppColors.descriptiveText,
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: enabled
                  ? () async {
                      final result = await _showDatePicker(
                        context: context,
                        date: date,
                        weekDays: weekDays,
                      );

                      onChanged(result);
                    }
                  : null,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                height: MediaQuery.textScalerOf(context).scale(132),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.projectBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: enabled ? AppColors.blue100 : AppColors.border,
                    width: 1.5,
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
                child: Center(
                  child: Builder(
                    builder: (context) {
                      final formattedDate = getFormattedDate(date);

                      if (formattedDate == null) {
                        final text = () {
                          return enabled ? 'Pick a date' : 'No date selected';
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
          ],
        ),
      ),
    );
  }
}

Future<({DateTime? startDate, DateTime? finishDate})> _showDateRangePicker({
  required BuildContext context,
  required DateTime? startDate,
  required DateTime? finishDate,
  required final List<WeekDay>? weekDays,
}) async {
  final result = await custom_date_picker.showDateRangePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate: DateTime(DateTime.now().year + 100),
    initialDateRange: DateRange(startDate: startDate, endDate: finishDate),
    selectableDayPredicate: weekDays == null
        ? null
        : (day, _, __) {
            return _isAWorkingDay(day, weekDays);
          },
    helpText: 'Set your timeline',
  );

  if (result == null) {
    return (startDate: startDate, finishDate: finishDate);
  }

  return (startDate: result.startDate, finishDate: result.endDate);
}

Future<DateTime?> _showDatePicker({
  required BuildContext context,
  required DateTime? date,
  required final List<WeekDay>? weekDays,
}) async {
  final result = await custom_date_picker.showDatePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate: DateTime(DateTime.now().year + 100),
    initialDate: date,
    selectableDayPredicate: weekDays == null
        ? null
        : (day) {
            return _isAWorkingDay(day, weekDays);
          },
  );

  if (result == null) {
    // Case: Dialog was dismissed
    return date;
  } else if (!result.hasValue) {
    // Case: Intentional null value was passed ('Reset' button)
    return null;
  }

  // Fallback case: dialog was not dismissed, and 'Reset' button was not pressed,
  // meaning the 'Set' button was pressed and a new value exists, i.e. Result is not
  // null, and does have a value
  return result.value;
}

/// Checks if the given date is configured as a working day.
bool _isAWorkingDay(
  DateTime day,
  List<WeekDay> weekDays,
) {
  // 1. Get the standard Dart weekday (1=Mon, 7=Sun)
  final int dartWeekday = day.weekday;

  // Check if the configuration list is ready
  if (weekDays.isEmpty) {
    return true; // Default to all days selectable if config is missing
  }

  // 2. Search the configuration list for the matching day number.
  // Since your API uses the same 1=Monday standard as Dart, we use dartWeekday directly.
  final WeekDay? dayConfig = weekDays.cast<WeekDay?>().firstWhere(
        (config) => config?.position == dartWeekday,
        orElse: () => null,
      );

  // 3. Return the 'working' status.
  // If we found a config, return its status. If not, default to selectable (true).
  return dayConfig?.working ?? true;
}
