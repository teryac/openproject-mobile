import 'dart:convert';

import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:http/http.dart' as http;
import 'package:open_project/core/constants/api_constants.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/models/work_package_dependencies.dart';

class WorkPackagesRepo {
  Future<AsyncResult<PaginatedWorkPackages, NetworkFailure>> getWorkPackages({
    required String serverUrl,
    required String? apiToken,
    required int projectId,
    int page = 1,
    required WorkPackagesFilters workPackagesFilters,
  }) async {
    try {
      // Assign Page
      final pageText = '?offset=$page';

      // Assign Filters
      final filtersText = _workPackagesJsonFilters(workPackagesFilters);

      // Send request
      final response = await http.get(
        Uri.parse(
            '$serverUrl${ApiConstants.workPackages(projectId)}$pageText$filtersText'),
        headers: ApiConstants.getHeaders(apiToken),
      );

      // Error handling
      if (response.statusCode == 400) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Invalid request'),
        );
      } else if (response.statusCode == 403) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Insufficient permissions'),
        );
      }
      // Extra safety measure
      else if (response.statusCode != 200) {
        throw Exception();
      }

      // Successful request --> parse JSON
      final responseJson = jsonDecode(response.body);

      return AsyncResult.data(
        data: PaginatedWorkPackages.fromJson(
          responseJson,
          workPackagesFilters: workPackagesFilters,
        ),
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  Future<AsyncResult<List<WorkPackageType>, NetworkFailure>>
      getWorkPackageTypes({
    required String serverUrl,
    required int projectId,
  }) async {
    try {
      // Send request
      final response = await http.get(
        Uri.parse(
            '$serverUrl${ApiConstants.workPackagesTypesInProject(projectId)}?pageSize=-1'),
      );

      // Error handling
      if (response.statusCode == 404) {
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

      final List<dynamic>? elements =
          responseJson['_embedded']?['elements'] as List<dynamic>?;

      if (elements == null) {
        return const AsyncResult.data(data: []); // no elements found
      }

      // Map each JSON object to model
      final types = elements
          .map((e) => WorkPackageType.fromJson(e as Map<String, dynamic>))
          .toList();

      return AsyncResult.data(data: types);
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  Future<AsyncResult<List<WorkPackageStatus>, NetworkFailure>>
      getWorkPackageStatuses({
    required String serverUrl,
  }) async {
    try {
      // Send request
      final response = await http.get(
        Uri.parse('$serverUrl${ApiConstants.workPackageStatuses}?pageSize=-1'),
      );

      // Error handling
      if (response.statusCode == 403) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Forbidden'),
        );
      }

      // Extra safety measure
      else if (response.statusCode != 200) {
        throw Exception();
      }

      // Successful request --> parse JSON
      final responseJson = jsonDecode(response.body);

      final List<dynamic>? elements =
          responseJson['_embedded']?['elements'] as List<dynamic>?;

      if (elements == null) {
        return const AsyncResult.data(data: []); // no elements found
      }

      // Map each JSON object to model
      final statuses = elements
          .map((e) => WorkPackageStatus.fromJson(e as Map<String, dynamic>))
          .toList();

      return AsyncResult.data(data: statuses);
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  Future<AsyncResult<List<WorkPackagePriority>, NetworkFailure>>
      getWorkPackagePriorities({
    required String serverUrl,
  }) async {
    try {
      // Send request
      final response = await http.get(
        Uri.parse('$serverUrl${ApiConstants.workPackagePriorities}?pageSize=-1'),
      );

      // Error handling
      if (response.statusCode == 403) {
        return const AsyncResult.error(
          error: NetworkFailure(errorMessage: 'Forbidden'),
        );
      }

      // Extra safety measure
      else if (response.statusCode != 200) {
        throw Exception();
      }

      // Successful request --> parse JSON
      final responseJson = jsonDecode(response.body);

      final List<dynamic>? elements =
          responseJson['_embedded']?['elements'] as List<dynamic>?;

      if (elements == null) {
        return const AsyncResult.data(data: []); // no elements found
      }

      // Map each JSON object to model
      final priorities = elements
          .map((e) => WorkPackagePriority.fromJson(e as Map<String, dynamic>))
          .toList();

      return AsyncResult.data(data: priorities);
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }
}

/// Builds the list of filters for the API request based on the provided model.
String _workPackagesJsonFilters(WorkPackagesFilters filters) {
  final List<Map<String, dynamic>> apiFilters = [];

  // Filter 1: Subject
  // {"subject":{"operator":"~","values":["Create"]}}
  if (filters.name != null && filters.name!.trim().isNotEmpty) {
    apiFilters.add({
      "subject": {
        "operator": "~", // "~" means "contains"
        "values": [filters.name]
      }
    });
  }

  // Filter 2: Status
  // {"status":{"operator":"=","values":[1]}}
  if (filters.statusId != null) {
    apiFilters.add({
      "status": {
        "operator": "=", // "=" means "equals"
        "values": [filters.statusId] // Pass as a number
      }
    });
  }

  // Filter 3: Type
  // {"type":{"operator":"=","values":[3]}}
  if (filters.typeId != null) {
    apiFilters.add({
      "type": {
        "operator": "=",
        "values": [filters.typeId] // Pass as a number
      }
    });
  }

  // Filter 4: Due Date (as "isOverdue")
  // {"dueDate": {"operator": "<t-", "values": ["0"]}}
  if (filters.isOverdue != null && filters.isOverdue == true) {
    apiFilters.add({
      "dueDate": {
        "operator": "<t-", // "<t-" means "days ago"
        "values": ["0"] // "0" days ago (i.e., any date before today)
      }
    });
  }

  // Filter 5: Priority
  // {"priority":{"operator":"=","values":["10"]}}
  if (filters.priorityId != null) {
    apiFilters.add({
      "priority": {
        "operator": "=",
        // Note: The API example uses a string for priority ID.
        "values": [filters.priorityId.toString()]
      }
    });
  }

  if (apiFilters.isEmpty) return '';

  final json = Uri.encodeQueryComponent(jsonEncode(apiFilters));

  return '&filters=$json';
}
