import 'package:go_router/go_router.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';
import 'package:open_project/core/util/cache_helper.dart';
import 'package:open_project/core/util/dependency_injection.dart';

extension CacheExtension on CacheHelper {
  Future<String> getServerUrl() async {
    final serverUrl = await serviceLocator<CacheHelper>().getData(
      AppConstants.serverUrlCacheKey,
    );

    if (serverUrl == null) {
      serviceLocator<GoRouter>().goNamed(AppRoutes.welcome.name);
      return '';
    }

    return serverUrl;
  }

  Future<String?> getApiToken() async {
    final apiToken = await serviceLocator<CacheHelper>().getData(
      AppConstants.apiTokenCacheKey,
    );

    return apiToken;
  }
}
