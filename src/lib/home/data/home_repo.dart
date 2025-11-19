import 'dart:convert';

import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:http/http.dart' as http;
import 'package:open_project/core/constants/api_constants.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:open_project/home/models/paginated_projects.dart';

class HomeRepo {
  Future<AsyncResult<PaginatedProjects, NetworkFailure>> getProjects({
    required String serverUrl,
    required String? apiToken,
    int page = 1,
    required ProjectsFilters projectsFilters,
  }) async {
    try {
      // Assign Page
      final pageText = '?offset=$page';

      // Assign Filters
      final filters = <Map<String, dynamic>>[];

      if (projectsFilters.name != null &&
          projectsFilters.name!.trim().isNotEmpty) {
        filters.add({
          "name": {
            "operator": "~",
            "values": [projectsFilters.name]
          }
        });
      }
      if (projectsFilters.public != null) {
        filters.add({
          "public": {
            "operator": "=",
            "values": [projectsFilters.public! ? 't' : 'f']
          }
        });
      }

      final filtersText = filters.isEmpty
          ? ''
          : '&filters=${Uri.encodeQueryComponent(jsonEncode(filters))}';

      // Send request
      final response = await http.get(
        Uri.parse('$serverUrl${ApiConstants.projects}$pageText$filtersText'),
        headers: ApiConstants.getHeaders(apiToken),
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
      return AsyncResult.data(
        data: PaginatedProjects.fromJson(
          responseJson,
          projectsFilters: projectsFilters,
        ),
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(errorMessage: 'An error occurred'),
      );
    }
  }

  String getProjectStatusColor(String? id) {
    final defaultColor = '#848D90';
    final colorMap = {
      'at_risk': '#C14200',
      'on_track': '#008A36',
      'off_track': '#D90022',
      'not_started': '#245090',
      'finished': '#9600E1',
      'dicontinued': '#9B6A00',
    };

    return colorMap[id] ?? defaultColor;
  }
}
