// ignore_for_file: file_names

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProcessingServer {
  Future<String?> getServer(String server) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri uri = Uri.parse("$server/api/v3/projects");
    Response response = await http.get(uri);

    if (response.statusCode == 200) {
      await prefs.setString('Server', server);
      return server;
    } else {
      return null;
    }
  }
}
