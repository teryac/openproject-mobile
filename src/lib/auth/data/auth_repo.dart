import 'dart:convert';

import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:open_project/auth/models/user.dart';
import 'package:open_project/core/constants/api_constants.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  Future<AsyncResult<void, NetworkFailure>> pingServer(String serverUrl) async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl${ApiConstants.root}'),
        headers: ApiConstants.getHeaders(),
      );

      final responseJson = jsonDecode(response.body);
      if (response.statusCode == 404 ||
          // If a server not related to OpenProject has a valid
          // "/v3/api" endpoint, a 200 status code is recieved.
          // However, an error should be thrown in this case
          // because it's not a valid OpenProject server, therefore
          // we check if the json returned by the server is a valid
          // open project response by checking `_type` to be "Root"
          responseJson['_type'] != 'Root') {
        return const AsyncResult.error(
          error: NetworkFailure(
            statusCode: 404,
            errorMessage: 'Server not found',
          ),
        );
      }

      return const AsyncResult.data(data: null);
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(
          errorMessage: 'An error occurred',
        ),
      );
    }
  }

  Future<AsyncResult<User, NetworkFailure>> getUser({
    required String serverUrl,
    required String apiToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$serverUrl${ApiConstants.userInfo}/me'),
        headers: ApiConstants.getHeaders(apiToken),
      );

      // When the path parameter `id` is set to "me" instead of
      // the user id (it depends on the api token in this case
      // - id = "me" -), 401 is return when the user api token
      // is invalid not 404 which is the case when an integer is
      // used for the `id` path parameter
      if (response.statusCode == 401) {
        return const AsyncResult.error(
          error: NetworkFailure(
            statusCode: 401,
            errorMessage: 'User not found',
          ),
        );
      }

      return AsyncResult.data(
        data: User.fromJson(
          jsonDecode(response.body),
        ),
      );
    } catch (exception) {
      return const AsyncResult.error(
        error: NetworkFailure(
          errorMessage: 'An error occurred',
        ),
      );
    }
  }
}
