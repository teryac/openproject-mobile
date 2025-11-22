import 'package:flutter/material.dart';

class WorkPackageTileAnimationHelper {
  late final AnimationController controller;

  late Animation<double> sizeAnimation;
  late Animation<double> fadeAnimation;

  WorkPackageTileAnimationHelper({
    required TickerProvider vsync,
  }) {
    // 1. The Engine: Duration decides how long the collapse takes
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );

    // 2. The Collapse: Controls the height (Size) of the tile
    // invert the animation: Begin at 1.0 (full size), End at 0.0 (empty)
    sizeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    // 3. The Fade: Makes it transparent as it collapses
    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void forward() => controller.forward();

  void dispose() {
    controller.dispose();
  }
}
