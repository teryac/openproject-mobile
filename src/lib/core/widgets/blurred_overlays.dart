import 'dart:ui';
import 'package:flutter/material.dart';

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
  Color sheetBackgroundColor = Colors.white, // The actual color of your sheet
  bool expand = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: expand,
    backgroundColor: Colors.transparent,
    barrierColor: overlayColor,
    builder: (ctx) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          // Apply the background color here
          decoration: BoxDecoration(
            color: sheetBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            // bottom: true ensures content stays above the nav bar,
            // but the Container's color will still fill the safe area.
            bottom: true,
            child: expand
                ? SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.9, // Adjust as needed
                    child: builder(ctx),
                  )
                : Column(
                    mainAxisSize:
                        MainAxisSize.min, // Sheet wraps content height
                    children: [builder(ctx)],
                  ),
          ),
        ),
      );
    },
  );
}
