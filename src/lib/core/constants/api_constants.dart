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

  static const root = _base;
  static const projects = '${_base}projects';
  static const userInfo = '${_base}users';
}
