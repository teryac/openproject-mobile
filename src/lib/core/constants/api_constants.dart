import 'dart:convert';

class ApiConstants {
  static const _base = "/api/v3/";

  static Map<String, String> getHeaders([String? apiToken]) {
    final basicAuth = apiToken == null
        ? null
        : 'Basic ${base64Encode(utf8.encode('apikey:$apiToken'))}';

    return {
      'Accept': 'application/hal+json',
      if (basicAuth != null) 'Authorization': basicAuth,
    };
  }

  // Ping server
  static const root = _base;

  /// Use "me" for the `id` if authorization is available in headers
  static String userInfo(String id) {
    return '${_base}users/$id';
  }

  // Projects list
  static const projects = '${_base}projects';

  /// Use "me" for the `id` if authorization is available in headers
  static String userAvatar(String userId) {
    return '${_base}users/$userId/avatar';
  }

  // Work Packages screen
  static String workPackages(int projectId) {
    return '${_base}projects/$projectId/work_packages';
  }

  /// Returns all work packages statuses to view their
  /// colors in the work packages screen, because the
  /// color is not provided within the work packages
  /// list API
  static const statuses = '${_base}statuses';
}
