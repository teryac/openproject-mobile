import 'package:flutter/material.dart';
import 'package:open_project/core/util/duration_extension.dart';

class LogoAnimationHandler {
  late final AnimationController controller;
  late final Animation<double> width;
  final duration = 600.ms;

  LogoAnimationHandler({
    required TickerProvider vsync,
    required double begin,
    required double end,
  }) {
    controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );

    width = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void forward() => controller.forward();

  void dispose() => controller.dispose();
}
