import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class AppChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function() onPressed;
  const AppChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const selectedChipColor = AppColors.button;
    const selectedTextColor = AppColors.buttonText;
    const disabledChipColor = AppColors.projectBackground;
    const disabledTextColor = AppColors.primaryText;

    const animationDuration = Duration(milliseconds: 300);
    const animationCurve = Curves.fastOutSlowIn;

    return TweenAnimationBuilder(
      duration: animationDuration,
      curve: animationCurve,
      tween: ColorTween(
        begin: isSelected ? disabledChipColor : selectedChipColor,
        end: isSelected ? selectedChipColor : disabledChipColor,
      ),
      builder: (context, animatedColor, child) {
        return Material(
          borderRadius: BorderRadius.circular(8),
          color: animatedColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            splashColor: isSelected
                ? selectedTextColor.withAlpha(50)
                : disabledTextColor.withAlpha(50),
            highlightColor: Colors.transparent, // removes the gray overlay
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: animationDuration,
                    curve: animationCurve,
                    style: AppTextStyles.extraSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? selectedTextColor : disabledTextColor),
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppChipList extends StatelessWidget {
  final List<AppChip> chips;
  const AppChipList({super.key, required this.chips});

  // For LTR locales, the first element has a 32px left padding, while RTL only 8, and the opposite for right padding
  // Same goes for the last element
  EdgeInsets getItemPadding(BuildContext context, int index, int listLength) {
    if (index == 0) {
      return const EdgeInsets.only(
        left: 20,
        right: 12,
      );
    } else if (index == listLength - 1) {
      return const EdgeInsets.only(
        right: 20,
        left: 12,
      );
    }

    return const EdgeInsets.only(right: 12, left: 12);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          chips.length,
          (index) {
            return Padding(
              padding: getItemPadding(context, index, chips.length),
              child: chips[index],
            );
          },
        ),
      ),
    );
  }
}
