import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:open_project/core/styles/colors.dart';

Future<T?> showBlurredDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double blurSigma = 6.0,
  Color overlayColor = const Color(0x80505558),
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    // We set the standard barrier color to transparent because
    // we are handling the color and blur inside the transitionBuilder
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) => builder(ctx),
    transitionBuilder: (ctx, anim1, anim2, child) {
      return Stack(
        children: [
          // The Blur and Color Effect
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (!barrierDismissible) return;
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurSigma * anim1.value,
                  sigmaY: blurSigma * anim1.value,
                ),
                child: Container(
                  color: overlayColor, // The black overlay
                ),
              ),
            ),
          ),
          // The Actual Dialog content
          FadeTransition(
            opacity: anim1,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: anim1,
                curve: Curves.fastOutSlowIn,
              ),
              child: child,
            ),
          ),
        ],
      );
    },
  );
}

Future<T?> showBlurredBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double blurSigma = 6.0,
  Color overlayColor = const Color(0x80505558),
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    // IMPORTANT: We remove the SafeArea from the pageBuilder context here
    // to allow the blur to cover the system bars.
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      return Stack(
        children: [
          // 1. Full Screen Blur (Ignores Safe Area)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: FadeTransition(
                opacity: animation,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: Container(
                    color: overlayColor, // This now covers the WHOLE screen
                  ),
                ),
              ),
            ),
          ),

          // 2. The Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: slideAnimation,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Material(
                  color: AppColors.background,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
