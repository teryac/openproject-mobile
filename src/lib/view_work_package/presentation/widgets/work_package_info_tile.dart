import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class WorkPackageInfoTile extends StatelessWidget {
  final String? svgIconAsset;
  final String hint;
  final String? value;

  /// Custom build when `value` is not null
  final Widget Function(BuildContext context, String value)? valueBuilder;
  const WorkPackageInfoTile({
    super.key,
    this.svgIconAsset,
    required this.hint,
    required this.value,
    this.valueBuilder,
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
                    color: AppColors.descriptiveText,
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.searchBarBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: (value != null && valueBuilder != null)
                ? valueBuilder!.call(context, value!)
                : Text(
                    value ?? 'Not selected',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                      color: value == null
                          ? AppColors.descriptiveText
                          : AppColors.primaryText,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
