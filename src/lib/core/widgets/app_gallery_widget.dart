import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:open_project/core/util/periodic_timer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/styles/colors.dart';
import '../../../core/util/duration_extension.dart';

class AppGalleryWidget extends StatefulWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final double? secondaryItemIndentation;
  final Widget Function(int index)? secondaryItemBuilder;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? secondaryBorderRadius;
  const AppGalleryWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.borderRadius,
    this.secondaryItemBuilder,
    this.secondaryItemIndentation,
    this.secondaryBorderRadius,
  });

  @override
  State<AppGalleryWidget> createState() => _HomeImageCarouselState();
}

class _HomeImageCarouselState extends State<AppGalleryWidget> {
  final pageController = PageController();
  PageController? secondaryPageController;
  late PeriodicTimer timer;

  void _syncPageViews() {
    if (secondaryPageController == null) return;

    final double? currentPage = pageController.page;

    if (currentPage != null && pageController.hasClients) {
      final double secondaryOffset =
          currentPage * secondaryPageController!.position.viewportDimension;
      secondaryPageController!.jumpTo(secondaryOffset);
    }
  }

  @override
  void initState() {
    if (widget.secondaryItemBuilder != null) {
      secondaryPageController = PageController();
      pageController.addListener(_syncPageViews);
    }

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
    pageController.removeListener(_syncPageViews);
    pageController.dispose();
    secondaryPageController?.dispose();
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => timer.pause(),
      onPointerUp: (_) => timer.resume(),
      onPointerCancel: (_) => timer.resume(),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: ExpandablePageView(
              controller: pageController,
              children: List.generate(
                widget.itemCount,
                (index) => widget.itemBuilder(index),
              ).toList(),
            ),
          ),
          SizedBox(height: widget.secondaryItemIndentation),
          if (widget.secondaryItemBuilder != null)
            ClipRRect(
              borderRadius: widget.secondaryBorderRadius ?? BorderRadius.zero,
              child: ExpandablePageView(
                controller: secondaryPageController,
                children: List.generate(
                  widget.itemCount,
                  (index) => widget.secondaryItemBuilder!(index),
                ).toList(),
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
    );
  }
}
