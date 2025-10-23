import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/util/cache_helper.dart';

final serviceLocator = GetIt.instance;

void setupDependencyInjection() {
  // Register app router
  serviceLocator.registerSingleton<GoRouter>(getAppRouter());

  // Register app cache helper
  serviceLocator.registerSingleton<CacheHelper>(
    const CacheHelper(),
  );
}
