import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/gradient_border.dart';

class AppIdentificationCard extends StatelessWidget {
  final String version;
  const AppIdentificationCard({
    required this.version,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      right: 0,
      left: 0,
      child: Center(
        child: IntrinsicWidth(
          child: SafeArea(
            child: CustomPaint(
              painter: GradientBorderPainter(
                strokeWidth: 1.5,
                radius: 12,
                gradient: SweepGradient(
                  center: Alignment.center,
                  startAngle: 0.0,
                  endAngle: 3.14159 * 2, // Full circle
                  transform:
                      GradientRotation(3.14159 / 2), // Rotates by 45 degrees
                  stops: [0.15, 0.27, 0.70, 0.75, 0.89, 0.98],
                  colors: [
                    const Color(0x202392D4),
                    const Color(0xFF2392D4),
                    const Color(0x202392D4),
                    const Color(0xFF2392D4),
                    const Color(0x702392D4),
                    const Color(0x202392D4),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [0, 1],
                          colors: [
                            const Color(0x0D262B2C),
                            const Color(0x064B5152),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.clientLogo,
                                width: 42,
                                height: 42,
                              ),
                              const SizedBox(width: 12),
                              SvgPicture.asset(
                                AppIcons.appNamePreview,
                                width: 115,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Current version: $version',
                            style: AppTextStyles.small.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.descriptiveText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
