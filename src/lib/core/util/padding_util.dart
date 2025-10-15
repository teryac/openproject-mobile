import 'package:flutter/material.dart';

/// This function is used in a scrollable row that's placed
/// inside a view with horizontal padding, the intended behavior
/// is to make the row scroll into the screen edges, without
/// a limit of the padding (The row must be placed outside the
/// padding, but this widget gives the first and last items
/// extra padding to make it seem like the widget has a horizontal
/// padding like other widgets in the same view)
EdgeInsets getScrollableRowPadding({
  required BuildContext context,
  required int index,
  required int listLength,

  /// Padding for first and last item (padding around Row)
  required double marginalPadding,

  /// Padding between inner items
  required double itemPadding,
}) {
  final textDirection = Directionality.of(context);
  // Divided by 2 because padding is applied from left and right
  final halfItemPadding = itemPadding / 2;

  if (index == 0) {
    return EdgeInsets.only(
      left: textDirection == TextDirection.ltr
          ? marginalPadding
          : halfItemPadding,
      right: textDirection == TextDirection.ltr
          ? halfItemPadding
          : marginalPadding,
    );
  } else if (index == listLength - 1) {
    return EdgeInsets.only(
      right: textDirection == TextDirection.ltr
          ? marginalPadding
          : halfItemPadding,
      left: textDirection == TextDirection.ltr
          ? halfItemPadding
          : marginalPadding,
    );
  }

  return EdgeInsets.only(
    right: halfItemPadding,
    left: halfItemPadding,
  );
}
