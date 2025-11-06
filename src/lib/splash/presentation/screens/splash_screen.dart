import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/splash/presentation/cubit/splash_cubit.dart';
import 'package:open_project/splash/presentation/screens/logo_animation_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final LogoAnimationHandler _animationHandler;

  @override
  void initState() {
    super.initState();
    _animationHandler = LogoAnimationHandler(
      vsync: this,
      begin: 0,
      end: 150, // target width
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _animationHandler.forward();
      });
    });
  }

  @override
  void dispose() {
    _animationHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        // Navigating to an auth screen/auth-related screen, or home
        // screen will result in the same behavior since a redirector
        // is implemented in GoRouter (Check `router.dart`).

        if (state is SplashCacheLoadedState) {
          context.read<CacheCubit>().updateCacheValues(state.data);
        } else if (state is SplashCacheLoadingFailedState) {
          context.read<CacheCubit>().updateCacheValues({});
          context.goNamed(AppRoutes.welcome.name);
        } else if (state is SplashOperationsCompletedState) {
          context.goNamed(AppRoutes.welcome.name);
        }
      },
      child: Scaffold(
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo slides up and fades in
              SlideTransition(
                position: _animationHandler.slideUpAnimation,
                child: FadeTransition(
                  opacity: _animationHandler.fadeInAnimation,
                  child: SvgPicture.asset(
                    AppIcons.logo,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),

              // Expanding app name (with fade-in)
              AnimatedBuilder(
                animation: _animationHandler.expandSidwaysAnimation,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor:
                          _animationHandler.expandSidwaysAnimation.value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 12),
                          SvgPicture.asset(AppIcons.appNamePreview),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
