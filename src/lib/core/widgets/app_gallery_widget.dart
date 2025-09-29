import 'package:flutter/material.dart';
import 'package:open_project/core/util/periodic_timer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/styles/colors.dart';
import '../../../core/util/duration_extension.dart';

class AppGalleryWidget extends StatefulWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  const AppGalleryWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height,
    this.borderRadius,
  });

  @override
  State<AppGalleryWidget> createState() => _HomeImageCarouselState();
}

class _HomeImageCarouselState extends State<AppGalleryWidget> {
  final pageController = PageController();
  late PeriodicTimer timer;

  @override
  void initState() {
    timer = PeriodicTimer(
      duration: 3.s,
      onTick: () {
        final currentPage = pageController.page!.toInt();
        pageController.animateToPage(
          currentPage == widget.itemCount - 1 ? 0 : currentPage + 1,
          duration: 500.ms,
          curve: Curves.fastOutSlowIn,
        );
      },
    );
    timer.start();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => timer.pause(),
      onPointerUp: (_) => timer.resume(),
      onPointerCancel: (_) => timer.resume(),
      child: SizedBox(
        height: widget.height,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.zero,
                child: PageView(
                  controller: pageController,
                  children: List.generate(
                    widget.itemCount,
                    (index) => widget.itemBuilder(index),
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              child: Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: widget.itemCount,
                  effect: ExpandingDotsEffect(
                    dotWidth: 6,
                    dotHeight: 6,
                    dotColor: AppColors.lowContrastCursor.withAlpha(200),
                    activeDotColor: AppColors.highContrastCursor,
                    spacing: 4,
                    expansionFactor: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
