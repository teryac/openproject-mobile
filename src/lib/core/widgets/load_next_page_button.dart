import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';

class LoadNextPageButton extends StatelessWidget {
  final void Function() onTap;
  final bool loading;
  const LoadNextPageButton({
    super.key,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Show more',
              style: AppTextStyles.small.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.descriptiveText,
              ),
            ),
            const SizedBox(width: 8),
            loading
                ? SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      color: AppColors.iconSecondary,
                      strokeWidth: 1.5,
                    ),
                  )
                : SvgPicture.string(
                    // A string is used to change the stroke width
                    """
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M4.08004 8.95011L10.6 15.4701C11.37 16.2401 12.63 16.2401 13.4 15.4701L19.92 8.95011" stroke="#262B2C" stroke-width="2.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    """,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
