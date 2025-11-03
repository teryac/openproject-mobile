import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/add_work_package/add_work_package_screen.dart';
import 'package:open_project/auth/application/auth_controller.dart';
import 'package:open_project/auth/data/auth_repo.dart';
import 'package:open_project/auth/presentation/cubits/auth_get_user_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_page_view_cubit.dart';
import 'package:open_project/auth/presentation/cubits/auth_ping_server_cubit.dart';
import 'package:open_project/auth/presentation/screens/auth_screen.dart';
import 'package:open_project/bloc_tutorial/application/bloc_tutorial_controller.dart';
import 'package:open_project/bloc_tutorial/data/bloc_tutorial_repo.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/counter_cubit.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/projects_cubit.dart';
import 'package:open_project/bloc_tutorial/presentation/cubits/work_packages_cubit.dart';
import 'package:open_project/bloc_tutorial/presentation/screens/bloc_tutorial_screen.dart';
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
import 'package:open_project/work_packages/presentation/cubits/work_packages_data_cubit.dart';
import 'package:open_project/work_packages/presentation/screens/work_packages_screen.dart';

enum AppRoutes {
  splash(name: 'splash', path: '/splash'),
  auth(name: 'auth', path: '/auth'),
  home(name: 'home', path: '/'),
  workPackages(name: 'workPackages', path: '/workPackges/:project_id'),
  addWorkPackage(name: 'addWorkPackage', path: '/addWorkPackage'),
  viewWorkPackage(name: 'viewWorkPackage', path: '/viewWorkPackage'),
  welcome(name: 'welcome', path: '/welcome'),
  // TODO: Remove temp route once it's not needed
  blocTutorial(name: 'blocTutorial', path: '/blocTutorial');

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
                RepositoryProvider(
                  create: (context) => WorkPackagesController(
                    context: context,
                    projectId: projectId,
                    searchDialogWorkPackagesCubit:
                        context.read<SearchDialogWorkPackagesCubit>(),
                  ),
                  dispose: (controller) => controller.dispose(),
                ),
              ],
              child: WorkPackagesScreen(projectId: projectId),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.addWorkPackage.path,
          name: AppRoutes.addWorkPackage.name,
          builder: (context, state) => const AddWorkPackageScreen(),
        ),
        GoRoute(
          path: AppRoutes.viewWorkPackage.path,
          name: AppRoutes.viewWorkPackage.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ViewWorkPackageScrollCubit(),
                ),
                RepositoryProvider(
                  create: (context) => ViewWorkPackageScrollController(
                    scrollCubit: context.read<ViewWorkPackageScrollCubit>(),
                  ),
                ),
              ],
              child: const ViewWorkPackageScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.blocTutorial.path,
          name: AppRoutes.blocTutorial.name,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              RepositoryProvider(
                create: (_) => BlocTutorialRepo(),
              ),
              BlocProvider(
                create: (_) => CounterCubit(),
              ),
              BlocProvider(
                create: (context) =>
                    ProjectsCubit(repo: context.read<BlocTutorialRepo>()),
              ),
              BlocProvider(
                create: (context) =>
                    WorkPackagesCubit(repo: context.read<BlocTutorialRepo>()),
              ),
              RepositoryProvider(
                // Immediately creates controller to listen to
                // stream changes as soon as other dependencies
                // are created, otherwise, the stream subscription
                // won't get initialized (Check `BlocTutorialController`
                // constructor body)
                lazy: false,
                create: (context) {
                  final projectsCubit = context.read<ProjectsCubit>();
                  final workPackagesCubit = context.read<WorkPackagesCubit>();

                  return BlocTutorialController(
                    projectsCubit: projectsCubit,
                    workPackagesCubit: workPackagesCubit,
                  );
                },
              ),
            ],
            child: const BlocTutorialScreen(),
          ),
        ),
      ],
    );
