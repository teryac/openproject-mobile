import 'dart:convert';

import 'package:open_project/Project.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProcessingProjects {
  List<Project> projects = [];

  Future<List<Project>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var server = prefs.getString('Server');
    Uri uri = Uri.parse("$server/api/v3/projects");

    http.get(uri).then((response) {
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
}
