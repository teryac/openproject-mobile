import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu.dart';
import 'package:open_project/core/widgets/shimmer.dart';

class AppDropdownButton extends StatefulWidget {
  final List<dynamic> values;
  final List<String> titles;
  final dynamic value;
  final String? title;
  final void Function(dynamic value) onChanged;
  final String hint;
  final bool loading;
  final void Function()? onMenuToggled;
  // Not shown when null
  final Widget Function(BuildContext context)? errorBuilder;
  final String emptyListMessage;
  const AppDropdownButton({
    super.key,
    required this.title,
    required this.values,
    required this.titles,
    this.value,
    required this.onChanged,
    required this.hint,
    this.onMenuToggled,
    this.loading = false,
    this.errorBuilder,
    this.emptyListMessage = 'No items found',
  });

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
        widget.onMenuToggled?.call();
      },
      dropdownAlignment: true,
      menu: (toggleMenu) {
        return _AppDropdownMenu(
          hint: widget.hint,
          values: widget.values,
          titles: widget.titles,
          onChanged: (value) => widget.onChanged(value),
          value: widget.value,
          toggleMenu: toggleMenu,
          loading: widget.loading,
          errorBuilder: widget.errorBuilder,
          emptyListMessage: widget.emptyListMessage,
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
                    widget.title ?? widget.hint,
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
  final String hint;
  final List<String> titles;
  final dynamic value;
  final List<dynamic> values;
  final void Function(dynamic value) onChanged;
  final void Function(bool visible) toggleMenu;
  final bool loading;
  final Widget Function(BuildContext context)? errorBuilder;
  final String emptyListMessage;
  const _AppDropdownMenu({
    required this.hint,
    required this.values,
    required this.titles,
    required this.value,
    required this.onChanged,
    required this.toggleMenu,
    this.loading = false,
    this.errorBuilder,
    required this.emptyListMessage,
  });

  @override
  State<_AppDropdownMenu> createState() => _AppDropdownMenuState();
}

class _AppDropdownMenuState extends State<_AppDropdownMenu> {
  bool _disableInteraction = false;

  @override
  Widget build(BuildContext context) {
    final values = [null, ...widget.values];
    final titles = [widget.hint, ...widget.titles];

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
        child: Builder(
          builder: (context) {
            if (widget.loading) {
              return Align(
                heightFactor: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      2,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: ShimmerBox(
                            width: double.infinity,
                            height: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }

            if (widget.errorBuilder != null) {
              return Align(
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: widget.errorBuilder!(context),
                ),
              );
            }

            if (widget.titles.isEmpty) {
              return Align(
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    widget.emptyListMessage,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.descriptiveText,
                    ),
                  ),
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                titles.length,
                (index) {
                  final text = titles[index];
                  final style = AppTextStyles.medium.copyWith(
                    fontWeight: FontWeight.w400,
                  );
                  final selected = values[index] == widget.value;

                  onTap() {
                    if (_disableInteraction) return;
                    widget.onChanged(values[index]);
                    _disableInteraction = true;
                    widget.toggleMenu(false);
                  }

                  return Column(
                    children: [
                      Builder(
                        builder: (context) {
                          if (index == 0) {
                            // First item is the default hint, which
                            // sets the value to null
                            return AppMenuItem.first(
                              text: text,
                              style: style,
                              foregroundColor: AppColors.descriptiveText,
                              selected: selected,
                              onTap: onTap,
                            );
                          } else if (index == titles.length - 1) {
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
                      if (index != titles.length - 1)
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
            );
          },
        ),
      ),
    );
  }
}
