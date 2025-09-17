import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  home(name: 'home', path: '/'),
  auth(name: 'auth', path: '/auth');

  const AppRoutes({required this.name, required this.path});
  final String name;
  final String path;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter getAppRouter() => GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.home.path,
      redirect: (context, state) {
        /*
        Redirection logic:
        final isLoggedIn = AuthRepo().getAuthState();

        List of auth-related screens
        final isAuthRoute = [
          AppRoutes.auth.path,
          other auth screens here...
        ].any((path) => state.uri.path == path);

        While not authenticated:
        redirect to auth screen unless currently in an auth-related screen
        if (!isLoggedIn && !isAuthRoute) {
          return AppRoutes.auth.path;
        }

        If tried to access auth screen while already authenticated, redirect to home
        if (isLoggedIn && isAuthRoute) {
          return AppRoutes.home.path;
        }

        Otherwise
        return null;
        */

        return null;
      },
      routes: [
        // Routes go here...
        // GoRoute(path: ),
        // GoRoute(path: ),
      ],
    );
