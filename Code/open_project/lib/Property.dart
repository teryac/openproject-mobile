class Property {
  String name;
  int id;

  Property({required this.id, required this.name});

  static fromJson(Map<String, dynamic> parsedJson) {
    return Property(id: parsedJson['id'], name: parsedJson['name']);
  }
}
