import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/add_work_package/add_work_package_screen.dart';
import 'package:open_project/auth/auth_screen.dart';
import 'package:open_project/home/home_screen.dart';
import 'package:open_project/view_work_package/view_work_package_screen.dart';
import 'package:open_project/work_packages/work_packages_screen.dart';

enum AppRoutes {
  auth(name: 'auth', path: '/auth'),
  home(name: 'home', path: '/'),
  workPackages(name: 'workPackages', path: '/workPackges'),
  addWorkPackage(name: 'addWorkPackage', path: '/addWorkPackage'),
  viewWorkPackage(name: 'viewWorkPackage', path: '/viewWorkPackage');

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
        GoRoute(
          path: AppRoutes.home.path,
          name: AppRoutes.home.name,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.auth.path,
          name: AppRoutes.auth.name,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: AppRoutes.workPackages.path,
          name: AppRoutes.workPackages.name,
          builder: (context, state) => const WorkPackagesScreen(),
        ),
        GoRoute(
          path: AppRoutes.addWorkPackage.path,
          name: AppRoutes.addWorkPackage.name,
          builder: (context, state) => const AddWorkPackageScreen(),
        ),
        GoRoute(
          path: AppRoutes.viewWorkPackage.path,
          name: AppRoutes.viewWorkPackage.name,
          builder: (context, state) => const ViewWorkPackageScreen(),
        ),
      ],
    );
