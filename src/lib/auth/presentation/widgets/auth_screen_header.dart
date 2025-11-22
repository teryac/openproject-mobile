import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/presentation/cubits/auth_page_view_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_ping_server_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/colors.dart';
import 'package:open_project/core/styles/text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final stepperWidth = MediaQuery.widthOf(context) * 0.23;
    final blurFilter = ImageFilter.blur(sigmaX: 4, sigmaY: 4);
    final blurGradiant = LinearGradient(
      colors: [
        Color(0x40FFFFFF),
        Color(0x40FAFCFC),
      ],
      stops: [0.0, 1.0],
      begin: AlignmentGeometry.centerLeft,
      end: AlignmentGeometry.centerRight,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: BlocBuilder<AuthPageViewCubit, int>(
        builder: (context, pageViewCubitState) {
          return Row(
            children: [
              if (pageViewCubitState == 1)
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    gradient: blurGradiant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: BackdropFilter(
                    filter: blurFilter,
                    child: ClipRRect(
                      child: GestureDetector(
                        onTap: () {
                          context.read<AuthPingServerCubit>().resetState();
                          context.read<AuthPageViewCubit>().changePage(0);
                        },
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              AppIcons.arrowLeft,
                              width: 24,
                              height: 24,
                              // ignore: deprecated_member_use
                              color: AppColors.iconPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: blurGradiant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: BackdropFilter(
                  filter: blurFilter,
                  child: SmoothPageIndicator(
                    controller: context
                        .read<AuthController>()
                        .authScreenPageViewController,
                    count: 2,
                    effect: SlideEffect(
                      dotWidth: stepperWidth,
                      dotHeight: 8,
                      spacing: 16,
                      dotColor: AppColors.lowContrastCursor,
                      activeDotColor: AppColors.highContrastCursor,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (pageViewCubitState == 1)
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    gradient: blurGradiant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: BackdropFilter(
                    filter: blurFilter,
                    child: GestureDetector(
                      onTap: () => context.goNamed(AppRoutes.splash.name),
                      // Added padding to make click space larger
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Skip',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
