import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:open_project/core/constants/api_endpoints.dart';
import 'package:open_project/core/util/failure.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  Future<AsyncResult<void, NetworkFailure>> pingServer(String serverUrl) async {
    try {
      await http.get(
        Uri.parse(serverUrl),
        headers: ApiConstants.headers,
      );

      return const AsyncResult.data(
        data: null,
        // error: NetworkFailure(errorMessage: 'test'),
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
