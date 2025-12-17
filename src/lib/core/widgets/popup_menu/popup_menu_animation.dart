import 'package:flutter/material.dart';
import 'package:open_project/core/util/duration_extension.dart';

class PopupMenuAnimation {
  late final AnimationController controller;
  late final Animation<double> scale;
  final duration = 500.ms;

  PopupMenuAnimation({required TickerProvider vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );

    scale = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void forward() => controller.forward();
  void reverse() => controller.reverse();

  void dispose() => controller.dispose();
}
