class Subjects {
  int id;
  String subject;

  Subjects({required this.id, required this.subject});

  static fromJson(Map<String, dynamic> parsedJson) {
    return Subjects(id: parsedJson['id'], subject: parsedJson['subject']);
  }
}
