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
  // The color of the modal sheet itself. Must be transparent for the blur to work.
  Color modalSheetColor = Colors.transparent,
  // Whether the content of the sheet should occupy the full screen height (like your old code).
  bool expand = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled:
        expand, // Use isScrollControlled to allow full screen height
    backgroundColor: modalSheetColor,
    barrierColor: overlayColor, // Use barrierColor for the overlay tint
    builder: (ctx) {
      // Wrap the content with BackdropFilter to blur the widgets *behind* it.
      return BackdropFilter(
        // The blur is applied here, using the passed sigma value.
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: expand
            ? Column(
                // When expanded, the column pushes the content to the bottom
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // The actual content wrapped in a flexible container
                  Flexible(
                    child: builder(ctx),
                  ),
                ],
              )
            : builder(ctx),
      );
    },
  );
}
