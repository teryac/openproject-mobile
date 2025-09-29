// ignore_for_file: file_names

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:open_project/Models/project.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProcessingProjects {
  List<Project> projects = [];

  Future<List<Project>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var server = prefs.getString('Server');
    Uri uri = Uri.parse("$server/api/v3/projects");

    await http.get(uri).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var embedded = jsonResponse['_embedded'];
        var elements = embedded['elements'] as List;

// Loop through the elements to extract 'description' -> 'raw'
        projects = elements.map((data) {
          // Safely access the raw field
          String rawDescription =
              data['description']?['raw'] ?? 'No description available';
          String name = data['name'];
          int id = data['id'];

          return Project(description: rawDescription, name: name, id: id);
        }).toList();

        //setState(() {
        //data = projects;
        //});
        return projects;
      } else {
        throw Exception(
            "Failed to load projects. Status code: ${response.statusCode}");
      }
    });
    return projects;
  }

  Future<List<Project>> getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var server = prefs.getString('Server');
    var apikey = prefs.getString('apikey');
    var token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    Response r = await get(Uri.parse('$server/api/v3/projects'),
        headers: <String, String>{'authorization': basicAuth});
    if (r.statusCode == 200) {
      var jsonResponse = jsonDecode(r.body);

      // Access the '_embedded' object
      var embedded = jsonResponse['_embedded'];

      // Access the 'elements' list
      var elements = embedded['elements'] as List;

      // Loop through the elements to extract 'description' -> 'raw'
      projects = elements.map((data) {
        // Safely access the raw field
        String rawDescription =
            data['description']?['raw'] ?? 'No description available';
        String name = data['name'];
        int id = data['id'];

        return Project(description: rawDescription, name: name, id: id);
      }).toList();

      return projects;
    } else {
      Fluttertoast.showToast(msg: 'HTTP Error ${r.statusCode}');
    }
    return projects;
  }
}
