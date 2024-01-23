class Task {
  int id /*, percentageDone*/;
  String subject /*, startdate, duedate, estimatedTime, updatedAt*/;

  Task({required this.id, required this.subject});

  static fromJson(Map<String, dynamic> parsedJson) {
    return Task(id: parsedJson['id'], subject: parsedJson['subject']);
  }
}
