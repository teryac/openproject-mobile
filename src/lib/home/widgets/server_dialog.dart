import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';

class ServerDialog extends StatelessWidget {
  const ServerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 20.0, bottom: 24.0),
        color: AppColors.background,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                  color: AppColors.blue100, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  "MH",
                  style: AppTextStyles.small.copyWith(
                      color: AppColors.background, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Column(
              children: [
                Text(
                  "Mohammad Haj Hmidi",
                  style: AppTextStyles.medium.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "mohammadhhmidi23@gmail.com",
                  style: AppTextStyles.extraSmall
                      .copyWith(color: AppColors.descriptiveText),
                ),
              ],
            ),
            const SizedBox(width: 22.0),
            AppButton.caution(
              text: 'Log out',
              onPressed: () {},
              wrapContent: true,
              small: true,
            ),
          ],
        ),
      ),
    );
  }
}
