class Project {
  var description;
  String name;
  int id;

  Project({required this.description, required this.name, required this.id});

  static fromJson(Map<String, dynamic> parsedJson) {
    var description = parsedJson['description'];
    var raw = description['raw'];
    return Project(
        description: raw, name: parsedJson['name'], id: parsedJson['id']);
  }
}
