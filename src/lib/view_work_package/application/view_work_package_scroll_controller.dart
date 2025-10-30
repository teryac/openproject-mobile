import 'package:flutter/material.dart';
import '../presentation/cubits/view_work_package_scroll_cubit.dart';

class ViewWorkPackageScrollController {
  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> sectionKeys = List.generate(4, (_) => GlobalKey());
  final ViewWorkPackageScrollCubit scrollCubit;

  ViewWorkPackageScrollController({required this.scrollCubit}) {
    scrollController.addListener(_onScroll);
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }

  void _onScroll() {
    for (int i = 0; i < sectionKeys.length; i++) {
      final ctx = sectionKeys[i].currentContext;
      if (ctx == null) continue;

      final renderObject = ctx.findRenderObject();
      if (renderObject is! RenderBox) continue;

      final pos = renderObject.localToGlobal(Offset.zero).dy;
      if (pos < 200 && pos > -renderObject.size.height / 2) {
        scrollCubit.updateIndex(i);
        break;
      }
    }
  }

  /// Scrolls to the section respecting only the top safe area.
  void scrollToSection(BuildContext context, int index) {
    final ctx = sectionKeys[index].currentContext;
    if (ctx == null) return;

    final renderObject = ctx.findRenderObject();
    if (renderObject is! RenderBox) return;

    final safeAreaTop = MediaQuery.paddingOf(context).top + 20;
    final offset =
        renderObject.localToGlobal(Offset.zero).dy + scrollController.offset;

    final target = offset - safeAreaTop;

    scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
