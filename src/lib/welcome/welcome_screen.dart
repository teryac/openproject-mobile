// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:open_project/core/widgets/app_button.dart';
import 'package:open_project/core/widgets/app_image.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              right: 16.0, left: 16.0, top: 16.0, bottom: 12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppAssetImage(
                assetPath: AppImages.emp,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(24),
              ),
              Positioned(
                top: 20,
                right: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(width: 64),
                      const Spacer(),
                      ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(360),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              color: const Color(0x99262B2C),
                            ),
                            child: SvgPicture.asset(AppIcons.logoWithName),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(360),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: InkWell(
                            onTap: () {
                              context.pushNamed(AppRoutes.about.name);
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                color: const Color(0x99262B2C),
                              ),
                              child: SvgPicture.asset(AppIcons.info),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0x99262B2C),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text("Welcome to your all in one project manager",
                                style: AppTextStyles.extraLarge
                                    .copyWith(color: AppColors.background)),
                            const SizedBox(height: 8.0),
                            Text(
                                "Collaborate with your team, check your tasks, and update your supervisor on progress.",
                                style: AppTextStyles.small
                                    .copyWith(color: AppColors.background)),
                            const SizedBox(height: 16.0),
                            AppButton.white(
                              text: 'Get started',
                              onPressed: () {
                                context.goNamed(AppRoutes.auth.name);
                              },
                              semiTransparent: true,
                              // blur: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
