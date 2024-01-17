class Task {
  int id;
  String task;

  Task({required this.id, required this.task});

  static fromJson(Map<String, dynamic> parsedJson) {
    return Task(id: parsedJson['id'], task: parsedJson['subject']);
  }
}
