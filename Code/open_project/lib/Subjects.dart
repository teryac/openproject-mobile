class Subjects {
  int id;
  String subject;
  var description;

  Subjects(
      {required this.id, required this.subject, required this.description});

  static fromJson(Map<String, dynamic> parsedJson) {
    var description = parsedJson['description'];
    var raw = description['raw'];
    return Subjects(
        id: parsedJson['id'], subject: parsedJson['subject'], description: raw);
  }
}
