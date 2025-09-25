import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_chip.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/home/widgets/members_list.dart';
import 'package:open_project/work_packages/widgets/work_packages_popup_menu.dart';

class ReadyWidgetsSheet extends StatelessWidget {
  const ReadyWidgetsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Scaffold(
        floatingActionButton: AppButton(
          text: 'Add Task',
          prefixIcon: SvgPicture.asset(
            AppIcons.task,
            width: 20,
            height: 20,
            // ignore: deprecated_member_use
            color: Colors.white,
          ),
          wrapContent: true,
          onPressed: () {},
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Buttons',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Connect to Server',
                    onPressed: () {},
                    // width: 200,
                    // textStyle: AppTextStyles.extraSmall,
                    // loading: true,
                    // height: 100,
                    // disableTextScaling: true,
                  ),
                  const SizedBox(height: 16),
                  AppButton.white(
                    text: 'Get started',
                    onPressed: () {},
                    blur: true,
                  ),
                  const SizedBox(height: 16),
                  AppTextButton(
                    text: 'How to get API token?',
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppButton.caution(
                    text: 'Log out',
                    onPressed: () {},
                    wrapContent: true,
                    small: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppChipList(
                    chips: [
                      AppChip(
                        text: 'In progress',
                        isSelected: true,
                        onPressed: () {},
                      ),
                      ...List.filled(
                        7,
                        AppChip(
                          text: 'New',
                          isSelected: false,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppMenu(
                    menu: (toggleMenu) {
                      return WorkPackagesPopupMenu(toggleMenu: toggleMenu);
                    },
                    child: (toggleMenu) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        splashColor: AppColors.primaryText.withAlpha(50),
                        highlightColor:
                            Colors.transparent, // Removes gray overlay
                        onLongPress: () => toggleMenu(true),
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: const Center(
                            child: Text("Hold to view menu"),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Text Fields',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  const AppTextFormField(hint: 'URL Link'),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    hint: 'URL Link',
                    disableLabel: true,
                    contentPadding: const EdgeInsets.only(top: 18),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 8,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.border,
                        ),
                        child: Text(
                          'https://',
                          style: AppTextStyles.small.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.highContrastCursor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField.filled(
                    hint: 'Search for Projects..',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: SvgPicture.asset(
                        AppIcons.search,
                        width: 24,
                        height: 24,
                        // ignore: deprecated_member_use
                        color: AppColors.iconSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Miscellaneous',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 160,
                    height: 75,
                    padding: const EdgeInsets.only(left: 24),
                    decoration: BoxDecoration(
                      color: AppColors.projectBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const MembersList(
                      members: [
                        (fullName: 'Majd Haj Hmidi', color: Colors.deepOrange),
                        (fullName: 'Yaman Kalaji', color: Colors.deepPurple),
                        (fullName: 'Shaaban Shaheen', color: Colors.teal),
                        (fullName: 'Test Name', color: Colors.black),
                        (fullName: 'Test Name', color: Colors.red),
                        (fullName: 'Test Name', color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
