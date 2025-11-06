import 'package:flutter/material.dart';

class LogoAnimationHandler {
  late final AnimationController _logoSlideUpAnimationController;
  late final AnimationController _logoSlideSidewaysAnimationController;

  late final Animation<Offset> slideUpAnimation;
  late final Animation<double> fadeInAnimation;
  late final Animation<double> expandSidwaysAnimation;
  late final Animation<double> textFadeInAnimation;

  final slideUpAnimationDuration = const Duration(milliseconds: 450);
  final delayBetweenAnimation = const Duration(milliseconds: 600);
  final slideSidewaysAnimationDuration = const Duration(milliseconds: 800);

  LogoAnimationHandler({
    required TickerProvider vsync,
    required double begin,
    required double end,
  }) {
    // Animation controllers initialization
    _logoSlideUpAnimationController = AnimationController(
      vsync: vsync,
      duration: slideUpAnimationDuration,
    );

    _logoSlideSidewaysAnimationController = AnimationController(
      vsync: vsync,
      duration: slideSidewaysAnimationDuration,
    );

    // Animations initialization

    // First animation: fade in + slide up
    slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 2.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoSlideUpAnimationController,
        curve: Curves.easeOut,
      ),
    );

    fadeInAnimation = CurvedAnimation(
      parent: _logoSlideUpAnimationController,
      curve: Curves.easeIn,
    );

    // Second animation: app name expands horizontally, pushing the
    // logo to the left
    expandSidwaysAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoSlideSidewaysAnimationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    // Animation controllers chaining
    _logoSlideUpAnimationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _logoSlideSidewaysAnimationController.forward();
        }
      },
    );
  }

  void forward() => _logoSlideUpAnimationController.forward();

  void dispose() {
    _logoSlideUpAnimationController.dispose();
    _logoSlideSidewaysAnimationController.dispose();
  }
}
