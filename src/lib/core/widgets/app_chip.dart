import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/padding_util.dart';
import 'package:open_project/core/widgets/shimmer.dart';

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
        begin: isSelected ? selectedChipColor : disabledChipColor,
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

  /// Used for showing a loading view
  final int? _loadingShimmerCount;
  const AppChipList({super.key, required this.chips})
      : _loadingShimmerCount = null;

  AppChipList.shimmer({super.key})
      : _loadingShimmerCount = 10,
        chips = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // Gives the row clear constraints, which places widgets correctly
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Row(
          children: List.generate(
            _loadingShimmerCount ?? chips.length,
            (index) {
              return Padding(
                padding: getScrollableRowPadding(
                    context: context,
                    index: index,
                    listLength: chips.length,
                    itemPadding: 12,
                    marginalPadding: 28),
                child: Builder(
                  builder: (context) {
                    if (_loadingShimmerCount != null) {
                      return ShimmerBox(
                        width: 64,
                        height: 37,
                        borderRadius: 8,
                      );
                    }

                    return chips[index];
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
