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

  String? _driver; // "primary", "secondary", or null
  bool _isFromTimer = false;

  void _handlePrimaryScroll() {
    if (_isFromTimer) return;
    if (!pageController.hasClients || !secondaryPageController!.hasClients) {
      return;
    }

    // If user is dragging primary, it becomes driver.
    if (pageController.position.isScrollingNotifier.value) {
      _driver = 'primary';
    }

    if (_driver == 'primary') {
      final target = pageController.position.pixels *
          secondaryPageController!.position.viewportDimension /
          pageController.position.viewportDimension;

      if ((secondaryPageController!.position.pixels - target).abs() > 0.5) {
        secondaryPageController!.jumpTo(target);
      }
    }
  }

  void _handleSecondaryScroll() {
    if (_isFromTimer) return;
    if (!pageController.hasClients || !secondaryPageController!.hasClients) {
      return;
    }

    if (secondaryPageController!.position.isScrollingNotifier.value) {
      _driver = 'secondary';
    }

    if (_driver == 'secondary') {
      final target = secondaryPageController!.position.pixels *
          pageController.position.viewportDimension /
          secondaryPageController!.position.viewportDimension;

      if ((pageController.position.pixels - target).abs() > 0.5) {
        pageController.jumpTo(target);
      }
    }
  }

  void _setupAutoScrollTimer() {
    timer = PeriodicTimer(
      duration: const Duration(seconds: 3),
      onTick: () async {
        if (!pageController.hasClients) return;

        _isFromTimer = true;
        _driver = null;

        final current = pageController.page!.round();
        final next = (current + 1) % widget.itemCount;

        await Future.wait([
          pageController.animateToPage(next,
              duration: 500.ms, curve: Curves.fastOutSlowIn),
          if (secondaryPageController != null)
            secondaryPageController!.animateToPage(next,
                duration: 500.ms, curve: Curves.fastOutSlowIn),
        ]);

        _isFromTimer = false;
      },
    );

    timer.start();
  }

  @override
  void initState() {
    super.initState();

    if (widget.secondaryItemBuilder != null) {
      secondaryPageController = PageController();

      // Attach listeners to both controllers
      pageController.addListener(_handlePrimaryScroll);
      secondaryPageController!.addListener(_handleSecondaryScroll);
    }

    _setupAutoScrollTimer();
  }

  @override
  void dispose() {
    // Remove both listeners
    pageController.removeListener(_handlePrimaryScroll);
    secondaryPageController?.removeListener(_handleSecondaryScroll);

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
