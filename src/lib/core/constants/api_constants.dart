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
  static String userAvatar(String id) {
    return '${_base}users/$id/avatar';
  }
}
