import 'dart:convert';

import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:http/http.dart' as http;
import 'package:open_project/add_work_package/models/week_day.dart';
import 'package:open_project/add_work_package/models/work_package_options.dart';
import 'package:open_project/add_work_package/models/work_package_payload.dart';
import 'package:open_project/add_work_package/models/work_package_properties.dart';
import 'package:open_project/core/constants/api_constants.dart';
import 'package:open_project/core/util/failure.dart';

class AddWorkPackageRepo {
  Future<AsyncResult<List<WeekDay>, NetworkFailure>> getWeekDays({
    required String serverUrl,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl${ApiConstants.listWeekDays}'),
        headers: ApiConstants.getHeaders(),
      );

      // Error handling
      if (response.statusCode == 400) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Invalid request'),
        );
      }
      // Extra safety measure
      else if (response.statusCode != 200) {
        throw Exception();
      }

      // Successful request --> parse JSON
      final responseJson = jsonDecode(response.body);

      final elements = responseJson['_embedded']['elements'] as List;

      final days = elements
          .map((e) => WeekDay.fromJson(e as Map<String, dynamic>))
          .toList();

      return AsyncResult.data(
        data: days,
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  Future<
      AsyncResult<({WorkPackageOptions options, WorkPackagePayload payload}),
          NetworkFailure>> getWorkPackageForm({
    required String serverUrl,
    required String? apiToken,

    /// When creating a work package, this refers to project id,
    /// when editing a work package, this refers to work package id,
    required int id,
    required Map<String, dynamic>? body,
    bool editMode = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$serverUrl${editMode ? ApiConstants.editWorkPackageForm(id) : ApiConstants.addWorkPackageForm(id)}'),
        headers: ApiConstants.getHeaders(apiToken, {
          'Content-Type': 'application/json',
        }),
        body: body == null ? null : json.encode(body),
      );

      // Error handling
      if (response.statusCode == 400) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Invalid request'),
        );
      }
      // Extra safety measure
      else if (response.statusCode != 200) {
        throw Exception();
      }

      // Successful request --> parse JSON
      final responseJson = jsonDecode(response.body);

      final wpOptions = WorkPackageOptions.fromJson(responseJson);
      final wpPayload = WorkPackagePayload.fromJson(responseJson, wpOptions);

      return AsyncResult.data(
        data: (options: wpOptions, payload: wpPayload),
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  Future<AsyncResult<List<WPUser>, NetworkFailure>> getProjectUsers({
    required String serverUrl,
    required String? apiToken,
    required int projectId,
    required ProjectMemberType projectMemberType,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$serverUrl${projectMemberType == ProjectMemberType.assignee ? ApiConstants.getAvailableAssignees(projectId) : ApiConstants.getAvailableResponsibles(projectId)}'),
        headers: ApiConstants.getHeaders(apiToken),
      );

      // Error handling
      if (response.statusCode == 400) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Invalid request'),
        );
      } else if (response.statusCode == 403) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Accessed Denied'),
        );
      } else if (response.statusCode == 404) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Project not found'),
        );
      }
      // Extra safety measure
      else if (response.statusCode != 200) {
        throw Exception();
      }

      // Successful request --> parse JSON
      final responseJson = jsonDecode(response.body);

      final elements = responseJson['_embedded']['elements'] as List;

      final users = elements
          .map((e) => WPUser.fromJson(e as Map<String, dynamic>))
          .toList();

      return AsyncResult.data(
        data: users,
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  Future<AsyncResult<void, NetworkFailure>> createWorkPackage({
    required String serverUrl,
    required String? apiToken,

    /// When creating a work package, this refers to project id,
    /// when editing a work package, this refers to work package id,
    required int id,
    required Map<String, dynamic>? payload,
    bool editMode = false,
  }) async {
    try {
      late http.Response response;
      if (editMode) {
        response = await http.patch(
          Uri.parse(
              '$serverUrl${ApiConstants.editWorkPackage(id)}?notify=false'),
          headers: ApiConstants.getHeaders(
            apiToken,
            {'Content-Type': 'application/json'},
          ),
          body: json.encode(payload),
        );
      } else {
        response = await http.post(
          Uri.parse(
              '$serverUrl${ApiConstants.addWorkPackage(id)}?notify=false'),
          headers: ApiConstants.getHeaders(
            apiToken,
            {'Content-Type': 'application/json'},
          ),
          body: json.encode(payload),
        );
      }

      // Error handling
      if (response.statusCode == 400) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Invalid request'),
        );
      } else if (response.statusCode == 403) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Forbidden'),
        );
      }
      // Extra safety measure
      else if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception();
      }

      // Successful request
      return AsyncResult.data(
        data: null,
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }
}
