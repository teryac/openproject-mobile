import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/add_work_package/application/add_work_package_controller.dart';
import 'package:open_project/add_work_package/data/add_work_package_repo.dart';
import 'package:open_project/add_work_package/models/work_package_mode.dart';
import 'package:open_project/add_work_package/presentation/cubits/add_work_package_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/project_users_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_form_data/work_package_form_data_cubit.dart';
import 'package:open_project/add_work_package/presentation/cubits/work_package_payload_cubit.dart';
import 'package:open_project/add_work_package/presentation/screens/add_work_package_screen.dart';
import 'package:open_project/add_work_package/presentation/cubits/week_days_data_cubit.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/data/auth_repo.dart';
import 'package:open_project/auth/presentation/cubits/auth_get_user_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_page_view_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_ping_server_cubit.dart';
import 'package:open_project/auth/presentation/screens/auth_screen.dart';
import 'package:open_project/auth/presentation/screens/update_api_token_screen.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/cache/cache_repo.dart';
import 'package:open_project/home/application/home_controller.dart';
import 'package:open_project/home/data/home_repo.dart';
import 'package:open_project/home/presentation/cubits/projects_data_cubit.dart';
import 'package:open_project/home/presentation/cubits/projects_list_expansion_cubit.dart';
import 'package:open_project/home/presentation/screens/home_screen.dart';
import 'package:open_project/splash/presentation/cubit/splash_cubit.dart';
import 'package:open_project/splash/presentation/screens/splash_screen.dart';
import 'package:open_project/view_work_package/application/view_work_package_scroll_controller.dart';
import 'package:open_project/view_work_package/presentation/cubits/view_work_package_scroll_cubit.dart';
import 'package:open_project/view_work_package/presentation/screens/view_work_package_screen.dart';
import 'package:open_project/welcome/welcome_screen.dart';
import 'package:open_project/work_packages/application/work_packages_controller.dart';
import 'package:open_project/work_packages/data/work_packages_repo.dart';
import 'package:open_project/work_packages/models/work_package_dependencies.dart';
import 'package:open_project/work_packages/presentation/cubits/delete_work_package_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_filters_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_package_dependencies_data_cubit.dart';
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/screens/work_packages_screen.dart';

import '../../work_packages/models/work_package.dart';

enum AppRoutes {
  splash(name: 'splash', path: '/splash'),
  auth(name: 'auth', path: '/auth'),
  updateApiToken(name: 'updateApiToken', path: '/updateApiToken'),
  home(name: 'home', path: '/'),
  workPackages(name: 'workPackages', path: '/workPackges/:project_id'),

  /// id is for either project id or work package id, the mode is determined
  /// using a query parameter
  addWorkPackage(
      name: 'addWorkPackage', path: '/addWorkPackage/:work_package_id'),
  viewWorkPackage(name: 'viewWorkPackage', path: '/viewWorkPackage'),
  welcome(name: 'welcome', path: '/welcome');

