import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';

class WorkPackageTypePicker extends StatelessWidget {
  const WorkPackageTypePicker({super.key});

  @override
  Widget build(BuildContext context) {
    const color = AppColors.blue100;
    final List<({String name, String colorHex})> workPackagesTypes = [
      (name: 'Task', colorHex: '#2392D4'),
      (name: 'Milestone', colorHex: '#2EAC5D'),
      (name: 'Phase', colorHex: '#A89F39'),
    ];

    return AppPopupMenu(
      dropdownAlignment: true,
      menu: (toggleMenu) {
        return Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 14,
                offset: Offset(0, 49),
                color: Color(0x00363636),
              ),
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 31),
                color: Color(0x03363636),
              ),
              BoxShadow(
                blurRadius: 11,
                offset: Offset(0, 18),
                color: Color(0x0A363636),
              ),
              BoxShadow(
                blurRadius: 8,
                offset: Offset(0, 8),
                color: Color(0x12363636),
              ),
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 2),
                color: Color(0x14363636),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: IntrinsicWidth(
                child: Column(
                  children: List.generate(
                    workPackagesTypes.length,
                    (index) {
                      final content = Material(
                        color: HexColor(
                          workPackagesTypes[index].colorHex,
                        ).withAlpha(38),
                        borderRadius: BorderRadius.circular(360),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(360),
                          highlightColor:
                              Colors.transparent, // Removes gray overlay
                          splashColor: HexColor(
                            workPackagesTypes[index].colorHex,
                          ).withAlpha(75),
                          onTap: () {
                            toggleMenu(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: Text(
                              workPackagesTypes[index].name,
                              style: AppTextStyles.small.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: HexColor(
                                  workPackagesTypes[index].colorHex,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                      const divider = Divider(
                        height: 16,
                        color: AppColors.border,
                        thickness: 1,
                      );

                      // If last widget, don't put a divider at the end
                      if (index == workPackagesTypes.length - 1) {
                        return content;
                      }

                      return Column(
                        children: [content, divider],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: (toggleMenu) {
        return Material(
          color: color.withAlpha(38),
          borderRadius: BorderRadius.circular(360),
          child: InkWell(
            borderRadius: BorderRadius.circular(360),
            highlightColor: Colors.transparent, // Removes gray overlay
            splashColor: color.withAlpha(75),
            onTap: () => toggleMenu(true),
            child: Container(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                right: 12,
                left: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
              ),
              child: Row(
                children: [
                  Text(
                    'Task',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AppIcons.arrowDown,
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                      color,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
