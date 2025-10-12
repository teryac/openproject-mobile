import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/navigation/router.dart';

final serviceLocator = GetIt.instance;

void setupDependencyInjection() {
  // Register app router
  serviceLocator.registerSingleton<GoRouter>(getAppRouter());
}
