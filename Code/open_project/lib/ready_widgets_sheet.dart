import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_chip.dart';
import 'package:open_project/core/widgets/popup_menu.dart';
import 'package:open_project/work_packages/widgets/work_packages_popup_menu.dart';

class ReadyWidgetsSheet extends StatelessWidget {
  const ReadyWidgetsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(
                  height: 16,
                ),
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
                AppMenu(menu: (toggleMenu) {
                  return WorkPackagesPopupMenu(toggleMenu: toggleMenu);
                }, child: (toggleMenu) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
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
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
