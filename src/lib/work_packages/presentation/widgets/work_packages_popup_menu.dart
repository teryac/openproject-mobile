import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';

class WorkPackagesPopupMenu extends StatefulWidget {
  final void Function(bool visible) toggleMenu;
  const WorkPackagesPopupMenu({super.key, required this.toggleMenu});

  @override
  State<WorkPackagesPopupMenu> createState() => _WorkPackagesPopupMenuState();
}

class _WorkPackagesPopupMenuState extends State<WorkPackagesPopupMenu> {
  bool _disableInteraction = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(8),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppMenuItem.first(
              icon: SvgPicture.asset(
                AppIcons.edit,
                // ignore: deprecated_member_use
                color: AppColors.primaryText,
              ),
              text: "Edit task",
              onTap: () {
                if (_disableInteraction) return;

                debugPrint('0');

                _disableInteraction = true;
                widget.toggleMenu(false);
              },
            ),
            AppMenuItem(
              icon: SvgPicture.asset(
                AppIcons.task,
                // ignore: deprecated_member_use
                color: AppColors.primaryText,
              ),
              text: "Mark as finished",
              onTap: () {
                if (_disableInteraction) return;

                debugPrint('1');

                _disableInteraction = true;
                widget.toggleMenu(false);
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                height: 0,
                color: AppColors.border,
                thickness: 1,
              ),
            ),
            AppMenuItem.last(
              icon: SvgPicture.asset(
                AppIcons.trash,
                // ignore: deprecated_member_use
                color: AppColors.red,
              ),
              text: "Delete task",
              foregroundColor: Colors.red,
              onTap: () {
                if (_disableInteraction) return;

                debugPrint('2');

                _disableInteraction = true;
                widget.toggleMenu(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
