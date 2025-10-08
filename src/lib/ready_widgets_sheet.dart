import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/auth/widgets/server_input_screen/connection_state_widget.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_chip.dart';
import 'package:open_project/core/widgets/app_dropdown/app_dropdown_button.dart';
import 'package:open_project/core/widgets/app_gallery_widget.dart';
import 'package:open_project/core/widgets/app_image.dart';
import 'package:open_project/core/widgets/app_progress_bar.dart';
import 'package:open_project/core/widgets/app_text_field.dart';
import 'package:open_project/core/widgets/bottom_tab_bar.dart';
import 'package:open_project/core/widgets/date_picker/date_picker_widget.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/home/widgets/members_list.dart';
import 'package:open_project/work_packages/widgets/work_packages_popup_menu.dart';

class ReadyWidgetsSheet extends StatefulWidget {
  const ReadyWidgetsSheet({super.key});

  @override
  State<ReadyWidgetsSheet> createState() => _ReadyWidgetsSheetState();
}

class _ReadyWidgetsSheetState extends State<ReadyWidgetsSheet> {
  double progressBarValue = 0;
  int tabBarIndex = 0;
  bool isConnected = false;
  String? selectedMember;
  DateTime? startDate;
  DateTime? finishDate;
  static const List<String> members = [
    'Yaman Kalaji',
    'Shaaban Shaheen',
    'Majd Haj Hmidi',
    'Mohammad Haj Hmidi',
  ];

  void changeProgressBarValue(double value) {
    setState(() {
      progressBarValue = value;
    });
  }

  void changeTabBarIndex(int index) {
    setState(() {
      tabBarIndex = index;
    });
  }

  void toggleConnection() {
    setState(() {
      isConnected = !isConnected;
    });
  }

  void changeSelectedMember(String member) {
    setState(() {
      selectedMember = member;
    });
  }

  void changeDateRange(DateTime? startDate, DateTime? finishDate) {
    setState(() {
      this.startDate = startDate;
      this.finishDate = finishDate;
    });
  }

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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  AppPopupMenu(
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
                  AppDropdownButton(
                    items: members,
                    value: selectedMember,
                    hint: 'Accountable',
                    onChanged: changeSelectedMember,
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
                    'Page View',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  AppGalleryWidget(
                    itemCount: 3,
                    itemBuilder: (index) {
                      final instruction = AppConstants.getApiTokenInstructions(index);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio:
                                1.423, // Based on aspect ratio of used images
                            child: AppAssetImage(
                              assetPath: AppImages.howToGetApiToken(index + 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            instruction.title,
                            style: AppTextStyles.medium.copyWith(
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            instruction.body,
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.descriptiveText,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Date Picker',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  DatePickerWidget(
                    startDate: startDate,
                    finishDate: finishDate,
                    onChanged: changeDateRange,
                    // enabled: false,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tab Bar',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    children: [
                      AppNetworkImage(
                        imageUrl:
                            'https://images.photowall.com/products/42556/summer-landscape-with-river.jpg?h=699&q=85',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 16,
                        left: 16,
                        child: Align(
                          alignment: Alignment.center,
                          child: BottomTabBar(
                            index: tabBarIndex,
                            items: const [
                              'Overview',
                              'People',
                              'Schedule',
                              'Properties',
                            ],
                            onTap: changeTabBarIndex,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Progress Bar',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  AppProgressBar(
                    value: progressBarValue,
                    onChanged: changeProgressBarValue,
                    // showDivisions: false,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Miscellaneous',
                    style: AppTextStyles.extraLarge,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: toggleConnection,
                    child: ConnectionStateWidget(
                      connected: isConnected,
                    ),
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
                  const SizedBox(height: 24),
                  Stack(
                    children: [
                      AppAssetImage(
                        assetPath: AppImages.emp,
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      Positioned(
                        top: 20,
                        right: 0,
                        left: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(360),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color: const Color(0x99262B2C),
                                ),
                                child: const SizedBox(
                                  width: 140,
                                  height: 45,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0x99262B2C),
                              ),
                              child: const SizedBox(
                                width: double.infinity,
                                height: 205,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
