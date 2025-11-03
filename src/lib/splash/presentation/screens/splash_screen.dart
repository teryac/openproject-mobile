import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_assets.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/widgets/app_image.dart';
import 'package:open_project/splash/presentation/cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCacheLoadedState) {
          context.read<CacheCubit>().updateCacheValues(state.data);
        } else if (state is SplashCacheLoadingFailedState) {
          context.read<CacheCubit>().updateCacheValues({});
          // Navigating to an auth screen/auth-related screen, or home
          // screen will result in the same behavior since a redirector
          // is implemented in GoRouter (Check `router.dart`).
          context.goNamed(AppRoutes.welcome.name);
        } else if (state is SplashOperationsCompletedState) {
          // Navigating to an auth screen/auth-related screen, or home
          // screen will result in the same behavior since a redirector
          // is implemented in GoRouter (Check `router.dart`).
          context.goNamed(AppRoutes.welcome.name);
        }
      },
      child: Scaffold(
        body: Center(
          child: AppAssetImage(
            assetPath: AppImages.op,
          ),
        ),
      ),
    );
  }
}
