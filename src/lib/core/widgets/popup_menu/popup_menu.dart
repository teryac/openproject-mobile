import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/popup_menu/popup_menu_animation.dart';

enum PopupMenuDirection {
  downwards, // Downwards from the top of the widget
  upwards, // Upwards from the top of the widget
  downwardsClipped, // Downwards from the bottom of the widget (for clipped widgets at the top)
}

class AppPopupMenu extends StatefulWidget {
  final Widget Function(void Function(bool) toggleMenu) child;
  final Widget Function(void Function(bool) toggleMenu) menu;
  final void Function(bool visible)? onMenuToggled;

  /// If true, tapping the child when the menu is open will close it.
  /// If false, tapping the child will keep the menu open (useful for TextFields).
  final bool toggleOnChildTap;

  /// Forces a special menu alignment with the menu expanding
  /// from the bottom of the widget when there is space left on
  /// the screen, and the opposite when there's no enough space
  final bool dropdownAlignment;
  final bool enabled;
  const AppPopupMenu({
    super.key,
    required this.child,
    required this.menu,
    this.onMenuToggled,
    this.dropdownAlignment = false,
    this.toggleOnChildTap = true,
    this.enabled = true,
  });

  @override
  State<AppPopupMenu> createState() => _AppPopupMenuState();
}

