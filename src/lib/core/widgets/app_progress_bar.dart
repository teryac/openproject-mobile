import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/duration_extension.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final void Function(double value) onChanged;
  final bool showDivisions;
  const AppProgressBar({
    super.key,
    required this.value,
    required this.onChanged,
    this.showDivisions = true,
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
          // `Slider` enforces some padding at the top more than the bottom
          padding: const EdgeInsets.only(top: 5, left: 4, right: 4, bottom: 4),
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
              padding: const EdgeInsets.all(0),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6,
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
