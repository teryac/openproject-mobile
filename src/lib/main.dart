import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/cache/cache_repo.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/themes.dart';
import 'package:open_project/core/util/bloc_observer.dart';

void main() {
  _attachBlocObserver();
  // runApp(const MyApp()); // Use for release mode
  runApp(
      DevicePreview(builder: (context) => const MyApp())); // Use for debug mode
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider<GoRouter>(
          create: (_) => getAppRouter(),
        ),
        RepositoryProvider(
          create: (_) => CacheRepo(),
        ),
        BlocProvider(
          create: (_) => CacheCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: context.read<GoRouter>(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
          );
        },
      ),
    );
  }
}

void _attachBlocObserver() {
  Bloc.observer = AppBlocObserver();
}
