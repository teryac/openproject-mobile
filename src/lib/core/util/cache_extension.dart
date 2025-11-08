import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_project/core/cache/cache_cubit.dart';
import 'package:open_project/core/constants/app_constants.dart';
import 'package:open_project/core/navigation/router.dart';

extension CacheExtension on BuildContext {
  String? getServerUrl() {
    final cacheData = read<CacheCubit>().state;

    // This is an extra safety gaurd
    if (cacheData[AppConstants.serverUrlCacheKey] == null) {
      // This means that the user is not authenticated
      goNamed(AppRoutes.auth.name);
      return null;
    }

    return cacheData[AppConstants.serverUrlCacheKey];
  }

  String? getApiToken() {
    final cacheData = read<CacheCubit>().state;

    return cacheData[AppConstants.apiTokenCacheKey];
  }
}
