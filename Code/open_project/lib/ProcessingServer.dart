import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProcessingServer {
  Future<String?> getServer(String server) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri uri = Uri.parse("$server/api/v3/projects");
    Response response =
        await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      await prefs.setString('server', server);
      return server;
    } else {
      return null;
    }
  }
}
