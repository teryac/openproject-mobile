import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:http/http.dart' as http;
import 'package:open_project/core/constants/api_constants.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/work_packages/models/paginated_work_packages.dart';
import 'package:open_project/work_packages/models/work_package_dependencies.dart';
import 'package:open_project/work_packages/models/work_package_filters.dart';

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
      final response = await http
          .get(
            Uri.parse(
                '$serverUrl${ApiConstants.workPackages(projectId)}$pageText$filtersText'),
            headers: ApiConstants.getHeaders(apiToken),
          )
          .timeout(
            const Duration(seconds: 15),
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
    } on TimeoutException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'Timed out'),
      );
    } on SocketException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'No internet connection'),
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
    required String? apiToken,
    required int projectId,
  }) async {
    try {
      // Send request
      final response = await http
          .get(
            Uri.parse(
                '$serverUrl${ApiConstants.workPackagesTypesInProject(projectId)}?pageSize=-1'),
            headers: ApiConstants.getHeaders(apiToken),
          )
          .timeout(
            const Duration(seconds: 15),
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
    } on TimeoutException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'Timed out'),
      );
    } on SocketException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'No internet connection'),
      );
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
      final response = await http
          .get(
            Uri.parse(
                '$serverUrl${ApiConstants.workPackageStatuses}?pageSize=-1'),
            headers: ApiConstants.getHeaders(),
          )
          .timeout(
            const Duration(seconds: 15),
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
    } on TimeoutException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'Timed out'),
      );
    } on SocketException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'No internet connection'),
      );
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
      final response = await http
          .get(
            Uri.parse(
                '$serverUrl${ApiConstants.workPackagePriorities}?pageSize=-1'),
            headers: ApiConstants.getHeaders(),
          )
          .timeout(
            const Duration(seconds: 15),
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
    } on TimeoutException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'Timed out'),
      );
    } on SocketException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'No internet connection'),
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  /// Deletes a work package, and returns its id if it succeeds
  Future<AsyncResult<void, NetworkFailure>> deleteWorkPackage({
    required String serverUrl,
    required String? apiToken,
    required int id,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$serverUrl${ApiConstants.deleteWorkPackage(id)}'),
            headers: ApiConstants.getHeaders(apiToken),
          )
          .timeout(
            const Duration(seconds: 15),
          );

      // Error handling
      final errorsMap = {
        400: 'Invalid request',
        403: 'Forbidden',
        404: 'Work package not found',
      };

      if (errorsMap.containsKey(response.statusCode)) {
        return AsyncResult.error(
          error: NetworkFailure(
            errorMessage: errorsMap[response.statusCode]!,
          ),
        );
      }

      // Extra safety measure
      else if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception();
      }

      // Successful request
      return AsyncResult.data(data: null);
    } on TimeoutException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'Timed out'),
      );
    } on SocketException catch (_) {
      return AsyncResult.error(
        error: NetworkFailure(errorMessage: 'No internet connection'),
      );
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

  // Subject (contains)
  if (filters.name != null && filters.name!.trim().isNotEmpty) {
    apiFilters.add({
      "subject": {
        "operator": "~",
        "values": [filters.name]
      }
    });
  }

  // Status (supports multiple IDs)
  if (filters.statusIDs != null && filters.statusIDs!.isNotEmpty) {
    apiFilters.add({
      "status": {
        "operator": "=",
        "values": filters.statusIDs,
      }
    });
  }

  // Type (supports multiple IDs)
  if (filters.typeIDs != null && filters.typeIDs!.isNotEmpty) {
    apiFilters.add({
      "type": {
        "operator": "=",
        "values": filters.typeIDs,
      }
    });
  }

  // Overdue flag
  if (filters.isOverdue == true) {
    apiFilters.add({
      "dueDate": {
        "operator": "<t-",
        "values": ["0"]
      }
    });
  }

  // Priority (supports multiple IDs, converted to string as per API example)
  if (filters.priorityIDs != null && filters.priorityIDs!.isNotEmpty) {
    apiFilters.add({
      "priority": {
        "operator": "=",
        "values": filters.priorityIDs!.map((e) => e.toString()).toList(),
      }
    });
  }

  if (apiFilters.isEmpty) return '';

  final encoded = Uri.encodeQueryComponent(jsonEncode(apiFilters));
  return '&filters=$encoded';
}
