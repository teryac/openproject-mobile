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

  /// Forces a special menu alignment with the menu expanding
  /// from the bottom of the widget when there is space left on
  /// the screen, and the opposite when there's no enough space
  final bool dropdownAlignment;
  const AppPopupMenu({
    super.key,
    required this.child,
    required this.menu,
    this.onMenuToggled,
    this.dropdownAlignment = false,
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
      anchor: const Filled(),
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _toggleMenu(false),
        child: const SizedBox.expand(),
      ),
      child: Builder(
        builder: (context) {
          return PortalTarget(
            visible: _isMenuVisible,
            anchor: Aligned(
              follower: menuAlignment.follower,
              target: menuAlignment.target,
            ),
            portalFollower: Builder(
              builder: (context) {
                return ScaleTransition(
                  scale: _animationController.scale,
                  alignment: () {
                    if (widget.dropdownAlignment) {
                      if (menuAlignment.target == Alignment.topCenter) {
                        return Alignment.bottomCenter;
                      } else {
                        return Alignment.topCenter;
                      }
                    }

                    return Alignment.center;
                  }(),
                  child: widget.menu(_toggleMenu),
                );
              },
            ),
            child: widget.child(_toggleMenu),
          );
        },
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
          width: double.infinity,
          child: Row(
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 12),
              ],
              Text(
                text,
                style: style?.copyWith(
                      color: foregroundColor ?? AppColors.primaryText,
                    ) ??
                    AppTextStyles.extraSmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: foregroundColor ?? AppColors.primaryText,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
