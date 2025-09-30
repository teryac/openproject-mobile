// ignore_for_file: file_names, prefer_typing_uninitialized_variables

class Project {
  String description;
  String name;
  int id;

  Project({required this.description, required this.name, required this.id});

  static Project fromJson(Map<String, dynamic> parsedJson) {
    var description = parsedJson['description'];
    var raw = description['raw'];
    return Project(
        description: raw, name: parsedJson['name'], id: parsedJson['id']);
  }
}
