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

  // A guard flag to prevent infinite loops
  bool _isSyncing = false;

// Syncs Primary -> Secondary
  void _syncSecondary() {
    // If we are already syncing or controllers aren't ready, stop.
    if (_isSyncing || secondaryPageController == null) return;
    if (!pageController.hasClients || !secondaryPageController!.hasClients) {
      return;
    }

    // Lock sync
    setState(() {
      _isSyncing = true;
    });

    // Calculate the matching position based on the "Page" index
    final double currentPage = pageController.page ?? 0;
    final double secondaryOffset =
        currentPage * secondaryPageController!.position.viewportDimension;

    secondaryPageController!.jumpTo(secondaryOffset);

    // Unlock sync
    setState(() {
      _isSyncing = false;
    });
  }

  // Syncs Secondary -> Primary
  void _syncPrimary() {
    if (_isSyncing || secondaryPageController == null) return;
    if (!pageController.hasClients || !secondaryPageController!.hasClients) {
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    final double currentPage = secondaryPageController!.page ?? 0;
    final double primaryOffset =
        currentPage * pageController.position.viewportDimension;

    pageController.jumpTo(primaryOffset);

    setState(() {
      _isSyncing = false;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.secondaryItemBuilder != null) {
      secondaryPageController = PageController();

      // Attach listeners to both controllers
      pageController.addListener(_syncSecondary);
      secondaryPageController!.addListener(_syncPrimary);
    }

    timer = PeriodicTimer(
      duration: 3.s,
      onTick: () async {
        if (!pageController.hasClients) return;

        // Lock the sync mechanism before animating
        setState(() {
          _isSyncing = true;
        });

        final currentPage = pageController.page!.toInt();

        await Future.wait([
          pageController.animateToPage(
            currentPage == widget.itemCount - 1 ? 0 : currentPage + 1,
            duration: 500.ms,
            curve: Curves.fastOutSlowIn,
          ),
          if (secondaryPageController != null)
            secondaryPageController!.animateToPage(
              currentPage == widget.itemCount - 1 ? 0 : currentPage + 1,
              duration: 500.ms,
              curve: Curves.fastOutSlowIn,
            )
        ]);

        setState(() {
          _isSyncing = false;
        });
      },
    );

    timer.start();
  }

  @override
  void dispose() {
    // Remove both listeners
    pageController.removeListener(_syncSecondary);
    secondaryPageController?.removeListener(_syncPrimary);

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
