import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/duration_extension.dart';

class AppProgressBar extends StatelessWidget {
  /// Values range from 0 to 1
  final double value;

  /// When null, the progress bar will be disabled (small
  /// changes applied to widget appearance)
  final void Function(double value)? onChanged;
  final bool showDivisions;
  const AppProgressBar({
    super.key,
    required this.value,
    this.onChanged,
    this.showDivisions = false,
  });

  @override
  Widget build(BuildContext context) {
    const trackHeight = 20.0;
    const inactiveTrackColor = AppColors.lowContrastCursor;
    const thumbColor = AppColors.background;
    const activeTrackColor = AppColors.highContrastCursor;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 7, left: 7, right: 7, bottom: 7),
          decoration: BoxDecoration(
            color: inactiveTrackColor,
            borderRadius: BorderRadius.circular(360),
          ),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: trackHeight,
              thumbColor: thumbColor,
              activeTrackColor: activeTrackColor,
              inactiveTrackColor: inactiveTrackColor,
              disabledActiveTrackColor: activeTrackColor,
              disabledInactiveTrackColor: inactiveTrackColor,
              padding: const EdgeInsets.all(0),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6,
                disabledThumbRadius: 0,
                elevation: 0,
              ),
              tickMarkShape: SliderTickMarkShape.noTickMark,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
              divisions: showDivisions ? 4 : null,
            ),
          ),
        ),
        if (showDivisions) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (index) {
                final snapValue = index * 25; // 0, 25, 50, 75, 100
                final bool isSelected = (snapValue / 100) == value;

                final selectedTextStyle = AppTextStyles.medium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                );
                final unSelectedTextStyle = AppTextStyles.small.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.descriptiveText,
                );

                return AnimatedDefaultTextStyle(
                  style: isSelected ? selectedTextStyle : unSelectedTextStyle,
                  duration: 300.ms,
                  curve: Curves.easeIn,
                  child: Text(
                    '$snapValue',
                    strutStyle: StrutStyle(
                      forceStrutHeight: true,
                      height: selectedTextStyle.height,
                      fontSize: selectedTextStyle.fontSize,
                    ),
                  ),
                );
              },
            ),
          ),
        ]
      ],
    );
  }
}
