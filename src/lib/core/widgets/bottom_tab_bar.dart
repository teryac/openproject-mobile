import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/util/text_util.dart';

const _animationDuration = Duration(milliseconds: 300);
const _animationCurve = Curves.fastOutSlowIn;

class BottomTabBar extends StatefulWidget {
  final int index;
  final List<String> items;
  final void Function(int index) onTap;
  const BottomTabBar({
    super.key,
    required this.index,
    required this.items,
    required this.onTap,
  });

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int? tappedIndex;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(360),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: LayoutBuilder(
            builder: (context, outerConstraints) {
              final tabBarWidth = outerConstraints.maxWidth;
              final itemWidth = tabBarWidth / widget.items.length;
      
              return GestureDetector(
                onTapDown: (details) {
                  final localOffset = details.localPosition;
                  final tappedIndex = (localOffset.dx ~/ itemWidth)
                      .clamp(0, widget.items.length - 1); // safe bounds
      
                  setState(() {
                    this.tappedIndex = tappedIndex;
                  });
                },
                onTap: () {
                  if (tappedIndex != null) {
                    widget.onTap(tappedIndex!);
      
                    tappedIndex = null;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 12,
                    left: 12,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x26949EA1),
                    border: Border.all(
                      color: const Color(0x80EEF2F2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(360),
                  ),
                  child: LayoutBuilder(
                    builder: (context, innerConstraints) {
                      final tabBarWidth = innerConstraints.maxWidth;
                      final itemWidth = tabBarWidth / widget.items.length;
                      final dotIndicatorOffset = Offset(
                        (itemWidth * widget.index) +
                            itemWidth / 2, // Centers the dot in the middle
                        0,
                      );
      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: List.generate(
                              widget.items.length,
                              (rowIndex) {
                                final isSelected = widget.index == rowIndex;
      
                                // Calculating child size is important to
                                // normalize offset values
                                final text = widget.items[rowIndex];
                                final unSelectedStyle =
                                    AppTextStyles.extraSmall.copyWith(
                                  color: AppColors.primaryText,
                                  height: 1.5,
                                );
                                final selectedStyle =
                                    AppTextStyles.small.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w500,
                                );
                                final textSize = calculateTextSize(
                                  context: context,
                                  text: widget.items[rowIndex],
                                  style: unSelectedStyle,
                                  maxWidth: itemWidth,
                                );
      
                                final selectedOffset = Offset(
                                  0,
                                  -2 // 4 Pixels Up
                                      /
                                      textSize.height,
                                );
                                final unSelectedOffset = Offset(
                                  0,
                                  4 // 4 Pixels Down
                                      /
                                      textSize.height,
                                );
      
                                return Expanded(
                                  flex: 1,
                                  child: AnimatedSlide(
                                    offset: isSelected
                                        ? selectedOffset
                                        : unSelectedOffset,
                                    duration: _animationDuration,
                                    curve: _animationCurve,
                                    child: AnimatedDefaultTextStyle(
                                      duration: _animationDuration,
                                      curve: _animationCurve,
                                      style: isSelected
                                          ? selectedStyle
                                          : unSelectedStyle,
                                      child: Text(
                                        text,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        strutStyle: StrutStyle(
                                          forceStrutHeight: true,
                                          height: isSelected
                                              ? selectedStyle.height
                                              : unSelectedStyle.height,
                                          fontSize: isSelected
                                              ? selectedStyle.fontSize
                                              : unSelectedStyle.fontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 4),
                          _DotIndicator(
                            offset: dotIndicatorOffset,
                          )
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final Offset offset;
  const _DotIndicator({required this.offset});

  @override
  Widget build(BuildContext context) {
    const dotRadius = 4.0;

    final normalizedOffset = Offset(
      offset.dx / dotRadius,
      offset.dy / dotRadius,
    );

    return AnimatedSlide(
      offset: normalizedOffset,
      duration: _animationDuration,
      curve: _animationCurve,
      child: Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}