  const AppRoutes({required this.name, required this.path});
  final String name;
  final String path;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter getAppRouter() => GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash.path,
      redirect: (context, state) async {
        // Ignore redirection if accessing splash screen or API
        // update screen
        if (state.uri.path == AppRoutes.splash.path ||
            state.uri.path == AppRoutes.updateApiToken.path) {
          return null;
        }

        // Check for authentication state
        final cachedServer = await context.read<CacheRepo>().getData(
              AppConstants.serverUrlCacheKey,
            );
        final isLoggedIn = cachedServer != null && cachedServer.isNotEmpty;

        // List of auth-related screens
        final isAuthRoute = [
          AppRoutes.welcome.path,
          AppRoutes.auth.path,
        ].any((path) => state.uri.path == path);

        // While not authenticated:
        // redirect to welcome screen unless currently in an auth-related screen
        if (!isLoggedIn && !isAuthRoute) {
          return AppRoutes.welcome.path;
        }

        // If tried to access auth screen while already authenticated, redirect to home
        if (isLoggedIn && isAuthRoute) {
          return AppRoutes.home.path;
        }

        // Otherwise, do nothing
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash.path,
          name: AppRoutes.splash.name,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => SplashCubit(
                cacheHelper: context.read<CacheRepo>(),
              ),
              child: const SplashScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.welcome.path,
          name: AppRoutes.welcome.name,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.auth.path,
          name: AppRoutes.auth.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                RepositoryProvider(
                  create: (_) => AuthRepo(),
                ),
                BlocProvider(
                  create: (_) => AuthPageViewCubit(),
                ),
                BlocProvider(
                  create: (context) => AuthPingServerCubit(
                    authRepo: context.read<AuthRepo>(),
                  ),
                ),
                BlocProvider(
                  create: (context) => AuthGetUserCubit(
                    authRepo: context.read<AuthRepo>(),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => AuthController(
                    context: context,
                    authPageViewCubit: context.read<AuthPageViewCubit>(),
                    authPingServerCubit: context.read<AuthPingServerCubit>(),
                    authGetUserCubit: context.read<AuthGetUserCubit>(),
                  ),
                  dispose: (controller) => controller.dispose(),
                ),
              ],
              child: const AuthScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.updateApiToken.path,
          name: AppRoutes.updateApiToken.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                RepositoryProvider(
                  create: (_) => AuthRepo(),
                ),
                BlocProvider(
                  create: (context) => AuthGetUserCubit(
                    authRepo: context.read<AuthRepo>(),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => AuthController(
                    context: context,
                    authGetUserCubit: context.read<AuthGetUserCubit>(),
                  ),
                  dispose: (controller) => controller.dispose(),
                ),
              ],
              child: const UpdateApiTokenScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.home.path,
          name: AppRoutes.home.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                RepositoryProvider(
                  create: (_) => HomeRepo(),
                ),
                BlocProvider(
                  create: (_) => ProjectsListExpansionCubit(),
                ),
                BlocProvider(
                  create: (context) {
                    return HomeProjectsListCubit(
                      context: context,
                      homeRepo: context.read<HomeRepo>(),
                    );
                  },
                ),
                BlocProvider(
                  create: (context) {
                    return SearchDialogProjectsCubit(
                      homeRepo: context.read<HomeRepo>(),
                    );
                  },
                ),
                RepositoryProvider(
                  create: (context) => HomeController(
                    context: context,
                    searchDialogProjectsCubit:
                        context.read<SearchDialogProjectsCubit>(),
                  ),
                  dispose: (controller) => controller.dispose(),
                ),
              ],
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.workPackages.path,
          name: AppRoutes.workPackages.name,
          builder: (context, state) {
            final projectId = int.parse(state.pathParameters['project_id']!);
            final projectName = state.uri.queryParameters['project_name']!;

            return MultiBlocProvider(
              providers: [
                RepositoryProvider(
                  create: (_) => WorkPackagesRepo(),
                ),
                BlocProvider(
                  create: (context) {
                    return WorkPackagesListCubit(
                      context: context,
                      projectId: projectId,
                      workPackagesRepo: context.read<WorkPackagesRepo>(),
                    );
                  },
                ),
                BlocProvider(
                  create: (context) {
                    return SearchDialogWorkPackagesCubit(
                      workPackagesRepo: context.read<WorkPackagesRepo>(),
                    );
                  },
                ),
                BlocProvider(
                  create: (context) {
                    return WorkPackageDependenciesDataCubit(
                      workPackagesRepo: context.read<WorkPackagesRepo>(),
                      context: context,
                      projectId: projectId,
                    );
                  },
                ),
                BlocProvider(
                  create: (_) => WorkPackagesFiltersCubit(),
                ),
                BlocProvider(
                  create: (context) => DeleteWorkPackageCubit(
                    workPackagesRepo: context.read<WorkPackagesRepo>(),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => WorkPackagesController(
                    context: context,
                    projectId: projectId,
                    workPackagesListCubit:
                        context.read<WorkPackagesListCubit>(),
                    searchDialogWorkPackagesCubit:
                        context.read<SearchDialogWorkPackagesCubit>(),
                    workPackagesFiltersCubit:
                        context.read<WorkPackagesFiltersCubit>(),
                  ),
                  dispose: (controller) => controller.dispose(),
                ),
              ],
              child: WorkPackagesScreen(
                projectId: projectId,
                projectName: projectName,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.viewWorkPackage.path,
          name: AppRoutes.viewWorkPackage.name,
          builder: (context, state) {
            final workPackageData = WorkPackage.fromJson(
              jsonDecode(state.uri.queryParameters['data']!),
            );
            final workPackageDependencies = WorkPackageDependencies.fromJson(
              jsonDecode(state.uri.queryParameters['dependencies']!),
            );

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ViewWorkPackageScrollCubit(),
                ),
                RepositoryProvider(
                  create: (context) => ViewWorkPackageScrollController(
                    scrollCubit: context.read<ViewWorkPackageScrollCubit>(),
                  ),
                  dispose: (controller) => controller.dispose(),
                ),
                // Work Package model & Dependencies are injected into BuildContext
                // to access them easily in the widget tree
                RepositoryProvider(create: (_) => workPackageData),
                RepositoryProvider(create: (_) => workPackageDependencies),
              ],
              child: const ViewWorkPackageScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.addWorkPackage.path,
          name: AppRoutes.addWorkPackage.name,
          builder: (context, state) {
            final workPackageId = int.tryParse(
              // the id is always passed, even when null it's
              // passed as 'null'
              state.pathParameters['work_package_id']!,
            );

            final editMode = bool.parse(
              state.uri.queryParameters['edit_mode']!,
            );
            final projectId = int.parse(
              state.uri.queryParameters['project_id']!,
            );

            return MultiBlocProvider(
              providers: [
                RepositoryProvider(
                  create: (_) => AddWorkPackageScreenConfig(
                    editMode: editMode,
                    workPackageId: workPackageId,
                    projectId: projectId,
                  ),
                ),
                RepositoryProvider(
                  create: (_) => AddWorkPackageRepo(),
                ),
                BlocProvider(
                  create: (context) => WeekDaysDataCubit(
                    addWorkPackageRepo: context.read<AddWorkPackageRepo>(),
                    context: context,
                  ),
                ),
                BlocProvider(
                  create: (context) => WorkPackageFormDataCubit(
                    addWorkPackageRepo: context.read<AddWorkPackageRepo>(),
                    context: context,
                  ),
                ),
                BlocProvider(
                  create: (context) => WorkPackagePayloadCubit(),
                ),
                BlocProvider(
                  create: (context) => ProjectAssigneesDataCubit(
                    addWorkPackageRepo: context.read<AddWorkPackageRepo>(),
                    projectId: projectId,
                  ),
                ),
                BlocProvider(
                  create: (context) => ProjectResponsiblesDataCubit(
                    addWorkPackageRepo: context.read<AddWorkPackageRepo>(),
                    projectId: projectId,
                  ),
                ),
                BlocProvider(
                  create: (context) => AddWorkPackageDataCubit(
                    addWorkPackageRepo: context.read<AddWorkPackageRepo>(),
                    context: context,
                  ),
                ),
                RepositoryProvider(
                  lazy: false,
                  create: (context) {
                    return AddWorkPackageController(
                      workPackageFormDataCubit:
                          context.read<WorkPackageFormDataCubit>(),
                      workPackagePayloadCubit:
                          context.read<WorkPackagePayloadCubit>(),
                      addWorkPackageDataCubit:
                          context.read<AddWorkPackageDataCubit>(),
                    );
                  },
                  dispose: (controller) => controller.dispose(),
                ),
              ],
              child: const AddWorkPackageScreen(),
            );
          },
        ),
      ],
    );
