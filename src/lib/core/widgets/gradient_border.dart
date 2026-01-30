import 'package:flutter/material.dart';

class GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final double radius;
  final Gradient gradient;

  GradientBorderPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate half the stroke width to "push" the line inward
    final double halfStroke = strokeWidth / 2;

    // Create an inset rect so the stroke doesn't get cut off at the edges
    Rect rect = Rect.fromLTWH(halfStroke, halfStroke, size.width - strokeWidth,
        size.height - strokeWidth);

    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    // Use the same inset logic for the radius to keep it looking sharp
    RRect rrect =
        RRect.fromRectAndRadius(rect, Radius.circular(radius - halfStroke));

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
