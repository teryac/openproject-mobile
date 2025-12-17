import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class WorkPackageInfoTile extends StatelessWidget {
  final String? svgIconAsset;
  final String hint;
  final String? value;
  final Color? valueTileColor;

  /// Custom build when `value` is not null
  final Widget Function(BuildContext context, String value)? valueBuilder;
  const WorkPackageInfoTile({
    super.key,
    this.svgIconAsset,
    required this.hint,
    required this.value,
    this.valueBuilder,
    this.valueTileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            spacing: 8,
            children: [
              if (svgIconAsset != null)
                SvgPicture.asset(
                  svgIconAsset!,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.descriptiveText,
                    BlendMode.srcIn,
                  ),
                ),
              Expanded(
                child: Text(
                  hint,
                  maxLines: 2,
                  style: AppTextStyles.small.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.descriptiveText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: valueTileColor ?? AppColors.searchBarBackground,
              borderRadius: BorderRadius.circular(360),
            ),
            child: (value != null && valueBuilder != null)
                ? valueBuilder!.call(context, value!)
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 24,
                      minWidth: 48,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value ?? 'Not selected',
                          style: AppTextStyles.small.copyWith(
                            fontWeight: FontWeight.w500,
                            color: () {
                              if (valueTileColor != null) {
                                return Colors.white;
                              }

                              if (value != null) {
                                return AppColors.primaryText;
                              }

                              return AppColors.descriptiveText;
                            }(),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
