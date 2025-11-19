import 'dart:convert';

class ApiConstants {
  static const _base = "/api/v3/";

  static Map<String, String> getHeaders([
    String? apiToken,
    Map<String, String>? additionalHeaders,
  ]) {
    final basicAuth = apiToken == null
        ? null
        : 'Basic ${base64Encode(utf8.encode('apikey:$apiToken'))}';

    final headers = {
      'Accept': 'application/hal+json',
      if (basicAuth != null) 'Authorization': basicAuth,
    };

    headers.addAll(additionalHeaders ?? {});

    return headers;
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
    return '${_base}users/$userId/avatar.png';
  }

  // Work Packages screen
  static String workPackages(int projectId) {
    return '${_base}projects/$projectId/work_packages';
  }

  /// Returns all types available in project
  static String workPackagesTypesInProject(int projectId) {
    return '${_base}projects/$projectId/types';
  }

  /// Returns all work packages statuses to view their
  /// colors in the work packages screen, because the
  /// color is not provided within the work packages
  /// list API
  static const workPackageStatuses = '${_base}statuses';

  static const workPackagePriorities = '${_base}priorities';

  // Add/Edit Work Package screen

  /// Lists week days, used to separate work days from others
  /// in the date picker
  static const listWeekDays = '${_base}days/week';

  /// POST request
  static String addWorkPackageForm(int projectId) {
    return '${_base}projects/$projectId/work_packages/form';
  }

  /// POST request
  static String addWorkPackage(int projectId) {
    return '${_base}projects/$projectId/work_packages';
  }

  /// POST request
  static String editWorkPackageForm(int workPackageId) {
    return '${_base}work_packages/$workPackageId/form';
  }

  /// PATCH request
  static String editWorkPackage(int workPackageId) {
    return '${_base}work_packages/$workPackageId';
  }

  static String getAvailableAssignees(int projectId) {
    return '${_base}projects/$projectId/available_assignees';
  }

  static String getAvailableResponsibles(int projectId) {
    return '${_base}projects/$projectId/available_responsibles';
  }
}
