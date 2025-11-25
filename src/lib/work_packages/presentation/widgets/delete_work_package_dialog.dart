import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';

class DeleteWorkPackageDialog extends StatelessWidget {
  final void Function() onConfirmed;
  const DeleteWorkPackageDialog({
    super.key,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete work package',
              style: AppTextStyles.large.copyWith(
                color: AppColors.primaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This step is irreversible, by deleting the work package you can not retrieve it, are you sure you want to proceed with the deletion?',
              style: AppTextStyles.small.copyWith(
                color: AppColors.descriptiveText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: AppColors.primaryText.withAlpha(38),
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.extraSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.descriptiveText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                AppButton.caution(
                  text: 'Delete',
                  small: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  wrapContent: true,
                  onPressed: () {
                    onConfirmed();
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
