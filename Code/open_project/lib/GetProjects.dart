import 'dart:convert';

import 'package:open_project/Project.dart';
import 'package:http/http.dart' as http;

class GetProjects {
  late List<Project> projects;

  List<Project> getData() {
    Uri uri = Uri.parse("https://op.yaman-ka.com/api/v3/projects");

    http.get(uri).then((response) {
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
    });
    return projects;
  }
}
