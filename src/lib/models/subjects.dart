// ignore_for_file: file_names, prefer_typing_uninitialized_variables

class Subjects {
  int id;
  String subject;
  String description;
  String status;

  Subjects(
      {required this.id,
      required this.subject,
      required this.description,
      required this.status});

  static Subjects fromJson(Map<String, dynamic> parsedJson) {
    var description = parsedJson['description'];
    var raw = description['raw'];
    return Subjects(
        id: parsedJson['id'],
        subject: parsedJson['subject'],
        description: raw,
        status: parsedJson['status']);
  }
}
