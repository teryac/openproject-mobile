import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:open_project/core/styles/text_styles.dart';

class AppMenu extends StatefulWidget {
  final Widget Function(void Function(bool) toggleMenu) child;
  final Widget Function(void Function(bool) toggleMenu) menu;
  const AppMenu({super.key, required this.child, required this.menu});

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  bool _isMenuVisible = false;

  void _toggleMenu(bool visible) {
    setState(() {
      _isMenuVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: PortalTarget(
        visible: _isMenuVisible,
        anchor: const Aligned(
          follower: Alignment.topLeft,
          target: Alignment.topCenter,
        ),
        portalFollower: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => _toggleMenu(false), // tap outside closes
            behavior: HitTestBehavior.translucent,
            child: widget.menu(_toggleMenu),
          ),
        ),
        child: widget.child(_toggleMenu),
      ),
    );
  }
}

class AppMenuItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final void Function() onTap;
  final Color? color;

  const AppMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: double.infinity,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              text,
              style: AppTextStyles.extraSmall.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
