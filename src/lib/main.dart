// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/cache/cache_repo.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/styles/themes.dart';
import 'package:open_project/core/util/bloc_observer.dart';

void main() async {
  _attachBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebaseCrashlytics();

  runApp(const MyApp()); // Use for release mode
  // runApp(DevicePreview(builder: (_) => const MyApp())); // Use for debug mode
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

Future<void> _initializeFirebaseCrashlytics() async {
  await Firebase.initializeApp();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