class _AppPopupMenuState extends State<AppPopupMenu>
    with SingleTickerProviderStateMixin {
  bool _isMenuVisible = false;
  late PopupMenuAnimation _animationController;
  ({Alignment follower, Alignment target}) menuAlignment = (
    // Default Values
    follower: Alignment.topRight,
    target: Alignment.topRight,
  );

  // This is used for TapRegion behavior, it's intended to combine the menu and
  // the child in a group to translate "TapOutside" as "tapping outside both the
  // menu AND the child".
  // We use the State object itself as a unique ID for this specific menu instance
  // to ensure multiple menus on the same screen don't interfere with each other.
  late final Object _regionGroupId = this;

  @override
  void initState() {
    super.initState();

    _animationController = PopupMenuAnimation(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _toggleMenu(bool visible) {
    if (!widget.enabled) return;
    // If the child asks to open (visible == true),
    // but we are ALREADY open, we treat this as a request to close.
    // Also, only close the menu when toggle mode is on, otherwise skip
    // this case (Check toggleOnChildTap parameter documentation)
    if (visible && _isMenuVisible && widget.toggleOnChildTap) {
      visible = false;
    }

    // Measure menu alignment based on scroll position
    setState(() {
      menuAlignment = _getMenuAlignment();
    });

    if (visible) {
      _animationController.forward();
      setState(() {
        _isMenuVisible = visible;
      });
      if (widget.onMenuToggled != null) {
        widget.onMenuToggled!(visible);
      }
    } else {
      _animationController.reverse();

      if (widget.onMenuToggled != null) {
        widget.onMenuToggled!(false);
      }

      Future.delayed(
        _animationController.duration,
        () {
          if (!mounted) return;

          setState(() {
            _isMenuVisible = visible;
          });
        },
      );
    }
  }

  PopupMenuDirection _showMenuDirection() {
    if (!mounted) return PopupMenuDirection.downwards;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      // Default to downwards if render object is not found.
      return PopupMenuDirection.downwards;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenPadding = mediaQuery.viewPadding;

    final widgetPosition = renderBox.localToGlobal(Offset.zero);
    final widgetTopY = widgetPosition.dy;
    final widgetBottomY = widgetPosition.dy + renderBox.size.height;

    // Calculate the usable screen boundaries.
    final screenTop = screenPadding.top;
    final screenBottom = screenSize.height - screenPadding.bottom;
    final usableScreenHeight = screenBottom - screenTop;

    final tolerance = widget.dropdownAlignment ? 0.30 : 0.15;

    // Check if the widget is clipped at the top of the screen.
    final isClippedAtTop = widgetTopY <
        screenTop +
            (usableScreenHeight *
                tolerance); // Use a x% tolerance from the top.

    if (isClippedAtTop) {
      // Case 1: Widget is at the very top and possibly clipped.
      // The menu should show downwards from the top of the widget.
      return PopupMenuDirection.downwardsClipped;
    }

    // Calculate a threshold to determine if there's enough space below.
    final threshold = screenBottom - (usableScreenHeight * tolerance);

    if (widgetBottomY > threshold) {
      // Case 2: Widget is near the bottom of the screen.
      // The menu should show upwards from the top of the widget.
      return PopupMenuDirection.upwards;
    }

    // Case 3: Default case.
    // The menu should show downwards from the bottom of the widget.
    return PopupMenuDirection.downwards;
  }

  ({Alignment follower, Alignment target}) _getMenuAlignment() {
    final menuDirection = _showMenuDirection();

    if (widget.dropdownAlignment) {
      if (menuDirection == PopupMenuDirection.upwards) {
        return (
          follower: Alignment.bottomCenter,
          target: Alignment.topCenter,
        );
      } else {
        return (follower: Alignment.topCenter, target: Alignment.bottomCenter);
      }
    }

    if (menuDirection == PopupMenuDirection.upwards) {
      return (follower: Alignment.bottomRight, target: Alignment.topRight);
    } else if (menuDirection == PopupMenuDirection.downwardsClipped) {
      return (follower: Alignment.topRight, target: Alignment.bottomRight);
    }

    return (follower: Alignment.topRight, target: Alignment.topRight);
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _isMenuVisible,
      anchor: Aligned(
        follower: menuAlignment.follower,
        target: menuAlignment.target,
      ),
      // 1. Wrap the MENU content (in the overlay) with TapRegion
      portalFollower: TapRegion(
        groupId: _regionGroupId,
        // We don't need onTapOutside here because the parent TapRegion covers it,
        // but adding the groupId marks this area as "Safe" (don't close if clicked).
        child: ScaleTransition(
          scale: _animationController.scale,
          alignment: () {
            if (widget.dropdownAlignment) {
              return menuAlignment.target == Alignment.topCenter
                  ? Alignment.bottomCenter
                  : Alignment.topCenter;
            }
            return Alignment.center;
          }(),
          child: widget.menu(_toggleMenu),
        ),
      ),
      // 2. Wrap the TRIGGER button (in the main tree) with TapRegion
      child: TapRegion(
        groupId: _regionGroupId,
        // This callback fires ONLY if you tap outside the button AND outside the menu.
        // Since we do NOT consume the event, the list below will receive the scroll/tap immediately.
        onTapOutside: (event) {
          if (_isMenuVisible) {
            _toggleMenu(false);
          }
        },
        child: widget.child(_toggleMenu),
      ),
    );
  }
}

class AppMenuItem extends StatelessWidget {
  final String text;
  final Widget? icon;
  final TextStyle? style;
  final void Function() onTap;
  final bool selected;
  final Color? foregroundColor;
  final bool _first;
  final bool _last;

  const AppMenuItem({
    super.key,
    this.icon,
    required this.text,
    required this.onTap,
    this.selected = false,
    this.style,
    this.foregroundColor,
  })  : _first = false,
        _last = false;

  const AppMenuItem.first({
    super.key,
    this.icon,
    required this.text,
    required this.onTap,
    this.selected = false,
    this.style,
    this.foregroundColor,
  })  : _first = true,
        _last = false;

  const AppMenuItem.last({
    super.key,
    this.icon,
    required this.text,
    required this.onTap,
    this.selected = false,
    this.style,
    this.foregroundColor,
  })  : _first = false,
        _last = true;

  const AppMenuItem.firstAndLast({
    super.key,
    this.icon,
    required this.text,
    required this.onTap,
    this.selected = false,
    this.style,
    this.foregroundColor,
  })  : _first = true,
        _last = true;

  @override
  Widget build(BuildContext context) {
    const roundedRadius = Radius.circular(8);
    const noRadius = Radius.zero;

    final borderRadius = BorderRadius.only(
      topLeft: _first ? roundedRadius : noRadius,
      topRight: _first ? roundedRadius : noRadius,
      bottomLeft: _last ? roundedRadius : noRadius,
      bottomRight: _last ? roundedRadius : noRadius,
    );

    return Material(
      color: selected ? AppColors.handle.withAlpha(150) : AppColors.background,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: (foregroundColor ?? AppColors.primaryText).withAlpha(50),
        highlightColor: Colors.transparent, // removes the gray overlay
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  text,
                  style: style?.copyWith(
                        color: foregroundColor ?? AppColors.primaryText,
                      ) ??
                      AppTextStyles.extraSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: foregroundColor ?? AppColors.primaryText,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
