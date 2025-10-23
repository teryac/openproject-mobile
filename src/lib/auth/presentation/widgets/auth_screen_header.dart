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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<AuthPageViewCubit, int>(
        builder: (context, pageViewCubitState) {
          return Row(
            children: [
              if (pageViewCubitState == 1)
                GestureDetector(
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
              const Spacer(),
              SmoothPageIndicator(
                controller:
                    context.read<AuthController>().authScreenPageViewController,
                count: 2,
                effect: const SlideEffect(
                  dotWidth: 96,
                  dotHeight: 8,
                  spacing: 8,
                  dotColor: AppColors.lowContrastCursor,
                  activeDotColor: AppColors.highContrastCursor,
                ),
              ),
              const Spacer(),
              if (pageViewCubitState == 1)
                GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.home.name),
                  // Added padding to make click space larger
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Skip',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.descriptiveText,
                        fontWeight: FontWeight.w500,
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
