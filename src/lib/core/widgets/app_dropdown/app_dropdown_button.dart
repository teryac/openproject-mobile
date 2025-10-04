import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';

class AppDropdownButton extends StatefulWidget {
  final List<String> items;
  final String? value;
  final void Function(String value) onChanged;
  final String hint;
  const AppDropdownButton({
    Key? key,
    required this.items,
    this.value,
    required this.onChanged,
    required this.hint,
  }) : super(key: key);

  @override
  State<AppDropdownButton> createState() => _AppDropdownButtonState();
}

class _AppDropdownButtonState extends State<AppDropdownButton> {
  bool isMenuVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu(
      onMenuToggled: (visible) {
        setState(() {
          isMenuVisible = visible;
        });
      },
      dropdown: true,
      menu: (toggleMenu) {
        return _AppDropdownMenu(
          items: widget.items,
          onChanged: widget.onChanged,
          value: widget.value,
          toggleMenu: toggleMenu,
        );
      },
      child: (toggleMenu) {
        return InkWell(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          splashColor: AppColors.primaryText.withAlpha(50),
          highlightColor: Colors.transparent, // Removes gray overlay
          onTap: () => toggleMenu(true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              bottom: 12,
              top: 6,
              right: 4,
              left: 4,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.value ?? widget.hint,
                    style: AppTextStyles.medium.copyWith(
                      fontWeight: FontWeight.w400,
                      color: widget.value == null
                          ? AppColors.descriptiveText
                          : AppColors.primaryText,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      turns: isMenuVisible ? 0 : 0.5,
                      child: SvgPicture.asset(
                        AppIcons.arrowUp,
                        width: 20,
                        height: 20,
                        // ignore: deprecated_member_use
                        color: AppColors.iconPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppDropdownMenu extends StatefulWidget {
  final List<String> items;
  final String? value;
  final void Function(String value) onChanged;
  final void Function(bool visible) toggleMenu;
  const _AppDropdownMenu({
    required this.items,
    required this.value,
    required this.onChanged,
    required this.toggleMenu,
  });

  @override
  State<_AppDropdownMenu> createState() => _AppDropdownMenuState();
}

class _AppDropdownMenuState extends State<_AppDropdownMenu> {
  bool _disableInteraction = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          children: List.generate(
            widget.items.length,
            (index) {
              final text = widget.items[index];
              final style = AppTextStyles.medium.copyWith(
                fontWeight: FontWeight.w400,
              );
              final selected = widget.items[index] == widget.value;

              onTap() {
                if (_disableInteraction) return;
                widget.onChanged(widget.items[index]);
                _disableInteraction = true;
                widget.toggleMenu(false);
              }

              return Column(
                children: [
                  Builder(
                    builder: (context) {
                      if (index == 0) {
                        return AppMenuItem.first(
                          text: text,
                          style: style,
                          selected: selected,
                          onTap: onTap,
                        );
                      } else if (index == widget.items.length - 1) {
                        return AppMenuItem.last(
                          text: text,
                          style: style,
                          selected: selected,
                          onTap: onTap,
                        );
                      }
                      return AppMenuItem(
                        text: text,
                        style: style,
                        selected: selected,
                        onTap: onTap,
                      );
                    },
                  ),
                  if (index != widget.items.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(
                        height: 0,
                        color: AppColors.border,
                        thickness: 1,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
