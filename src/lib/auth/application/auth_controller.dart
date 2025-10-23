import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/auth/presentation/cubits/auth_get_user_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_page_view_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_ping_server_cubit.dart';
import 'package:open_project/auth/presentation/widgets/server_input_screen/connection_state_widget.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/util/cache_helper.dart';
import 'package:open_project/core/util/dependency_injection.dart';

class AuthController {
  final AuthPageViewCubit authPageViewCubit;
  final AuthPingServerCubit authPingServerCubit;
  final AuthGetUserCubit authGetUserCubit;
  AuthController({
    required this.authPageViewCubit,
    required this.authPingServerCubit,
    required this.authGetUserCubit,
  }) {
    // Listen to page index changes from cubit
    authPageViewCubit.stream.listen(
      (state) {
        // When switched to new page, animate pageview
        // to that page
        _authScreenPageViewController.animateToPage(
          state,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );

    // Listen to `ping server` cubit states
    authPingServerCubit.stream.listen(
      (state) {
        // If it's anything other than a success state, skip.
        if (!state.isData) {
          return;
        }

        // When the state is success, cache server url, then wait
        // for a period of time, then navigate to the next page
        // using `AuthPageViewCubit`

        cacheServerUrl();

        const connectionAnimationDuration =
            // This is the animation duration of the widget
            // that's going to animate
            ConnectionStateWidget.animationDuration;
        // While this is an extra duration we wait for,
        // before we switch to the next page
        const extraDuration = Duration(milliseconds: 400);

        Future.delayed(
          connectionAnimationDuration + extraDuration,
          () async {
            // Using the context in this asynchronous case isn't a
            // problem, because we know in that no changes will happen
            // until the delay is finished

            // ignore: use_build_context_synchronously
            authPageViewCubit.changePage(1);
          },
        );
      },
    );

    // Listen to `ping server` cubit states
    authGetUserCubit.stream.listen(
      (state) {
        // If it's anything other than a success state, skip.
        if (!state.isData) {
          return;
        }

        // When the state is success, cache user data, then
        // navigate to home screen

        cacheUserData(
          userFirstName: state.data!.firstName,
          userEmail: state.data!.email,
        );

        serviceLocator<GoRouter>().goNamed(AppRoutes.home.name);
      },
    );
  }

  // `Auth screen` page view controller
  final _authScreenPageViewController = PageController();
  PageController get authScreenPageViewController =>
      _authScreenPageViewController;

  // `Server Input` screen text field controller
  final serverUrlTextController = TextEditingController();
  void pingServer() {
    // 'https://' is explicitly added because it's handled
    // in the text field (Check UI)
    if (serverUrlTextController.text.isNotEmpty) {
      authPingServerCubit.pingServer('https://${serverUrlTextController.text}');
    }
  }

  // `Token Input` screen text field controller
  final tokenTextController = TextEditingController();
  void getUserData() {
    if (tokenTextController.text.isNotEmpty) {
      authGetUserCubit.getUserData(
        serverUrl: 'https://${serverUrlTextController.text}',
        apiToken: tokenTextController.text,
      );
    }
  }

  void cacheServerUrl() {
    serviceLocator<CacheHelper>().saveData(
      key: AppConstants.serverUrlCacheKey,
      value: 'https://${serverUrlTextController.text}',
    );
  }

  void cacheUserData({
    required String userFirstName,
    required String? userEmail,
  }) {
    final cacheMap = {
      AppConstants.apiTokenCacheKey: tokenTextController.text,
      AppConstants.userFirstNameCacheKey: userFirstName,
      AppConstants.userEmailCacheKey: userEmail,
    };
    serviceLocator<CacheHelper>().saveAll(cacheMap);
  }

  void dispose() {
    serverUrlTextController.dispose();
    tokenTextController.dispose();
  }
}
