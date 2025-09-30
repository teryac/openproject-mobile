import 'package:flutter/material.dart';

Size calculateTextSize({
  required BuildContext context,
  required String text,
  required TextStyle style,
  required double maxWidth,
  int maxLines = 1,
  bool noScaling = false,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: Directionality.of(context),
    textScaler: noScaling
        ? const TextScaler.linear(1)
        : MediaQuery.of(context).textScaler,
    maxLines: maxLines,
  )..layout(maxWidth: maxWidth);

  return textPainter.size;
}
