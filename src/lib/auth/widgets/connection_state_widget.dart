import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/widgets/app_image.dart';

class ConnectionStateWidget extends StatefulWidget {
  final bool connected;
  const ConnectionStateWidget({super.key, required this.connected});

  @override
  State<ConnectionStateWidget> createState() => _ConnectionStateWidgetState();
}

class _ConnectionStateWidgetState extends State<ConnectionStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.62, 0.0, 0.36, 0.38),
      ),
    );

    // initialize state
    if (widget.connected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ConnectionStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.connected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _CustomCircularAvatar(
          child: AppAssetImage(assetPath: AppImages.profile),
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ConnectionPainter(
                        progress: _progressAnimation.value,
                      ),
                      size: const Size(double.infinity, 50),
                    );
                  },
                ),
                Positioned.fill(
                  child: Align(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return SvgPicture.asset(
                          AppIcons.link,
                          // ignore: deprecated_member_use
                          color: () {
                            if (_progressAnimation.value >= 0.475) {
                              return AppColors.background;
                            }

                            return AppColors.iconSecondary;
                          }(),
                          width: 16,
                          height: 16,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _CustomCircularAvatar(
          child: Align(
            child: SvgPicture.asset(AppIcons.logo),
          ),
        ),
      ],
    );
  }
}

class _CustomCircularAvatar extends StatelessWidget {
  final Widget child;
  const _CustomCircularAvatar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 30),
            color: Color(0x00595959),
            blurRadius: 8,
          ),
          BoxShadow(
            offset: Offset(0, 19),
            color: Color(0x03595959),
            blurRadius: 8,
          ),
          BoxShadow(
            offset: Offset(0, 11),
            color: Color(0x0A595959),
            blurRadius: 6,
          ),
          BoxShadow(
            offset: Offset(0, 5),
            color: Color(0x0F595959),
            blurRadius: 5,
          ),
          BoxShadow(
            offset: Offset(0, 1),
            color: Color(0x12595959),
            blurRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  final double progress;

  _ConnectionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const lineHeight = 8.0;
    final bubbleCenter = Offset(size.width / 2, size.height / 2);

    final trackPaint = Paint()
      ..color = AppColors.lowContrastCursor
      ..style = PaintingStyle.fill;

    final fillPaint = Paint()
      ..color = AppColors.highContrastCursor
      ..style = PaintingStyle.fill;

    // ---- Draw grey track (line) ----
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: lineHeight,
      ),
      const Radius.circular(0),
    );

    final bubble = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 32,
        height: 24,
      ),
      const Radius.circular(360),
    );

    canvas.drawRRect(trackRect, trackPaint);

    // ---- Draw grey bubble ----
    canvas.drawRRect(bubble, trackPaint);

    // ---- Clip region for progress ----
    final clipRect = Rect.fromLTWH(0, 0, size.width * progress, size.height);
    canvas.save();
    canvas.clipRect(clipRect);

    // Draw blue line
    canvas.drawRRect(trackRect, fillPaint);

    // Draw blue bubble
    canvas.drawRRect(bubble, fillPaint);

    canvas.restore();

    // ---- Bubble icon on top ----
    final textPainter = TextPainter(
      text: const TextSpan(
        text: "",
        style: TextStyle(fontSize: 20), // or use IconPainter
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      bubbleCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_ConnectionPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
